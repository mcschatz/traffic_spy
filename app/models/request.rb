class Request < ActiveRecord::Base
  belongs_to :user
  validates :sha, uniqueness: true
  belongs_to :machine
  belongs_to :site
end
