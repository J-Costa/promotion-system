class Coupon < ApplicationRecord
  belongs_to :promotion
  enum status: {active: 0, disabled: 10}

  def self.search(term) 
    return '' if find_by(code: term).nil?
    
    find_by(code: term)
  end
end
