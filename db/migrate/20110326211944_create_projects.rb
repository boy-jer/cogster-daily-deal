class CreateProjects < ActiveRecord::Migration
  def self.up
    rename_table :campaigns, :projects
    create_table :campaigns do |t|
      t.string :description
      t.integer :return_length
      t.boolean :active
    end
  end

  def self.down
    drop_table :campaigns
    rename_table :projects, :campaigns
  end
end
