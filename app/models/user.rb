class User < ActiveRecord::Base
  validates :identifier, presence: true
  validates :root_url, presence: true
end