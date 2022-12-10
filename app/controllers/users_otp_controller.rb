class UsersOtpController < Devise::SessionsController
  before_action :authenticate_user!
  before_action :set_2fa, only: %i[enable disable]

  def enable
    current_user.otp_secret = User.generate_otp_secret
    current_user.otp_required_for_login = true
    current_user.save!
    redirect_back fallback_location: root_path
  end

  def disable
    current_user.otp_required_for_login = false
    current_user.otp_secret = nil
    current_user.save!
    redirect_back fallback_location: root_path
  end

  def settings
    # Generate a new QR code for enabling 2fa
    @qr = RQRCode::QRCode.new(current_user.otp_provisioning_uri(current_user.email, issuer: 'Private Events'))
    @qr = @qr.as_svg(offset: 0, color: '000', shape_rendering: 'crispEdges', module_size: 4)
    resource = current_user
    render 'users_otp/settings', locals: { resource:, qr: @qr, user: current_user }
  end

  def set_2fa
    # check if the user has 2fa enabled
    if current_user.otp_required_for_login
      # Check if the code is valid
      if current_user.validate_and_consume_otp!(params[:otp_attempt])
        # If the code is valid, set 2fa to false and save the user
        current_user.otp_required_for_login = false
        current_user.save!
        redirect_to root_path, notice: '2FA disabled'
      else
        # If the code is invalid, show an error
        flash[:alert] = 'Invalid code'
        redirect_to users_otp_settings_path
      end
    else
      # Check if the code is valid
      if current_user.validate_and_consume_otp!(params[:otp_attempt])
        # If the code is valid, set 2fa to true and save the user
        current_user.otp_required_for_login = true
        current_user.save!
        redirect_to root_path, notice: '2FA enabled'
      else
        # If the code is invalid, show an error
        flash[:alert] = 'Invalid code'
        redirect_to users_otp_settings_path
      end
    end
  end
end
