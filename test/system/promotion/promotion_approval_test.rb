require 'application_system_test_case'

class PromotionsApprovalTest < ApplicationSystemTestCase
  test 'user approves promotion' do
    user = User.create!(email: 'jose@iugu.com.br', password: '123456')
    xmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                             code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                             expiration_date: '22/12/2033', user: user)

    approver = login_as_user
    visit promotion_path(xmas)
    assert_emails 1 do
      accept_confirm { click_on 'Aprovar' }
      assert_text 'Promoção aprovada com sucesso'
    end

    assert_text "Aprovada por: #{approver.email}"
    assert_button 'Gerar cupons'
  end

  test 'user can not approves his promotions' do
    user = login_as_user
    xmas = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(xmas)

    refute_link 'Aprovar'
    refute_link 'Gerar cupons'
  end

  test 'check if user is owner' do
    user = login_as_user
    xmas = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(xmas)
    assert_equal true, xmas.owner?(user)
  end
end
