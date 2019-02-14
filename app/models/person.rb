# frozen_string_literal: true
# FIXME: Refactor and re-enable cop
# rubocop:disable ClassLength
class Person < ActiveRecord::Base
  searchkick
  has_paper_trail
  include ExternalDataMappings

  phony_normalize :phone_number, default_country_code: 'US'
  phony_normalized_method :phone_number, default_country_code: 'US'

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :contacts, as: :contactable, dependent: :destroy
  has_many :submissions, dependent: :destroy
  has_many :forms, through: :submissions
  belongs_to :signup_form, class_name: 'Form'
  has_many :answers, dependent: :destroy
  has_many :questions, through: :answers
  has_many :session_invites
  has_many :research_sessions, through: :session_invites

  has_many :gift_cards, dependent: :destroy
  accepts_nested_attributes_for :gift_cards, reject_if: :all_blank
  attr_accessor :gift_cards_attributes

  has_many :tags, through: :taggings
  has_many :taggings, as: :taggable, dependent: :destroy

  has_many :person_traits, dependent: :destroy
  has_many :traits, through: :person_traits

  has_secure_token :token

  after_save :send_to_mailchimp, unless: -> { Rails.env.test? }

  validates :first_name, presence: true
  validates :last_name, presence: true

  # if ENV['BLUE_RIDGE'].nil?
  #   validates :primary_device_id, presence: true
  #   validates :primary_device_description, presence: true
  #   validates :primary_connection_id, presence: true
  #   validates :primary_connection_description, presence: true
  # end

  # validates :postal_code, presence: true
  # validates :postal_code, zipcode: { country_code: :us }

  # phony validations and normalization
  phony_normalize :phone_number, default_country_code: 'US'

  validates :phone_number, presence: true, length: { in: 9..15 }, unless: -> { email_address.present? }

  validates :email_address, presence: true, unless: -> { phone_number.present? }
  validates :email_address, uniqueness: true, unless: -> { email_address.blank? }

  scope :no_signup_card, (-> { where('id NOT IN (SELECT DISTINCT(person_id) FROM gift_cards where gift_cards.reason = 1)') })
  scope :signup_card_needed, (-> { joins(:gift_cards).where('gift_cards.reason !=1') })

  scope :with_email, (-> { where.not(email_address: nil) })
  scope :with_phone, (-> { where.not(phone_number: nil) })

  # For Searchkick
  def search_data
    attributes.
      each { |_k, v| v.downcase if v.is_a? String }.
      merge(search_data_attributes)
  end

  # To reduce Rubocop's ABC score
  def search_data_attributes
    {
      tag: tags.map { |t| t.name.downcase },
      trait: person_traits.map { |pt| format('%s:%s', traits.find(pt.trait_id).name.downcase, pt.value.downcase) },
      question: questions.map(&:id),
      answer: answers.map { |a| a.value.downcase },
      last_participated: last_participation_date.to_s,
      signup_at: signup_at.to_s,
      full_name: full_name,
      last_contacted: last_contacted.to_s
    }
  end

  def last_participation_date
    if research_sessions.any?
      research_sessions.order(datetime: :desc).first.datetime.to_date
    elsif (value = traits.find_by(name: 'Vets.Gov Last Participated')&.person_traits&.find_by(person: self)&.value)
      Date.parse(value)
    else
      50.years.ago.to_date
    end
  end

  def signup_gc_sent
    signup_cards = gift_cards.where(reason: 1)
    return true unless signup_cards.empty?
    false
  end

  def gift_card_total
    total = gift_cards.sum(:amount_cents)
    Money.new(total, 'USD')
  end

  def tag_values
    tags.collect(&:name)
  end

  def tag_count
    tags.size
  end

  def submission_values
    submissions.collect(&:submission_values)
  end

  # FIXME: Refactor and re-enable cop
  # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Rails/TimeZone
  #
  def self.initialize_from_wufoo_sms(params)
    new_person = Person.new

    # Save to Person
    new_person.first_name = params['Field275']
    new_person.last_name = params['Field276']
    new_person.address_1 = params['Field268']
    new_person.postal_code = params['Field271']
    new_person.email_address = params['Field279']
    new_person.phone_number = params['field281']
    new_person.primary_device_id = case params['Field39'].upcase
                                   when 'A'
                                     Person.map_device_to_id('Desktop computer')
                                   when 'B'
                                     Person.map_device_to_id('Laptop')
                                   when 'C'
                                     Person.map_device_to_id('Tablet')
                                   when 'D'
                                     Person.map_device_to_id('Smart phone')
                                   else
                                     params['Field39']
                                   end

    new_person.primary_device_description = params['Field21']

    new_person.primary_connection_id = case params['Field41'].upcase
                                       when 'A'
                                         Person.primary_connection_id('Broadband at home')
                                       when 'B'
                                         Person.primary_connection_id('Phone plan with data')
                                       when 'C'
                                         Person.primary_connection_id('Public wi-fi')
                                       when 'D'
                                         Person.primary_connection_id('Public computer center')
                                       else
                                         params['Field41']
                                       end

    new_person.preferred_contact_method = if params['Field278'].casecmp('TEXT')
                                            'SMS'
                                          else
                                            'EMAIL'
                                          end

    new_person.verified = 'Verified by Text Message Signup'
    new_person.signup_at = Time.now

    new_person
  end
  # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Rails/TimeZone

  # FIXME: Refactor and re-enable cop
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/BlockNesting, Style/VariableName, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  #
  def send_to_mailchimp
    if email_address.present?
      if verified.present?
        if verified.start_with?('Verified')
          begin

            gibbon = Gibbon::Request.new
            mailchimpSend = gibbon.lists(Cohorts::Application.config.cohorts_mailchimp_list_id).members(Digest::MD5.hexdigest(email_address.downcase)).upsert(
              body: { email_address: email_address.downcase,
                      status: 'subscribed',
                      merge_fields: { FNAME: first_name || '',
                                      LNAME: last_name || '',
                                      MMERGE3: geography_id || '',
                                      MMERGE4: postal_code || '',
                                      MMERGE5: participation_type || '',
                                      MMERGE8: primary_device_description || '',
                                      MMERGE9: secondary_device_id || '',
                                      MMERGE10: secondary_device_description || '',
                                      MMERGE11: primary_connection_id || '',
                                      MMERGE12: primary_connection_description || '',
                                      MMERGE13: primary_device_id || '',
                                      MMERGE14: preferred_contact_method || '' } }
            )

            Rails.logger.info("[People->send_to_mailchimp] Sent #{id} to Mailchimp: #{mailchimpSend}")
          rescue Gibbon::MailChimpError => e
            Rails.logger.fatal("[People->send_to_mailchimp] fatal error sending #{id} to Mailchimp: #{e.message}")
          end
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Style/MethodName, Metrics/BlockNesting, Style/VariableName, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def self.initialize_from_wufoo(params)
    Person.new.tap do |person|
      person.signup_form = Form.find_by(hash_id: JSON.parse(params['FormStructure'])['Hash'])
      mapping = person.signup_form.mapping
      params.each_pair do |k, v|
        person[mapping[k]] = v if mapping[k].present?
      end
      if params['HandshakeKey'] == "#{Cohorts::Application.config.wufoo_handshake_key_prefix}-standard-signup"
        person.primary_connection_description = person.primary_connection_id
        person.primary_device_id = Person.map_device_to_id(params[mapping.rassoc('primary_device_id').first])
      end
      person.signup_at = params['DateCreated']
    end
  end

  def primary_device_type_name
    if primary_device_id.present?
      Cohorts::Application.config.device_mappings.rassoc(primary_device_id)[0].to_s
    end
  end

  def secondary_device_type_name
    if secondary_device_id.present?
      Cohorts::Application.config.device_mappings.rassoc(secondary_device_id)[0].to_s
    end
  end

  def primary_connection_type_name
    if primary_connection_id.present?
      Cohorts::Application.config.connection_mappings.rassoc(primary_connection_id)[0].to_s
    end
  end

  def secondary_connection_type_name
    if secondary_connection_id.present?
      Cohorts::Application.config.connection_mappings.rassoc(secondary_connection_id)[0].to_s
    end
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def initials
    first_name[0] + last_name[0]
  end

  def address_fields_to_sentence
    [address_1, address_2, city, state, postal_code].reject(&:blank?).join(', ')
  end

  def city_state_to_sentence
    [city, state].reject(&:blank?).join(', ')
  end

  def address?
    address_fields_to_sentence.present?
  end

  def deactivate!(method = nil)
    self.active = false
    self.deactivated_at = Time.current
    self.deactivated_method = method if method
    save!
  end

  # Compare to other records in the database to find possible duplicates.
  def possible_duplicates
    @duplicates = {}
    check_last_name_duplicates if last_name.present?
    check_email_duplicates if email_address.present?
    check_phone_number_duplicates if phone_number.present?
    check_address_duplicates if address_1.present?
    @duplicates
  end

  def check_last_name_duplicates
    last_name_duplicates = Person.where(last_name: last_name).where.not(id: id)
    last_name_duplicates.each do |duplicate|
      duplicate_hash = {}
      duplicate_hash['person'] = duplicate
      duplicate_hash['match_count'] = 1
      duplicate_hash['last_name_match'] = true
      duplicate_hash['matches_on'] = ['Last Name']
      @duplicates[duplicate.id] = duplicate_hash
    end
  end

  def check_email_duplicates
    email_address_duplicates = Person.where(email_address: email_address).where.not(id: id)
    email_address_duplicates.each do |duplicate|
      add_duplicate(duplicate, 'Email Address')
      @duplicates[duplicate.id]['email_address_match'] = true
    end
  end

  def check_phone_number_duplicates
    phone_number_duplicates = Person.where(phone_number: phone_number).where.not(id: id)
    phone_number_duplicates.each do |duplicate|
      add_duplicate(duplicate, 'Phone Number')
      @duplicates[duplicate.id]['phone_number_match'] = true
    end
  end

  def check_address_duplicates
    address_1_duplicates = Person.where(address_1: address_1).where.not(id: id)
    address_1_duplicates.each do |duplicate|
      add_duplicate(duplicate, 'Address_1')
      @duplicates[duplicate.id]['address_1_match'] = true
    end
  end

  def add_duplicate(duplicate, type)
    if @duplicates.key? duplicate.id
      @duplicates[duplicate.id]['match_count'] += 1
      @duplicates[duplicate.id]['matches_on'].push(type)
    else
      @duplicates[duplicate.id] = {}
      @duplicates[duplicate.id]['person'] = duplicate
      @duplicates[duplicate.id]['match_count'] = 1
      @duplicates[duplicate.id]['matches_on'] = [type]
    end
  end

end
# rubocop:enable ClassLength
