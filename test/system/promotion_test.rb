# promotion-system/test/system/promotions_test.rb

require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'create promotion' do
    login_as_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar um(a) Promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Criar Promoção'

    assert_current_path promotion_path(Promotion.last)
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    
    login_as_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar um(a) Promoção'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Criar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'create and code must be unique' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    login_as_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar um(a) Promoção'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Criar Promoção'

    assert_text 'já está em uso'
  end

  test 'view promotions' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')
    login_as_user
    visit root_path
    click_on 'Promoções'

    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'view promotion details' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')
    login_as_user
    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'no promotion are available' do
    login_as_user
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    login_as_user
    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    login_as_user
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    assert_current_path promotions_path
  end

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

  test 'delete promotion' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    login_as_user
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
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    login_as_user
    visit promotion_path(promotion)
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

  test 'do not view promotion link without login' do
    visit root_path

    assert_no_link 'Promoções'
  end

  test 'verify access to show is disabled' do
    visit promotions_path

    assert_current_path new_user_session_path
  end
  
  test 'update promotions' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    login_as_user
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Editar'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Atualizar Promoção'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_link 'Voltar'
  end
  
  test 'update and attributes cannot be blank' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    login_as_user
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Editar'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Atualizar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'update and code/name must be unique' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')

    login_as_user
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Editar'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    click_on 'Atualizar Promoção'

    assert_text 'já está em uso', count: 2
  end

  test 'can not edit promotion without login' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    visit edit_promotion_path(promotion)

    assert_current_path new_user_session_path
  end

end