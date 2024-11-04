module AuthenticationHelpers
  def login_user(user, password, login_path)
    post login_path, params: {
      email: user.email,
      password: password
    }
  end
end