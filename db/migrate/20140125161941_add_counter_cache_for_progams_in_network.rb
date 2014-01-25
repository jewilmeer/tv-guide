class AddCounterCacheForProgamsInNetwork < ActiveRecord::Migration
  def change
    add_column :networks, :programs_count, :integer, default: 0, null: false

    Network.reset_column_information
    Network.find_each do |network|
      Network.update_counters network.id, programs_count: network.programs.count
    end
  end
end
