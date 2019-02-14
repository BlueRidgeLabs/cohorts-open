# frozen_string_literal: true
class ExtrapolateCommentsJob < ActiveJob::Base
  queue_as :default

  def map_question_to_note(question)
    old_question = Question.find_by(text: question)
    Answer.where(question_id: old_question.id).each do |old_answer|
      person = Person.find(old_answer.person_id)

      new_comment = Comment.new
      new_comment.content = "On #{old_answer.created_at}, #{person.first_name} #{person.last_name} submitted the form titled \"#{Form.find(old_question.form_id).name}\" and responded to \"#{question}\" with: \"#{old_answer.value}\"."
      new_comment.commentable = person

      ExtrapolatedComment.create(comment: new_comment)
    end
  end

  def perform(*_args)
    # delete old comments
    ExtrapolatedComment.all.each(&:destroy)

    map_question_to_note("Anything else you'd like to share about your time serving?")

    map_question_to_note('Were you active duty during any war era?')

    Person.reindex
  end
end
