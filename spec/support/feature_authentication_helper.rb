module FeatureAuthenticationHelper
  def sign_in_admin
    @user = create(:admin)
    visit new_admin_session_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'

    expect(page).to have_content("Signed in successfully")
  end
end

RSpec.configure do |config|
  config.include FeatureAuthenticationHelper, type: :feature
end
