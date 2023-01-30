class Node < ActiveRecord::Base
  has_many :statistics, dependent: :destroy

  validates :ip_address, presence: true,
            uniqueness: true,
            format: { with: /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\z/, message: 'is invalid. Valid format: 8.8.8.8' }
end
