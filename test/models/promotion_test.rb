require "test_helper"

class PromotionTest < ActiveSupport::TestCase
  test 'attributes cannot be blank' do
    promotion = Promotion.new

    refute promotion.valid?
    assert_includes promotion.errors[:name], 'não pode ficar em branco'
    assert_includes promotion.errors[:code], 'não pode ficar em branco'
    assert_includes promotion.errors[:discount_rate], 'não pode ficar em '\
                                                      'branco'
    assert_includes promotion.errors[:coupon_quantity], 'não pode ficar em'\
                                                        ' branco'
    assert_includes promotion.errors[:expiration_date], 'não pode ficar em'\
                                                        ' branco'
  end

  test 'code must be uniq' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    promotion = Promotion.new(code: 'NATAL10', name: 'Natal')

    refute promotion.valid?
    assert_includes promotion.errors[:code], 'deve ser único'
    assert_includes promotion.errors[:name], 'deve ser único'
  end

  test 'edit promotion attributes cannot be blank' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    promotion.update(name: "", code: "", discount_rate: "", coupon_quantity: "", expiration_date: "" )
    
    refute promotion.valid?
    assert_includes promotion.errors[:name], 'não pode ficar em branco'
    assert_includes promotion.errors[:code], 'não pode ficar em branco'
    assert_includes promotion.errors[:discount_rate], 'não pode ficar em branco'
    assert_includes promotion.errors[:coupon_quantity], 'não pode ficar em branco'
    assert_includes promotion.errors[:expiration_date], 'não pode ficar em branco'
  end

  test 'edit promotion code and name must be unique' do 
    promotion_1 = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
      expiration_date: '22/12/2033')
    promotion_2 = Promotion.create!(name: 'Páscoa', description: 'Promoção de páscoa',
        code: 'PASCOA10', discount_rate: 10, coupon_quantity: 100,
        expiration_date: '22/12/2033')
    promotion_2.update(name: 'Natal', code:'NATAL10')

      refute promotion_2.valid?
      assert_includes promotion_2.errors[:name], 'deve ser único'
      assert_includes promotion_2.errors[:code], 'deve ser único'
  end

end
