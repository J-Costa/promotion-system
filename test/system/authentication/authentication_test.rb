require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase
  test 'user sign up' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Nome', with: 'Jane Doe'
    fill_in 'Email', with: 'jane.doe@iugu.com.br'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirmação de senha', with: 'password'
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Boas vindas! Cadastrou e entrou com sucesso'
    assert_text 'jane.doe@iugu.com.br'
    click_on 'jane.doe@iugu.com.br' do
      assert_link 'Sair'
    end
    assert_no_link 'Cadastrar'
    assert_current_path root_path
  end

  test 'user sign up cant be blank' do
    visit root_path
    click_on 'Cadastrar'
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Senha não pode ficar em branco'
    assert_text 'Email não pode ficar em branco'
  end

  test 'user already signed' do
    user = User.create!(email: 'joao@iugu.com.br', password: '123456')

    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email',	with: user.email
    fill_in 'Senha',	with: user.password
    fill_in 'Confirmação de senha',	with: user.password
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Email já está em uso'
  end

  test 'user sign in' do
    user = User.create!(email: 'jane.doe@iugu.com.br', password: 'password')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Log in'

    assert_text 'Login efetuado com sucesso!'
    assert_text user.email
    assert_current_path root_path
    click_on user.email do
      assert_link 'Sair'
    end
    assert_no_link 'Entrar'
  end

  test 'logout test' do
    user = User.create!(email: 'jane.doe@iugu.com.br', password: 'password')
    login_as user, scope: :user

    visit root_path
    click_on user.email
    click_on 'Sair'

    assert_text 'Saiu com sucesso'
  end

  test 'user cannot login with wrong email or password' do
    user = User.create!(email: 'joao@iugu.com.br', password: '123456')

    visit root_path
    click_on 'Entrar'

    fill_in 'Email',	with: 'jose@nao.iugu.com.br'
    fill_in 'Senha',	with: 'senhaerrada'
    click_on 'Log in'

    assert_text 'Email ou senha inválida'
  end

  test 'user can edit email and password' do
    user = User.create!(name: 'joao silva', email: 'joao@iugu.com.br', password: '123456')

    login_as_user(user)
    visit root_path
    click_on user.email
    click_on 'Editar dados'
    fill_in 'Nome',	with: 'jose maria'
    fill_in 'Email',	with: 'jose@iugu.com.br'
    fill_in 'Senha',	with: 'senhatrocada'
    fill_in 'Confirmação de senha',	with: 'senhatrocada'
    fill_in 'Senha atual',	with: '123456'
    click_on 'Atualizar Usuário'

    assert_text 'Sua conta foi atualizada com sucesso'
    assert_link 'jose@iugu.com.br'
  end

  # TODO: não logar e ir para o login?
  # TODO: confirmar a conta?
  # TODO: mandar email?
  # TODO: validar a qualidade da senha?
  # TODO: captcha não sou um robô
end
