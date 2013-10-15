class CreateHejiaTags < ActiveRecord::Migration
  def self.up
    create_table :hejia_tags do |t|
    end
  end

  def self.down
    drop_table :hejia_tags
  end
end
