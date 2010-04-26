module PagesHelper

  def is_login?
    controller_name == "sessions" and action_name == "new"
  end

end
