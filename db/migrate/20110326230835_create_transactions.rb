class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.references :user
      t.integer :investment_id
      t.date :date
      t.decimal :amount
      t.string :note

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
