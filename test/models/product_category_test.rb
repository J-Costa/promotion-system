require "test_helper"

class ProductCategoryTest < ActiveSupport::TestCase
  test 'attributes cannot be blank' do
    product_category = ProductCategory.new

    refute product_category.valid?
    assert_includes product_category.errors[:name], 'não pode ficar em branco'
    assert_includes product_category.errors[:code], 'não pode ficar em branco'
  end

  test 'must be uniq' do 
    ProductCategory.create!(name: 'Produto Antifraude', code: "ANTIFRA")
    product_category = ProductCategory.new(name: 'Produto Antifraude', code: "ANTIFRA")

    refute product_category.valid?
    assert_includes product_category.errors[:code], 'já está em uso'
  end

  test 'edit product category cannot be blank' do 
    product_category = ProductCategory.create!(name: 'Produto Antifraude', code: "ANTIFRA")
    product_category.update(name:'', code:'')

    refute product_category.valid?
    assert_includes product_category.errors[:name], 'não pode ficar em branco'
    assert_includes product_category.errors[:code], 'não pode ficar em branco'
  end

  test 'edit product category code must be uniq' do 
    product_category_1 = ProductCategory.create!(name: 'Produto Antifraude', code: "ANTIFRA")
    product_category_2 = ProductCategory.create!(name: 'Produto AntiDDOS', code: "ANTIDDO")
    product_category_2.update(code:'ANTIFRA')

    refute product_category_2.valid?
    assert_includes product_category_2.errors[:code], 'já está em uso'
  end

end
