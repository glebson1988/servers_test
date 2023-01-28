class CreateNodes < ActiveRecord::Migration[7.0]
  def change
    create_table :nodes do |t|
      t.string :ip_address, null: false
      t.timestamps
    end

    add_index :nodes, :ip_address, unique: true
  end
end
