class SessionsController < Devise::SessionsController
  before_action :authenticate_2fa!, only: [:create]

  def authenticate_2fa!
    # First lets find the user and add to the resource
    user = self.resource = find_user
    # If the user is not found, we can't authenticate so return
    return unless user

    # if otp_attempt is present, we are trying to authenticate with 2fa
    # otp_attempt is the code the user entered in the form
    if user_params[:otp_attempt].present?
      # authenticate with 2fa
      auth_with_2fa(user)
    # Else we are trying to authenticate with email and password
    elsif user.valid_password?(user_params[:password]) && user.otp_required_for_login
      # Store the user id in the session
      session[:user_id] = user.id
      # CodeMailer.send_code(user).deliver_now # this is for Mailer
      # Create a new code and send it to the verify view
      qr = RQRCode::QRCode.new(user.otp_provisioning_uri(user.email, issuer: 'MyApp'))
      render 'users_otp/verify', locals: { qr: }
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:password, :otp_attempt, :email, :remember_me)
  end

  # Find the user by email or session-id
  def find_user
    if session[:user_id]
      User.find(session[:user_id])
    elsif user_params[:email]
      User.find_by(email: user_params[:email])
    end
  end

  # Authenticate with 2fa
  def auth_with_2fa(user)
    # the user has entered the correct code and its consumed
    if user.validate_and_consume_otp!(user_params[:otp_attempt])
      # save the user
      user.save!
      # sign in the user
      sign_in(user)
    else
      # if the code is invalid, show an error
      flash[:alert] = 'Invalid code'
      # Create a new code and send it to the verify view
      qr = RQRCode::QRCode.new(user.otp_provisioning_uri(user.email, issuer: 'MyApp'))
      render 'users_otp/verify', locals: { qr: }
    end
  end
end
