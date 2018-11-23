class VoiceMessageController < ApplicationController
  require 'will_paginate/array'
  before_action :signed_in_session, only: [:index, :download]
  before_action :correct_session,   only: [:index, :download]

  MOUNT_DIR   = '/mnt/infra/Recordings/Voice_Mail'
  
  def index
    @files = Dir.glob("#{MOUNT_DIR}/*").sort {|a,b| File.mtime(b) <=> File.mtime(a) }
    @files = @files.paginate(page: params[:page])
  end

  def download
    if Dir["#{MOUNT_DIR}/*"].include?("#{MOUNT_DIR}/#{params[:MediaFileName]}") then
      begin
        send_file "#{MOUNT_DIR}/#{params[:MediaFileName]}", :x_sendfile => true
      rescue => e
        flash[:danger] = "#{e}."
        redirect_to_back
      end
    else
      redirect_to_back
    end
  end

  private
  
    def correct_session
      allowed_phones = Session.find_by_name(current_session.name)[:allowed_phones]
      flash[:warning] = 'У вас нет прав для просмотра этой страницы' and redirect_to root_url unless allowed_phones.include?('VoiceMessage') || current_session.admin
    end
end
