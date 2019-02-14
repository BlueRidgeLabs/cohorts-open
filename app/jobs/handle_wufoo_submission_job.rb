# frozen_string_literal: true
class HandleWufooSubmissionJob < ApplicationJob
  queue_as :default

  def perform(params)
    @submission = Submission.new(
      raw_content: params.reject { |k, _| %w(FieldStructure FormStructure).include? k }.to_json,
      form_structure: params['FormStructure'], field_structure: params['FieldStructure'], ip_addr: params['IP'],
      form: Form.find_by(hash_id: JSON.parse(params['FormStructure'])['Hash']), entry_id: params['EntryId']
    )
    @submission.find_form_type
    @submission.find_person
    if @submission.save
      Rails.logger.info("[HandleWufooSubmissionJob] Recorded a new Wufoo submission for #{@submission.person&.full_name}")
    else
      Rails.logger.warn('[HandleWufooSubmissionJob] Failed to save new Wufoo submission')
    end
  end
end
