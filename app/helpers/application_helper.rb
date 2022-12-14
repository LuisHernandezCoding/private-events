module ApplicationHelper
  def owner?
    current_user && @profile.user_id == current_user.id
  end
end
