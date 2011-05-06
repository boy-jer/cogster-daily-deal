class CreateHours < ActiveRecord::Migration
  def self.up
    create_table :hours do |t|
      t.integer :business_id
      t.integer :hour
      t.integer :minute
      t.string :meridian

      t.timestamps
    end
  end

  def self.down
    drop_table :hours
  end
end
