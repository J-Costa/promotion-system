class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'show promotions' do
    user = User.create!(email: 'joao@iugu.com.br', password: '123456')
    Promotion.create!(name: 'Natal',
                      description: 'Promoção de natal',
                      code: 'NATAL10', discount_rate: 15,
                      coupon_quantity: 5, expiration_date: '22/12/2033',
                      user: user)
    Promotion.create!(name: 'Carnaval',
                      description: 'Carnaval',
                      code: 'CARNA10', discount_rate: 10,
                      coupon_quantity: 5, expiration_date: '22/12/2033',
                      user: user)

    get '/api/v1/promotions'

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal 'Natal', body[0][:name]
    assert_equal 'Promoção de natal', body[0][:description]
    assert_equal 'NATAL10', body[0][:code]
    assert_equal '15.0', body[0][:discount_rate]
    assert_equal 5, body[0][:coupon_quantity]
    assert_equal '2033-12-22', body[0][:expiration_date]
    assert_equal 'Carnaval', body[1][:name]
    assert_equal 'Carnaval', body[1][:description]
    assert_equal 'CARNA10', body[1][:code]
    assert_equal '10.0', body[1][:discount_rate]
    assert_equal 5, body[1][:coupon_quantity]
    assert_equal '2033-12-22', body[1][:expiration_date]
  end

  test 'show promotion' do
    user = User.create!(email: 'joao@iugu.com.br', password: '123456')
    Promotion.create!(name: 'Natal',
                      description: 'Promoção de natal',
                      code: 'NATAL10', discount_rate: 15,
                      coupon_quantity: 5, expiration_date: '22/12/2033',
                      user: user)
    get '/api/v1/promotions/NATAL10'

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal 'Natal', body[:name]
    assert_equal 'Promoção de natal', body[:description]
    assert_equal 'NATAL10', body[:code]
    assert_equal '15.0', body[:discount_rate]
    assert_equal 5, body[:coupon_quantity]
    assert_equal '2033-12-22', body[:expiration_date]
  end
end
