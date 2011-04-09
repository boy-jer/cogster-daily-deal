class CreateInvestments < ActiveRecord::Migration
  def self.up
    create_table :investments do |t|
      t.integer :user_id
      t.integer :project_id
      t.decimal :amount
      t.date :expiration_date

      t.timestamps
    end
  end

  def self.down
    drop_table :investments
  end
end
