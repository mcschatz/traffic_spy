class Url < ActiveRecord::Base
  has_many :requests
  has_many :operating_systems, :through => :requests
  has_many :browsers, :through => :requests
  has_many :types, :through => :requests
  has_many :referrals, :through => :requests
  has_many :resolutions, :through => :requests

  def self.stats(url)
    url_info                                    = {}
    url_info[:referral_info]    = DataManipulator.column_summary(url.referrals, :address)
    url_info[:browser_info]     = DataManipulator.column_summary(url.browsers, :name)
    url_info[:os_info]          = DataManipulator.column_summary(url.operating_systems, :name)
    url_info[:resolution_info]  = DataManipulator.column_summary(url.resolutions, :description)
    url_info
  end
end
