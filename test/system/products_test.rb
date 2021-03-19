require 'application_system_test_case'

class ProductTest < ApplicationSystemTestCase
    test 'visiting products session' do 
        visit root_path

        assert_link "Produtos"
        click_on "Produtos"
        assert_text "Produtos"
    end

    test "view products" do
            Product.create!(name: "Produto Antifraude", code: "ANTIFRA")
            
        
            visit root_path
            click_on 'Produtos'
        
            assert_text 'Produto Antifraude'
            assert_text 'ANTIFRA'
    end

    test 'view product details' do
        Product.create!(name: "Produto Antifraude", code: "ANTIFRA")
        Product.create!(name: "Produto AntiDDOS", code: "ANTIDDOS")

        visit root_path
        click_on 'Produtos'
        click_on 'Produto AntiDDOS'

        assert_text 'Produto AntiDDOS'
        assert_text 'ANTIDDOS'
    end

    test 'no products avaible' do
        visit root_path
        click_on "Produtos"

        assert_text "Nenhum produto cadastrado"
    end

    test 'view products and return to home page' do
        Product.create!(name: "Produto Antifraude", code: "ANTIFRA")

        visit root_path
        click_on "Produtos"
        click_on "Voltar"

        assert_current_path root_path
    end

    test 'view product details and return to products page' do 
        product = Product.create!(name: "Produto Antifraude", code: "ANTIFRA")

        visit product_path(product)
        click_on "Voltar"
        assert_current_path products_path
    end


    test 'create product' do
        visit root_path
        click_on "Produtos"
        click_on "Registrar um produto"
        fill_in "Nome", with: "Produto Antifraude"
        fill_in "Código", with: "ANTIFRA"
        click_on "Criar produto"

        assert_current_path product_path(Product.last)
        assert_text "Produto Antifraude"
        assert_text "ANTIFRA"
        assert_link "Voltar"
    end

    test 'create and attributes cannot be blank' do 
    end

    test 'create and code must be unique' do
    end

    test 'delete product' do 
    end

end