class Request < ActiveRecord::Base
  belongs_to :user
  validates :sha, uniqueness: true
end
