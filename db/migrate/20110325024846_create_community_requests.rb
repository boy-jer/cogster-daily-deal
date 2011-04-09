class CreateCommunityRequests < ActiveRecord::Migration
  def self.up
    create_table :community_requests do |t|
      t.string :email
      t.string :zip_code
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :community_requests
  end
end
