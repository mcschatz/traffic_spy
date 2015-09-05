class Request < ActiveRecord::Base
  belongs_to :user
  belongs_to :url
  belongs_to :browser
  belongs_to :operating_system
  belongs_to :resolution
  belongs_to :type
  validates :sha, uniqueness: true
end
