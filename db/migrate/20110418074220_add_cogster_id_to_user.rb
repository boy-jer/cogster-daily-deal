class AddCogsterIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :cogster_id, :string
  end

  def self.down
    remove_column :users, :cogster_id
  end
end
