require 'application_system_test_case'

class CouponsTest < ApplicationSystemTestCase
	test 'disable a coupon' do
		promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
																	code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
																	expiration_date: '22/12/2033')
		coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)
		
		login_as_user
		visit promotion_path(promotion)
		click_on 'Desabilitar'

		assert_text "Cupom #{coupon.code} desabilitado com sucesso"
		assert_text "#{coupon.code} (desabilitado)"
		assert_no_link 'Desabilitar'
	end

	test 'enable a coupon' do
		promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
									code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
									expiration_date: '22/12/2033')
		coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion, status: 'disabled')
		
		login_as_user
		visit promotion_path(promotion)
		click_on 'Habilitar'
		
		assert_text "Cupom #{coupon.code} ativado com sucesso"
		assert_text 'NATAL10-0001 (ativo)'
		assert_no_link 'Habilitar'
  end

  # TODO: buscar cupom teste sistema
  test 'search for a coupon' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
                                  expiration_date: '22/12/2033')
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    login_as_user
    visit promotions_path
    within 'form' do
      select 'Cupons', from: 'filter'
      fill_in "Busca",	with: "NATAL10-0001" 
      click_on 'Buscar'
    end

    assert_text 'NATAL10-0001'
    assert_link 'Natal'
  end

  test 'search for a coupon that does not exist' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
                                  expiration_date: '22/12/2033')
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    login_as_user
    visit promotions_path
    within 'form' do
      select 'Cupons', from: 'filter'
      fill_in "Busca",	with: "NATAL10-9999" 
      click_on 'Buscar'
    end

    assert_text 'Cupom: NATAL10-9999 não encontrado'
    
  end

end