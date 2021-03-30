require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase
	test 'update product' do
    product_category = ProductCategory.create!(name: "Produto Antifraude", code: "ANTIFRA")
    
    login_as_user
    visit edit_product_category_path(product_category)
    fill_in 'Nome', with: 'Antivirus'
    fill_in 'Código',	with: 'ANTIVIR' 
    click_on 'Atualizar Produto'

    assert_text 'Antivirus'
    assert_text 'ANTIVIR'
  end

  test 'update and code must be unique' do
    product_category = ProductCategory.create!(name: "Produto Antifraude", code: "ANTIFRA")
    ProductCategory.create!(name: "Produto Antivirus", code: "ANTIVIR")
    
    login_as_user
    visit edit_product_category_path(product_category)
    fill_in 'Nome', with: 'Antivirus'
    fill_in 'Código',	with: 'ANTIVIR' 
    click_on 'Atualizar Produto'

    assert_text 'já está em uso'
  end

	test 'cannnot edit product without login' do
    product_category = ProductCategory.create!(name: "Produto Antifraude", code: "ANTIFRA")

    visit product_category_path(product_category)

    assert_current_path new_user_session_path
  end
end