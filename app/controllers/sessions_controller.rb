#encoding: UTF-8
class SessionsController < ApplicationController
  before_action :signed_in_session, only: [:phones, :users, :update_phones, :update_users, :delete_phones, :delete_users, :destroy]
  before_action :correct_session,   only: [:phones, :users, :update_phones, :update_users, :delete_phones, :delete_users]

  def new
    if signed_in?
      redirect_url = users_url if current_session.admin
      redirect_url = callforwarder_url if current_session.callforwarder
      redirect_url = infravisor_url if current_session.infravisor
      redirect_to redirect_url
    end
  end

  def users
    @sessions = Session.all
  end

  def phones
    @phones = Phone.all
  end

  def delete_phones
    Phone.find(params[:id]).destroy
    flash[:success] = "Запись удаленa."
    redirect_to phones_url
  end

  def delete_users
    Session.find(params[:id]).destroy
    flash[:success] = "Запись удаленa."
    redirect_to users_url
  end

  def update_phones
    @phone=Phone.new(new_phone_params)
    if new_phone_params.values.exclude? "" then
      @phone.save
      flash.now[:warning]=@phone.errors.full_messages.first if @phone.errors.any?
    end
    @phones = Phone.all
    params.require(:phone).permit!
    params[:phone].keys.each do |id|
      @phone = Phone.find(id.to_i)
      @phone.update_attributes(params[:phone][id])
      flash.now[:warning]=@phone.errors.full_messages.first if @phone.errors.any?
    end
    flash.now[:success]='Параметры обновлены успешно' if flash.now[:warning].nil?
    render 'phones'
  end

  def update_users
    @session=Session.new(new_session_params)
    if new_session_params.values.exclude? "" then
      @session.save
      flash.now[:warning]=@session.errors.full_messages.first if @session.errors.any?
    end
    @sessions = Session.all
    params.require(:session).permit!
    params[:session].keys.each do |id|
      @session = Session.find(id.to_i)
      @session.update_attributes_only_if_not_blank(params[:session][id])
      flash.now[:warning]=@session.errors.full_messages.first if @session.errors.any?
    end
    flash.now[:success]='Параметры обновлены успешно' if flash.now[:warning].nil?
    render 'users'
  end

  def create
    session = Session.find_by(name: params[:session][:name].downcase)
    if session && session.authenticate(params[:session][:password])
      sign_in session
      path= '/infravisor'    if session.infravisor
      path= '/callforwarder' if session.callforwarder
      path= '/users'         if session.admin
      redirect_to "#{path}"
    else
      flash.now[:warning] = 'Неверное имя пользователя или пароль'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

  private

    def session_params
      params.require(:session).permit(:name, :password)
    end

    def correct_session
      flash[:warning] = 'У вас нет прав для просмотра этой страницы' and redirect_to root_url unless current_session.admin
    end

    def new_phone_params
      params.require(:new_phone).permit(:name, :phone_number, :branch)
    end

    def new_session_params
      params.require(:new_session).permit(:name, :password, :admin, :infravisor, :callforwarder, :allowed_phones)
    end
end
