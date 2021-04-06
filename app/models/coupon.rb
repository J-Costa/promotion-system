class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status: {active: 0, disabled: 10}
  delegate :discount_rate, to: :promotion

  def as_json(options = {})
    super({ methods: :discount_rate }.merge(options))
  end
  def self.search(term) 
    return '' if find_by(code: term).nil?
    
    find_by(code: term)
  end
end
