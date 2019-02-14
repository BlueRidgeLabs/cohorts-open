class AddCounterCacheToTraits < ActiveRecord::Migration
  def change
    add_column :traits, :person_traits_count, :integer, default: 0

    unless reverting?
      Trait.reset_column_information
      Trait.find_each do |trait| 
        Trait.reset_counters(trait.id, :person_traits)
      end
    end
  end
end
