module Features
  module SessionHelpers

    # Signs in resource via UI
    def sign_in(email, password)
      visit new_user_session_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Sign in'
    end

    # Signs out resource via UI
    def sign_out
      click_link 'Sign out'
    end

    # Logs in resource via Warden library bypassing UI
    def login(resource)
      login_as resource.user, scope: :user
    end
  end
end