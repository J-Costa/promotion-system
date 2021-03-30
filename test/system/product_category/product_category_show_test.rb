require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase
  test 'visiting products session' do 
    login_as_user
    visit root_path

    assert_link "Produtos"
    click_on "Produtos"
    assert_text "Produtos"
  end

  test "view products" do
    ProductCategory.create!(name: "Produto Antifraude", code: "ANTIFRA")
    
    login_as_user
    visit root_path
    click_on 'Produtos'

    assert_text 'Produto Antifraude'
    assert_text 'ANTIFRA'
  end

  test 'view product details' do
    ProductCategory.create!(name: "Produto Antifraude", code: "ANTIFRA")
    ProductCategory.create!(name: "Produto AntiDDOS", code: "ANTIDDOS")

    login_as_user
    visit root_path
    click_on 'Produtos'
    click_on 'Produto AntiDDOS'

    assert_text 'Produto AntiDDOS'
    assert_text 'ANTIDDOS'
  end

  test 'no products avaible' do
    login_as_user
    visit root_path
    click_on "Produtos"

    assert_text "Nenhum produto cadastrado"
  end

  test 'view products and return to home page' do
    ProductCategory.create!(name: "Produto Antifraude", code: "ANTIFRA")
    
    login_as_user
    visit root_path
    click_on "Produtos"
    click_on "Voltar"

    assert_current_path root_path
  end

  test 'view product details and return to products page' do 
    product = ProductCategory.create!(name: "Produto Antifraude", code: "ANTIFRA")

    login_as_user
    visit product_category_path(product)
    click_on "Voltar"
    assert_current_path product_categories_path
  end  

  test 'do not view product without login' do
    product_category = ProductCategory.create!(name: "Produto Antifraude", code: "ANTIFRA")

    visit product_category_path(product_category)

    assert_current_path new_user_session_path
  end
  
  test 'do not view product using route without login' do
    visit product_categories_path

    assert_current_path new_user_session_path
  end
  
end