class CreateExtrapolatedAnswers < ActiveRecord::Migration
  def change
    create_table :extrapolated_answers do |t|
      t.belongs_to :answer, index: true, foreign_key: true
    end
  end
end
