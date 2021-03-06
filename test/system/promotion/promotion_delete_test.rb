require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'delete promotion' do
    user = login_as_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    visit promotion_path(promotion)

    assert_difference 'Promotion.count', -1 do
      accept_confirm { click_on 'Deletar promoção' }
      assert_text 'Deletado com sucesso'
    end
    assert_text 'Nenhuma promoção cadastrada'
    assert_no_text 'Natal'
    assert_no_text 'Promoção de Natal'
  end

  test 'delete promotion with generated coupons' do
    user = User.create!(email: 'joao@iugu.com.br', password: '654321')
    login_as_user(User.create!(email: 'jose@iugu.com.br', password: '123456'))
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    visit promotion_path(promotion)
    accept_confirm { click_on 'Aprovar' }
    click_on 'Gerar cupons'

    assert_text 'Cupons gerados com sucesso'
    assert_no_link 'Gerar cupons'
    assert_no_text 'NATAL10-0000'
    assert_text 'NATAL10-0001'
    assert_text 'NATAL10-0002'
    assert_text 'NATAL10-0100'
    assert_no_text 'NATAL10-0101'
    assert_difference 'Promotion.count', -1 do
      accept_confirm { click_on 'Deletar promoção' }
      assert_text 'Deletado com sucesso'
    end
    assert_text 'Nenhuma promoção cadastrada'
    assert_no_text 'Natal'
    assert_no_text 'Promoção de Natal'
  end
end
