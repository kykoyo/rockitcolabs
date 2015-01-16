class UserActions
  def user_permitted_params(user_params_hash)
    # Returns the permitted items in a typical user hash used by Devise

    user_params_hash.permit(:email, :password)
  end
end
