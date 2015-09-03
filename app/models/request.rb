class Request < ActiveRecord::Base
  belongs_to :user
  belongs_to :url
  validates :sha, uniqueness: true
end