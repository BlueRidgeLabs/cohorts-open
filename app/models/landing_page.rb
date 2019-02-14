# frozen_string_literal: true
class LandingPage < ActiveRecord::Base
  FORMAT_TYPES = %w(hero simple).freeze

  belongs_to :form

  belongs_to :tag
  accepts_nested_attributes_for :tag, reject_if: :tag_exists?

  has_attached_file :image, styles: { thumb: '128x96>', large: '1024x768>' }

  validate :lede_or_body_or_image_present
  validates :form, presence: true
  validates :tag, presence: true, uniqueness: true
  validates_attachment_content_type :image, content_type: %r{\Aimage\/.*\z}

  def self.for_tag(tag_name)
    find_by(tag: Tag.find_by(name: tag_name))
  end

  def simple_format?
    format == 'simple'
  end

  private

    def lede_or_body_or_image_present
      if lede.blank? && body.blank? && image.blank?
        errors.add(:base, 'Specify a Lede, Body, or Image')
      end
    end

    def tag_exists?(attributes)
      self.tag = Tag.find_by(name: attributes['name'])
    end
end
