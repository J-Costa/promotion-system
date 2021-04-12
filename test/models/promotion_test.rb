require 'test_helper'

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
    user = User.create!(email: 'joao@iugu.com.br', password: '124566')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    promotion = Promotion.new(code: 'NATAL10', name: 'Natal')

    refute promotion.valid?
    assert_includes promotion.errors[:code], 'já está em uso'
    assert_includes promotion.errors[:name], 'já está em uso'
  end

  test 'edit promotion attributes cannot be blank' do
    user = User.create!(email: 'joao@iugu.com.br', password: '124566')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    promotion.update(name: '', code: '', discount_rate: '', coupon_quantity: '', expiration_date: '')

    refute promotion.valid?
    assert_includes promotion.errors[:name], 'não pode ficar em branco'
    assert_includes promotion.errors[:code], 'não pode ficar em branco'
    assert_includes promotion.errors[:discount_rate], 'não pode ficar em branco'
    assert_includes promotion.errors[:coupon_quantity], 'não pode ficar em branco'
    assert_includes promotion.errors[:expiration_date], 'não pode ficar em branco'
  end

  test 'edit promotion code and name must be unique' do
    user = User.create!(email: 'joao@iugu.com.br', password: '124566')
    promotion_1 = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: user)
    promotion_2 = Promotion.create!(name: 'Páscoa', description: 'Promoção de páscoa',
                                    code: 'PASCOA10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: user)
    promotion_2.update(name: 'Natal', code: 'NATAL10')

    refute promotion_2.valid?
    assert_includes promotion_2.errors[:name], 'já está em uso'
    assert_includes promotion_2.errors[:code], 'já está em uso'
  end

  test 'generate_coupons! successfully' do
    user = User.create!(email: 'joao@iugu.com.br', password: '124566')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    promotion.generate_coupons!

    assert_equal promotion.coupons.size, promotion.coupon_quantity
    assert_equal promotion.coupons.first.code, 'NATAL10-0001'
  end

  test 'generate_coupons! cannot be called twice' do
    user = User.create!(email: 'joao@iugu.com.br', password: '124566')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    Coupon.create!(code: 'TESTE', promotion: promotion)
    assert_no_difference 'Coupon.count' do
      promotion.generate_coupons!
    end
  end

  test 'expiration date cannot be in the past' do
    # usando fixture
    # promotion = promotions(:one)
    user = User.create!(email: 'joao@iugu.com.br', password: '124566')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    promotion.update(expiration_date: Date.current - 1.day)

    assert_includes promotion.errors[:expiration_date], 'não pode ser no passado'
  end

  test '.search exact' do
    user = User.create!(email: 'joao@iugu.com.br', password: '124566')
    xmas = Promotion.create!(name: 'Natal',
                             description: 'Promoção de Natal',
                             code: 'NATAL10', discount_rate: 10,
                             coupon_quantity: 100,
                             expiration_date: '22/12/2033', user: user)
    carnival = Promotion.create!(name: 'Carnaval', coupon_quantity: 90,
                                 description: 'Promoção de carnavrau',
                                 code: 'CARNA13', discount_rate: 15,
                                 expiration_date: '22/12/2033', user: user)

    result = Promotion.search('Natal')
    assert_includes result, xmas
    refute_includes result, carnival
  end

  test '.search partial' do
    user = User.create!(email: 'joao@iugu.com.br', password: '124566')
    xmas = Promotion.create!(name: 'Natal',
                             description: 'Promoção de Natal',
                             code: 'NATAL10', discount_rate: 10,
                             coupon_quantity: 100,
                             expiration_date: '22/12/2033',
                             user: user)
    carnival = Promotion.create!(name: 'Carnaval', coupon_quantity: 90,
                                 description: 'Promoção de carnavrau',
                                 code: 'CARNA13', discount_rate: 15,
                                 expiration_date: '22/12/2033',
                                 user: user)
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                     description: 'Promoção de Cyber Monday',
                                     code: 'CYBER15', discount_rate: 15,
                                     expiration_date: '22/12/2033',
                                     user: user)
    result = Promotion.search('na')

    assert_includes result, xmas
    assert_includes result, carnival
    refute_includes result, cyber_monday
  end

  test '.search finds nothing' do
    user = User.create!(email: 'joao@iugu.com.br', password: '124566')
    xmas = Promotion.create!(name: 'Natal',
                             description: 'Promoção de Natal',
                             code: 'NATAL10', discount_rate: 10,
                             coupon_quantity: 100,
                             expiration_date: '22/12/2033', user: user)
    carnival = Promotion.create!(name: 'Carnaval', coupon_quantity: 90,
                                 description: 'Promoção de carnavrau',
                                 code: 'CARNA13', discount_rate: 15,
                                 expiration_date: '22/12/2033', user: user)
    result = Promotion.search('Cyber')
    assert_empty result
  end
end
