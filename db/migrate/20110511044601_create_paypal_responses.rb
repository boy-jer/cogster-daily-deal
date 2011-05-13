class CreatePaypalResponses < ActiveRecord::Migration
  def self.up
    create_table :paypal_responses do |t|
      t.integer :purchase_id
      t.integer :user_id
      t.integer :project_id
      t.string :action
      t.integer :amount
      t.boolean :success
      t.string :authorization
      t.string :message
      t.text :params

      t.timestamps
    end
  end

  def self.down
    drop_table :paypal_responses
  end
end
