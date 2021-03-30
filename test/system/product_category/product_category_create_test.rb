require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase
  test 'create product' do
    login_as_user
    visit root_path
    click_on "Produtos"
    click_on "Registrar um(a) Produto"
    fill_in "Nome", with: "Produto Antifraude"
    fill_in "Código", with: "ANTIFRA"
    click_on "Criar Produto"

    assert_current_path product_category_path(ProductCategory.last)
    assert_text "Produto Antifraude"
    assert_text "ANTIFRA"
    assert_link "Voltar"
  end

  test 'create and attributes cannot be blank' do 
    ProductCategory.create!(name: "Produto Antifraude", code: "ANTIFRA")
    
    login_as_user
    visit root_path
    click_on 'Produtos'
    click_on 'Registrar um(a) Produto'
    fill_in "Nome",	with: "" 
    fill_in "Código",	with: "" 
    click_on "Criar Produto"

    assert_text 'não pode ficar em branco', count: 2

  end

  test 'create and code must be unique' do
    ProductCategory.create!(name: "Produto Antifraude", code: "ANTIFRA")

    login_as_user
    visit root_path
    click_on 'Produtos'
    click_on "Registrar um(a) Produto"
    fill_in 'Código', with: 'ANTIFRA'
    click_on 'Criar Produto'

    assert_text 'já está em uso'
  end
end