class CreateIpAddresses < ActiveRecord::Migration
  def self.up
    create_table :ip_addresses do |t|
    end
  end

  def self.down
    drop_table :ip_addresses
  end
end
