class Referral < ActiveRecord::Base
  has_many :requests
end