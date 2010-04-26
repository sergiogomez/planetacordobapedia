class SessionsController < ApplicationController
  def new
    redirect_to feeds_path if admin?
    save_referer
  end
  
  def create
    password = PC_CONF[:admin][:hash_password] == true ? Digest::SHA1.hexdigest(params[:password]) : params[:password]
    if params[:login] == PC_CONF[:admin][:login].to_s && password == PC_CONF[:admin][:password].to_s
      session[:admin] = true
      flash[:notice] = "Bienvenido #{PC_CONF[:admin][:login]}"
      redirect_to session[:return_to]
    else
      flash[:error] = "El usuario o la contraseña no son correctos"
      redirect_to login_path
    end
  end
  
  def destroy
    reset_session
    flash[:notice] = "Te has desconectado correctamente"
    redirect_to root_path
  end
end
