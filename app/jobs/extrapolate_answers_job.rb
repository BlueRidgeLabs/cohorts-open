# frozen_string_literal: true
class ExtrapolateAnswersJob < ActiveJob::Base # rubocop:disable Metrics/ClassLength
  queue_as :default

  def map_answer_directly(old_question_text, new_question_text)
    old_question = Question.find_by(text: old_question_text)
    new_question = Question.find_by(text: new_question_text)
    Answer.where(question_id: old_question.id).each do |old_answer|
      new_answer = Answer.new do |a|
        a.person_id = old_answer.person_id
        a.question_id = new_question.id
        a.value = old_answer.value
      end

      ExtrapolatedAnswer.create(answer: new_answer)
    end
  end

  def add_to_options(options, text)
    if options.include?(text)
      options
    else
      options << text
    end
  end

  def map_race_or_ethnicity_option(option)
    option == 'Hispanic or Latino' ? 'Hispanic, Latino, or Spanish Origin' : option
  end

  def map_race_or_ethnicity
    old_question = Question.find_by(text: 'Race or ethnic background')
    new_question = Question.find_by(text: 'I identify as:')
    Answer.where(question_id: old_question.id).each do |old_answer|
      new_answer = Answer.new do |a|
        a.person_id = old_answer.person_id
        a.question_id = new_question.id
        a.value = map_race_or_ethnicity_option old_answer.value
      end

      ExtrapolatedAnswer.create(answer: new_answer)
    end
  end

  def map_employment_option(option)
    # option === "Unemployed" or option === "Retired" ? option : "Employed full-time (30+ hours/week)"
    case option
    when 'Unemployed', 'Retired'
      option
    else
      'Employed full-time (30+ hours/week)'
    end
  end

  def map_employment
    old_question = Question.find_by(text: 'Employment status and profession')
    new_question = Question.find_by(text: 'Are you employed?')
    Answer.where(question_id: old_question.id).each do |old_answer|
      new_answer = Answer.new do |a|
        a.person_id = old_answer.person_id
        a.question_id = new_question.id
        a.value = map_employment_option old_answer.value
      end

      ExtrapolatedAnswer.create(answer: new_answer)
    end
  end

  def map_va_employment_option(option)
    if (option == 'Yes, current VA employee') || (option == 'Yes, past VA employee')
      'Yes, work(ed) for the VA'
    elsif (option == 'Yes, current VSO') || (option == 'Yes, past VSO')
      'Yes, work(ed) for a VSO'
    else
      option
    end
  end

  def map_va_employment
    old_question = Question.find_by(text: 'Are you or have you ever been a VA employee or a Veteran Service Officer (VSO)?')
    new_question = Question.find_by(text: 'Have you ever worked for the VA or a Veteran Service Organization? (Check all that apply)')
    Answer.where(question_id: old_question.id).each do |old_answer|
      new_answer = Answer.new do |a|
        a.person_id = old_answer.person_id
        a.question_id = new_question.id
        a.value = map_va_employment_option old_answer.value
      end

      ExtrapolatedAnswer.create(answer: new_answer)
    end
  end

  # This method will map old answers to new answers. If there is no mapping, it
  # returns nil.
  def map_devices_option(option)
    case option
    when 'Cell phone'
      'Smartphone'
    when 'Tablet'
      'Tablet'
    when 'Personal laptop computer', 'Personal desktop computer'
      'Personal computer'
    when 'Library or public computer'
      'Public or shared computer'
    end
  end

  def map_devices
    old_question = Question.find_by(text: 'What device do you use the most to go online?')
    new_question1 = Question.find_by(text: 'How do you access the Internet? (Check all that apply)')
    new_question2 = Question.find_by(text: 'Any other devices we didn’t list here?')
    Answer.where(question_id: old_question.id).each do |old_answer|
      new_answer = Answer.new do |a|
        device = map_devices_option old_answer.value
        if device
          a.question_id = new_question1.id
          a.value = device
        else
          a.question_id = new_question2.id
          a.value = old_answer.value
        end
      end

      ExtrapolatedAnswer.create(answer: new_answer)
    end
  end

  def map_benefits_and_services # rubocop:disable Metrics/CyclomaticComplexity,Metrics/AbcSize,Metrics/MethodLength,Metrics/PerceivedComplexity
    submissions = Submission.where(form_id: Form.find_by(name: 'Vets.gov Participant Background Info').id)
    submissions.each do |submission| # rubocop:disable Metrics/BlockLength
      old_question1 = Question.find_by(text: 'Which health-related VA benefits or services are you currently exploring, or have you used in the past?')
      old_question2 = Question.find_by(text: 'Which other VA benefits or services are you currently exploring, or have you used in the past?')

      new_question1 = Question.find_by(text: 'Which VA benefits or services do you have any experience with?')
      new_question2 = Question.find_by(text: 'Which VA health benefits have you used or explored? (Check all that apply)')
      new_question3 = Question.find_by(text: 'Which VA education benefits have you used or explored? (Check all that apply)')

      new_options1 = []
      new_options2 = []
      new_options3 = []

      Answer.where(question_id: old_question1.id, submission_id: submission.id).each do |old_answer|
        old_options = old_answer.value.split(', ')

        old_options.each do |o|
          case o
          when 'Primary Care', "Women's Health Care", 'Emergency Care', 'Hospitals', 'Clinics'
            add_to_options(new_options1, 'Health care benefits (clinic, prescription refill, messaging)')
            add_to_options(new_options2, 'VA health coverage')
          when 'Online Rx Refill'
            add_to_options(new_options1, 'Health care benefits (clinic, prescription refill, messaging)')
            add_to_options(new_options2, 'Prescription refill')
          when 'Secure messaging'
            add_to_options(new_options1, 'Health care benefits (clinic, prescription refill, messaging)')
            add_to_options(new_options2, 'Secure messaging')
          when 'Downloading medical records'
            add_to_options(new_options1, 'Health care benefits (clinic, prescription refill, messaging)')
            add_to_options(new_options2, 'Downloading medical records')
          when 'Vision Care', 'Mental Health Care', 'Dental Care'
            add_to_options(new_options1, 'Health care benefits (clinic, prescription refill, messaging)')
            add_to_options(new_options2, 'Assistance with specific health issues, such as mental health or vision care')
          when 'None'
            add_to_options(new_options1, 'None')
          when 'Other'
            add_to_options(new_options1, 'Other')
          end
        end
      end

      Answer.where(question_id: old_question2.id, submission_id: submission.id).each do |old_answer|
        old_options = old_answer.value.split(', ')

        old_options.each do |o|
          case o
          when 'GI Bill', 'Education Benefits'
            add_to_options(new_options1, 'Education & career services (GI Bill, VR&E)')
            add_to_options(new_options3, 'GI Bill (Post-9/11, Montgomery)')
          when 'Vocational Rehabilitation', 'Career Services'
            add_to_options(new_options1, 'Education & career services (GI Bill, VR&E)')
            add_to_options(new_options3, 'Vocational Rehabilitation & Employment (VR&E)')
          when 'Disability Services'
            add_to_options(new_options1, 'Disability benefits (claims & appeals)')
          when 'Homelessness Services', 'Housing Benefits'
            add_to_options(new_options1, 'Housing benefits (adaptive housing, home loans, homelessness services)')
          when 'Pension Services'
            add_to_options(new_options1, 'Pension benefits')
          when 'Insurance'
            add_to_options(new_options1, 'Life insurance')
          when 'National Cemetery Association Services'
            add_to_options(new_options1, 'Burial benefits')
          when 'Other'
            add_to_options(new_options1, 'Other')
          end
        end
      end

      new_answer_1_value = new_options1.join(', ')
      new_answer_2_value = new_options2.join(', ')
      new_answer_3_value = new_options3.join(', ')

      if new_answer_1_value != ''
        new_answer = Answer.new do |a|
          a.person_id = submission.person_id
          a.question_id = new_question1.id
          a.value = new_answer_1_value
        end

        ExtrapolatedAnswer.create(answer: new_answer)
      end

      if new_answer_2_value != ''
        new_answer = Answer.new do |a|
          a.person_id = submission.person_id
          a.question_id = new_question2.id
          a.value = new_answer_2_value
        end

        ExtrapolatedAnswer.create(answer: new_answer)
      end

      if new_answer_3_value != ''
        new_answer = Answer.new do |a|
          a.person_id = submission.person_id
          a.question_id = new_question3.id
          a.value = new_answer_3_value
        end

        ExtrapolatedAnswer.create(answer: new_answer)
      end
    end # rubocop:enable Metrics/BlockLength
  end # rubocop:enable Metrics/CyclomaticComplexity,Metrics/AbcSize,Metrics/MethodLength,Metrics/PerceivedComplexity

  def perform(*_args)
    # delete old answers
    ExtrapolatedAnswer.all.each(&:destroy)

    map_answer_directly('Gender', 'I identify my gender as:')

    map_answer_directly('Which branch of the military are/were you in?', 'Which branch of the military are/were you in? (Check all that apply)')

    map_answer_directly('Around which year did you join the service?', 'What year did you join the service?')

    map_answer_directly('Around which year did you get out of the service?', 'What year did you get out of the service?')

    map_answer_directly('How often do you go online to access these VA benefits and services?', 'How often do you go online to access VA benefits and services?')

    map_devices

    map_race_or_ethnicity

    map_answer_directly('Education', 'What is your highest level of education?')

    map_answer_directly('Age', 'Which age range do you fit in?')

    map_employment

    map_va_employment

    map_benefits_and_services

    map_answer_directly('Any other VA benefits? Please describe:', 'Have you used or explored any other VA benefits? Please describe')

    map_answer_directly('Are you still active duty?', 'Are you still active duty?')

    map_answer_directly("Are you a Veteran, Veteran's family member, or Veteran's caretaker?", 'Are you a Veteran, Veteran’s family member, or Veteran’s caretaker, or Servicemember? (Check all that apply)')

    Person.reindex
  end
end # rubocop:enable Metrics/ClassLength
