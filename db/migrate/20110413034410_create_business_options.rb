class CreateBusinessOptions < ActiveRecord::Migration
  def self.up
    create_table :business_options do |t|
      t.string :category
    end
  end

  def self.down
    drop_table :business_options
  end
end
