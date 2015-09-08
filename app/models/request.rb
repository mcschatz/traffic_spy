class Request < ActiveRecord::Base
  belongs_to :user
  belongs_to :url
  belongs_to :browser
  belongs_to :operating_system
  belongs_to :resolution
  belongs_to :type
  belongs_to :referral
  belongs_to :event
  validates  :sha, uniqueness: true
  validates  :user_id, presence: true
end