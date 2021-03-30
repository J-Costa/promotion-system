require "test_helper"

class CouponTest < ActiveSupport::TestCase
  # TODO: teste unitário coupon
  test 'search for a exact coupon' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 10,
                                  expiration_date: '22/12/2033')
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)
    
    result = Coupon.search('NATAL10-0001')
    
    assert_equal result, coupon
  end

  test 'search for a exact coupon and dont find' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 10,
                                  expiration_date: '22/12/2033')
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)
    
    result = Coupon.search('NATAL10-0000')
    
    assert_equal result, ''
  end
end
