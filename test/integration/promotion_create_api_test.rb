require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'create promotion' do
    user = User.create!(email: 'joao@iugu.com.br', password: '123456')
    post '/api/v1/promotions', params: {
      promotion: { name: 'Natal',
                   description: 'Promoção de natal',
                   code: 'NATAL10', discount_rate: 15,
                   coupon_quantity: 5, expiration_date: '22/12/2033',
                   user_id: user.id }
    }

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal 'Natal', body[:name]
    assert_equal 'Promoção de natal', body[:description]
    assert_equal 'NATAL10', body[:code]
    assert_equal '15.0', body[:discount_rate]
    assert_equal 5, body[:coupon_quantity]
    assert_equal '2033-12-22', body[:expiration_date]
  end

  test 'create with blank attributes' do
    post '/api/v1/promotions', params: {
      promotion: { name: '',
                   description: '',
                   code: '', discount_rate: '',
                   coupon_quantity: 5, expiration_date: '',
                   user_id: '' }
    }

    body = JSON.parse(response.body, symbolize_names: true)

    assert_response :success
    assert_includes 'é obrigatório(a)', body[:user][0]
    assert_includes 'não pode ficar em branco', body[:code][0]
    assert_includes 'não pode ficar em branco', body[:name][0]
    assert_includes 'não pode ficar em branco', body[:discount_rate][0]
    assert_includes 'não pode ficar em branco', body[:expiration_date][0]
  end
end
