class CreateDeals < ActiveRecord::Migration
  def self.up
    create_table :deals do |t|
      t.integer :business_id
      t.string :title
      t.string :description
      t.date :start_date
      t.date :end_date
      t.boolean :active
      t.integer :rank_id
      t.timestamps
    end
  end

  def self.down
    drop_table :deals
  end
end
