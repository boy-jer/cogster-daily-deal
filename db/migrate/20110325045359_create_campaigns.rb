class CreateCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns do |t|
      t.integer :business_id
      t.string :name
      t.decimal :min_amount 
      t.decimal :max_amount 
      t.decimal :milestone
      t.date :success_date
      t.date :expiration_date
      t.string :reason
      t.string :incentives
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :campaigns
  end
end
