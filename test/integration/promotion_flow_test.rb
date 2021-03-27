require 'test_helper'

class PromotionFlowTest < ActionDispatch::IntegrationTest
  def setup
    @promotion_params =
    { promotion: { name: 'Natal', description: 'Promoção de natal',
                   code: 'NATAL10', discount_rate: 15, coupon_quantity: 5,
                   expiration_date: '22/12/2033' } }
  end
  
  test 'can create a promotion' do
    login_as_user
    post '/promotions', params: setup

    assert_redirected_to promotion_path(Promotion.last)
    assert_response :found
    follow_redirect!
    assert_response :success
    assert_select 'h3', 'Natal'
  end

  test 'cannot create a promotion without login' do
    post '/promotions', params: setup

    assert_redirected_to new_user_session_path
  end

  test 'cannot generate coupons without login' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de natal',
                                  code: 'NATAL10', discount_rate: 15,
                                  coupon_quantity: 5, expiration_date: '22/12/2033')

    post generate_coupons_promotion_path(promotion)

    assert_redirected_to new_user_session_path
  end

  test 'can generate coupons with login' do
    login_as_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de natal',
                                  code: 'NATAL10', discount_rate: 15,
                                  coupon_quantity: 5, expiration_date: '22/12/2033')

    post generate_coupons_promotion_path(promotion)

    assert_response 302
    follow_redirect!
    assert_response :success
    assert_select 'p', 'Cupons gerados com sucesso'
  end

  test 'cannot update promotion without login' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de natal',
                                  code: 'NATAL10', discount_rate: 15,
                                  coupon_quantity: 5, expiration_date: '22/12/2033')

    patch promotion_path(promotion)

    assert_redirected_to new_user_session_path
  end

  test 'cannot delete promotion without login' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de natal',
                                  code: 'NATAL10', discount_rate: 15,
                                  coupon_quantity: 5, expiration_date: '22/12/2033')

    delete promotion_path(promotion)
    
    assert_redirected_to new_user_session_path
  end
  
end