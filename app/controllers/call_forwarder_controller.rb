#encoding: UTF-8
class CallForwarderController < ApplicationController
  before_action :signed_in_session, only: [:index, :update]
  before_action :correct_session,   only: [:index, :update]

  MOUNT_DIR    = '/mnt/infra/script2'

  FILE_WORKDAY = "#{MOUNT_DIR}/call_forwarder_workday.txt"
  FILE_WEEKEND = "#{MOUNT_DIR}/call_forwarder_weekend.txt"

  def index
    begin
      @content_workday = Phone.find_by_branch(File.open(FILE_WORKDAY).first.to_i)
      @content_weekend = Phone.find_by_branch(File.open(FILE_WEEKEND).first.to_i)
    rescue => e
      flash.now[:danger] = "#{e}."
      @disable_button = true
    end
  end

  def update
    begin
      File.write(FILE_WORKDAY, Phone.find_by_phone_number(params[:post][:phone_number_workday]).branch) unless params[:post][:phone_number_workday].nil?
      File.write(FILE_WEEKEND, Phone.find_by_phone_number(params[:post][:phone_number_weekend]).branch) unless params[:post][:phone_number_weekend].nil?
    rescue => e
      flash[:danger] = "#{e}."
    end
      flash[:success] = "Переадресация установлена." if flash[:danger].nil?
      redirect_to_back
  end

  private

    def correct_session
      flash[:warning] = 'У вас нет прав для просмотра этой страницы' and redirect_to root_url unless current_session.callforwarder || current_session.admin
    end
end
