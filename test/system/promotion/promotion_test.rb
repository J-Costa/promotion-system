require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  
  test 'generate coupons for a promotion' do 
    # arrange | prepara tudo para testar
    # precisa de promocao 
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    # act | ações do teste e chegar no path
      login_as_user
      visit promotion_path(promotion)
      click_on "Gerar cupons"

    # assert | verifica se deu tudo certo
      assert_text 'Cupons gerados com sucesso'
      assert_no_link 'Gerar cupons'
      assert_no_text 'NATAL10-0000'
      assert_text 'NATAL10-0001 (ativo)'
      assert_text 'NATAL10-0002 (ativo)'
      assert_text 'NATAL10-0100 (ativo)'
      assert_no_text 'NATAL10-0101'
      assert_link 'Desabilitar', count: 100  
  end

  test 'search promotions by term and finds results' do
    christmas = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    christmassy = Promotion.create!(name: 'Natalina',
                                    description: 'Promoção de Natal',
                                    code: 'NATAL11', discount_rate: 10,
                                    coupon_quantity: 100,
                                    expiration_date: '22/12/2033')
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                    description: 'Promoção de Cyber Monday',
                                    code: 'CYBER15', discount_rate: 15,
                                    expiration_date: '22/12/2033')
    login_as_user
    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'natal'
    click_on 'Buscar'

    assert_text '2 promoções encontradas para o termo: natal'
    assert_text christmas.name
    assert_text christmassy.name
    refute_text cyber_monday.name
  end

  test 'search promotions and didnt find anything' do
    christmas = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    christmassy = Promotion.create!(name: 'Natalina',
                                    description: 'Promoção de Natal',
                                    code: 'NATAL11', discount_rate: 10,
                                    coupon_quantity: 100,
                                    expiration_date: '22/12/2033')
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                    description: 'Promoção de Cyber Monday',
                                    code: 'CYBER15', discount_rate: 15,
                                    expiration_date: '22/12/2033')
    login_as_user
    visit root_path
    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'zumba'
    click_on 'Buscar'

    assert_text 'Nenhuma promoção encontrada para o termo: zumba'
  end

  test 'search without login' do
    visit search_promotions_path(search: 'natal')

    assert_current_path new_user_session_path
  end
end