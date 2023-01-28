class Node < ActiveRecord::Base
  has_many :statistics

  validates :ip_address, presence: true, uniqueness: true
end
