class CreateCogsterCashes < ActiveRecord::Migration
  def self.up
    create_table :cogster_cashes do |t|
      t.date :start_date
      t.date :expiration_date
      t.integer :project_id
      t.integer :user_id
      t.decimal :initial_amount
      t.decimal :remainder

      t.timestamps
    end
  end

  def self.down
    drop_table :cogster_cashes
  end
end
