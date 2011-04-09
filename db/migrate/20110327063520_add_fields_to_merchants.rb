class AddFieldsToMerchants < ActiveRecord::Migration
  def self.up
    add_column :merchants, :region_id, :integer
    add_column :merchants, :user_id, :integer
    add_column :merchants, :business_hours, :string
    add_column :merchants, :business_type, :string
    add_column :merchants, :story, :string
    add_column :merchants, :active, :boolean
    add_column :merchants, :featured, :boolean
  end

  def self.down
    remove_column :merchants, :region_id
    remove_column :merchants, :user_id
    remove_column :merchants, :business_hours
    remove_column :merchants, :business_type
    remove_column :merchants, :story
    remove_column :merchants, :active
    remove_column :merchants, :featured
  end
end
