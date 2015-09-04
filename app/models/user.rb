class User < ActiveRecord::Base
  validates :identifier, presence: true, uniqueness: true
  validates :root_url, presence: true
  has_many :requests
  has_many :urls, :through => :requests
  has_many :browsers, :through => :requests
  has_many :operating_systems, :through => :requests
end
