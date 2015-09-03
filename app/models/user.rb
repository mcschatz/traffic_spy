class User < ActiveRecord::Base
  validates :identifier, presence: true, uniqueness: true
  validates :root_url, presence: true
  has_many :requests
  has_many :urls, :through => :requests

  def ordered_urls
    user.urls
  end
end
