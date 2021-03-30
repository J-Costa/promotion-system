require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase
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
end