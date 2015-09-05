class Url < ActiveRecord::Base
  has_many :requests
  has_many :operating_systems, :through => :requests
  has_many :browsers, :through => :requests
  has_many :types, :through => :requests
end
