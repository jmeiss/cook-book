module ControllerMacros

  def login_user user=nil
    @request.env['devise.mapping'] = Devise.mappings[:user]
    user ||= FactoryGirl.create(:user)
    # user.confirm! # Only necessary if you are using the confirmable module
    sign_in user
    user
  end

end
