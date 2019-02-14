class CreateExtrapolatedComments < ActiveRecord::Migration
  def change
    create_table :extrapolated_comments do |t|
      t.belongs_to :comment, index: true, foreign_key: true
    end
  end
end
