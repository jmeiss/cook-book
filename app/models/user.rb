class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable, :registerable, :recoverable, :rememberable, 
          :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  has_many :recipes

  def self.find_for_facebook_oauth auth, signed_in_resource=nil
    user = User.where(provider: auth.provider, uid: auth.uid).first
    
    unless user
      user = User.create  first_name: auth.extra.raw_info.first_name,
                          last_name:  auth.extra.raw_info.last_name,
                          provider:   auth.provider,
                          uid:        auth.uid,
                          email:      auth.info.email,
                          password:   Devise.friendly_token[0,20]
    end

    user
  end

  def self.new_with_session params, session
    super.tap do |user|
      if data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_param
    "#{id}-#{full_name}".parameterize
  end

private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end

end
