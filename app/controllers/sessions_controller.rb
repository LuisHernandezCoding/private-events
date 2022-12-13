class SessionsController < Devise::SessionsController
  before_action :authenticate_2fa!, only: [:create]

  def authenticate_2fa!
    user = self.resource = find_user
    return unless user

    if user_params[:otp_attempt].present?
      auth_with_2fa(user)
    elsif user.valid_password?(user_params[:password]) && user.otp_required_for_login
      session[:user_id] = user.id
      qr = RQRCode::QRCode.new(user.otp_provisioning_uri(user.email, issuer: 'MyApp'))
      render 'users_otp/verify', locals: { qr: }
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :otp_attempt, :email, :remember_me)
  end

  def find_user
    if session[:user_id]
      User.find(session[:user_id])
    elsif user_params[:email]
      User.find_by(email: user_params[:email])
    end
  end

  def auth_with_2fa(user)
    if user.validate_and_consume_otp!(user_params[:otp_attempt])
      user.save!
      sign_in(user)
    else
      flash[:alert] = 'Invalid code'
      qr = RQRCode::QRCode.new(user.otp_provisioning_uri(user.email, issuer: 'MyApp'))
      render 'users_otp/verify', locals: { qr: }
    end
  end
end
