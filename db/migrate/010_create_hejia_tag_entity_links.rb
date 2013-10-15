class CreateHejiaTagEntityLinks < ActiveRecord::Migration
  def self.up
    create_table :hejia_tag_entity_links do |t|
    end
  end

  def self.down
    drop_table :hejia_tag_entity_links
  end
end
