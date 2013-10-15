# == Schema Information
# Schema version: 11
#
# Table name: HEJIA_TAG
#
#  TAGID       :integer(19)     not null, primary key
#  TAGFATHERID :integer(19)     not null
#  TAGNAME     :string(510)     default(""), not null
#  TAGVALUE    :string(4000)
#  TAGICON     :string(510)
#  TAGURL      :string(510)
#  TAGTAXIS    :integer(19)
#  TAGESTATE   :string(510)     default(""), not null
#  TAGDATE     :datetime
#  TAGCODE     :string(510)
#  TAGTYPE     :string(510)
#  BIDDING     :integer(11)
#  SPELL       :string(255)
#  TEMPURL     :string(255)
#  VERSION     :string(255)
#

# -*- coding: utf-8 -*-
class ArticleTag < ActiveRecord::Base

  acts_as_readonlyable [:read_only_51hejia] unless RAILS_ENV == "test"

  self.table_name = "HEJIA_TAG"
  self.primary_key = "TAGID"

  has_and_belongs_to_many :sonlist,
  :class_name => "ArticleTag",
  :join_table => "HEJIA_TAGLINK",
  :foreign_key => "TAGID1",
  :association_foreign_key => "TAGID2",
  :conditions => "TAGESTATE = 0"

  #文章大分类 -- first :controller => article , :action => new
  def self.article_categories
    find(:all ,:conditions =>["TAGFATHERID = ? and TAGESTATE = '0'",14025])
  end

  def self.aft
    find(:all,:conditions=>["TAGID in (31871,35762,35763,35764,35765,35766,35767,35768,35769,35770,35771,35772)"])
  end

  def self.at
    find(:all, :conditions=>["TAGFATHERID in (31871,35762,35763,35764,35765,35766,35767,35768,35769,35770,35771,35772)"])
  end

end
