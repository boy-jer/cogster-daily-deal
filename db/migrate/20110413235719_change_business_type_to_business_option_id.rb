class ChangeBusinessTypeToBusinessOptionId < ActiveRecord::Migration
  def self.up
    change_column :businesses, :business_type, :integer
    rename_column :businesses, :business_type, :business_option_id
  end

  def self.down
    rename_column :businesses, :business_option_id, :business_type
    change_column :businesses, :business_type, :string
  end
end
