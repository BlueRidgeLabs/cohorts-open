# frozen_string_literal: true
class Form < ActiveRecord::Base
  IGNORED_FIELDS = ['entry id', 'date created', 'created by', 'last updated', 'updated by',
                    'name', 'email', 'email address', 'phone', 'phone number', 'address'].freeze
  has_many :submissions
  has_many :questions
  has_many :answers, through: :submissions
  after_create :create_questions
  after_update :delete_questions, if: -> { hidden }
  before_save :downcase_keyword, if: -> { twilio_keyword_changed? }
  validates_uniqueness_of :hash_id

  # rubocop:disable Metrics/AbcSize
  def self.update_forms
    wufoo_forms = Cohorts::Application.config.wufoo.forms
    wufoo_forms.each do |wufoo_form|
      form = Form.find_or_create_by(hash_id: wufoo_form.details['Hash'])
      next if form.hidden
      form.hash_id = wufoo_form.details['Hash']
      form.name = wufoo_form.details['Name']
      form.description = wufoo_form.details['Description']
      form.url = wufoo_form.details['Url']
      form.created_on = Time.zone.parse(wufoo_form.details['DateCreated'])
      if form.last_update != Time.zone.parse(wufoo_form.details['DateUpdated'])
        form.last_update = Time.zone.parse(wufoo_form.details['DateUpdated'])
        form.update_questions
      end
      form.save
    end
  end
  # rubocop:enable Metrics/AbcSize

  def wufoo_form
    Cohorts::Application.config.wufoo.form(hash_id)
  end

  delegate :fields, :flattened_fields, :entries, :details, to: :wufoo_form

  def wufoo_last_updated
    Time.zone.parse(wufoo_form.details['DateUpdated'])
  end

  def wufoo_entry(id)
    entries(filters: [['EntryId', 'Is_equal_to', id.to_s]]).first&.reject { |_, v| v.blank? }
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create_question(field)
    return if IGNORED_FIELDS.include? field['Title'].downcase
    question = Question.new(
      form: self,
      field_id: field['ID'],
      text: field['Title'],
      datatype: field['Type'],
      version_date: last_update
    )
    case field['Type']
    when 'radio', 'select'
      question.choices = field['Choices'].map { |c| c['Label'] }
    when 'likert'
      choices = field['Choices'].map { |c| c['Label'] }
      field['SubFields'].each do |sf|
        Question.create(
          form: self,
          field_id: sf['ID'],
          text: sf['Label'],
          datatype: 'radio',
          choices: choices,
          version_date: last_update
        )
      end
    when 'shortname', 'address'
      question.subfields = field['SubFields'].map { |sf| sf['ID'] }
    when 'checkbox'
      question.subfields = field['SubFields'].map { |sf| sf['ID'] }
      question.choices = field['SubFields'].map { |sf| sf['Label'] }
    end
    question.save
  end

  def create_questions
    fields.each { |field| create_question(field) }
  end

  def update_questions
    fields.each do |field|
      question = Question.find_by(
        form: self,
        field_id: field['ID'],
        text: field['Title'],
        datatype: field['Type']
      )
      if question
        question.update(version_date: wufoo_last_updated)
      else
        create_question(field)
      end
    end
  end

  def delete_questions
    questions.each(&:delete)
  end

  def downcase_keyword
    self.twilio_keyword = twilio_keyword.downcase
  end
end
