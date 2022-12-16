class PagesController < ApplicationController
  before_action :authenticate_user!, only: %w[contact]

  def home; end
  def about; end

  def contact
    @contact = Contact.new
    @profile = current_user.profile
    @contacts = Contact.all if @profile.is_admin
  end

  def contact_create
    @profile = current_user.profile
    @contact = Contact.new({ name: @profile.username, email: @profile.user.email, content: params[:contact][:content] })
    if @contact.save
      redirect_to contact_success_path, notice: 'Message sent'
    else
      render :contact, alert: 'Message not sent', status: :unprocessable_entity, locals: { profile: @profile }
    end
  end

  def contact_destroy
    return unless current_user.profile.is_admin

    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to contact_path, notice: 'Message deleted'
  end

  def contact_success; end

  def tos; end
  def privacy; end
end
