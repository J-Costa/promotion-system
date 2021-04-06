require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'show coupon' do
    user = User.create!(email: 'joao@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de natal',
                                  code: 'NATAL10', discount_rate: 15,
                                  coupon_quantity: 5, expiration_date: '22/12/2033', 
                                  user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    get "/api/v1/coupons/#{coupon.code}"

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal promotion.discount_rate.to_s, body[:discount_rate]
  end

  # TODO: crud em json, desafios, tempo do vídeo sessão 12 02:09:29
end