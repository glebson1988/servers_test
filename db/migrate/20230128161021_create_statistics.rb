class CreateStatistics < ActiveRecord::Migration[7.0]
  def change
    create_table :statistics do |t|
      t.float :average_rtt
      t.float :minimum_rtt
      t.float :maximum_rtt
      t.float :median_rtt
      t.float :standard_deviation
      t.float :percentage_lost
      t.datetime :start_time
      t.datetime :end_time
      t.belongs_to :nodes, foreign_key: true, index: true
      t.timestamps
    end
  end
end
