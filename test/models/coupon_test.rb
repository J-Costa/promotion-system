require "test_helper"

class CouponTest < ActiveSupport::TestCase
  test 'search for a exact coupon' do
    user = User.create!(email: 'joao@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de natal',
                                  code: 'NATAL10', discount_rate: 15,
                                  coupon_quantity: 5, expiration_date: '22/12/2033', 
                                  user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)
    
    result = Coupon.search('NATAL10-0001')
    
    assert_equal result, coupon
  end

  test 'search for a exact coupon and dont find' do
    user = User.create!(email: 'joao@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de natal',
                                  code: 'NATAL10', discount_rate: 15,
                                  coupon_quantity: 5, expiration_date: '22/12/2033', 
                                  user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)
    
    result = Coupon.search('NATAL10-0000')
    
    assert_equal result, ''
  end
end
