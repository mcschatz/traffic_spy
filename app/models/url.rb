class Url < ActiveRecord::Base
  has_many :requests
  has_many :operating_systems, :through => :requests
  has_many :browsers, :through => :requests
  has_many :types, :through => :requests
  has_many :referrals, :through => :requests
  has_many :resolutions, :through => :requests

  def stats
    url_info                                    = {}
    url_info[:referral_info]    = DataManipulator.column_summary(referrals, :address)
    url_info[:browser_info]     = DataManipulator.column_summary(browsers, :name)
    url_info[:os_info]          = DataManipulator.column_summary(operating_systems, :name)
    url_info[:resolution_info]  = DataManipulator.column_summary(resolutions, :description)
    url_info
  end
end
