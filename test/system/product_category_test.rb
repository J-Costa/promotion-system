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

  test 'delete product' do
      product_category = ProductCategory.create!(name: "Produto Antifraude", code: "ANTIFRA")

      login_as_user
      visit product_category_path(product_category)

      assert_difference 'ProductCategory.count', -1 do
          accept_confirm { click_on 'Deletar produto' }
          assert_text 'Deletado com sucesso'
      end
      assert_text 'Nenhum produto cadastrado'
      assert_no_text 'Produto Antifraude'
  end

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

  test 'do not view product without login' do
    product_category = ProductCategory.create!(name: "Produto Antifraude", code: "ANTIFRA")

    visit product_category_path(product_category)

    assert_current_path new_user_session_path
  end

  test 'do not view product using route without login' do
    visit product_categories_path

    assert_current_path new_user_session_path
  end

  test 'cannnot edit product without login' do
    product_category = ProductCategory.create!(name: "Produto Antifraude", code: "ANTIFRA")

    visit product_category_path(product_category)

    assert_current_path new_user_session_path
  end
end