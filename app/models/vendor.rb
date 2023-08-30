class Vendor < ApplicationRecord
  has_many :market_vendors, :dependent => :destroy
  has_many :markets, through: :market_vendors

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :contact_name
  validates_presence_of :contact_phone

  validates :credit_accepted, inclusion: [true, false]
  validates :credit_accepted, exclusion: [nil]
end