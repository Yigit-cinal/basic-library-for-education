class SessionsController < ApplicationController
  def new
  end

  def create
    if params[:username] == "admin" && params[:password] == "admin123"
      session[:admin_logged_in] = true
      redirect_to root_path, notice: "Başarıyla giriş yaptınız!"
    else
      flash.now[:alert] = "Kullanıcı adı veya şifre hatalı!"
      render :new
    end
  end

  def destroy
    session[:admin_logged_in] = nil
    redirect_to root_path, notice: "Başarıyla çıkış yaptınız!"
  end
end
