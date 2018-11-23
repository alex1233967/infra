#encoding: UTF-8
class InfraVisorController < ApplicationController
  require 'will_paginate/array'

  helper_method :sort_column, :sort_direction
  before_action :signed_in_session, only: [:index, :download]
  before_action :correct_session,   only: [:download]

  MOUNT_DIR   = '/mnt/infra/Recordings'

  def index
    calls, calls_allowed_to_download = get_calls
    @call_type = { 0 => :входящий, 1 => :исходящий, 2 => :внутренний }
    @calls = calls.paginate(page: params[:page], :per_page => 50)

    csvdata = CSV.generate do |csv|
      csv << ['Время начала', 'Имя звон.', 'Номер звон.', 'Линия звон.', 'Имя абон.', 'Номер абон.', 'Тип', 'Длит.']
      calls.each do |call|
        csv << [call[5].strftime("%Y-%m-%d %H:%M"), call[0], call[1], call[2], call[3], call[4], @call_type[call[6]], Time.at(call[7]).utc.strftime("%H:%M:%S")]
      end
    end

    respond_to do |format|
      format.html
      format.csv { send_data csvdata, filename: "calls.csv" }
    end
  end

  def download
    @calls, calls_allowed_to_download = get_calls
    if calls_allowed_to_download.include?(params[:MediaFileName]) and current_session.infravisor then
      begin
        send_file "#{MOUNT_DIR}/#{params[:MediaFileName].gsub("\\", "\/")}", :x_sendfile => true
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
      flash[:warning] = 'У вас нет прав для просмотра этой страницы' and redirect_to root_url unless current_session.infravisor || current_session.admin
    end

    def get_calls
      allowed_phones = Session.find_by_name(current_session.name)
      p = allowed_phones[:allowed_phones].split(',').map {|e| "'#{e}'"}.join(',')

#      start_time = 2.weeks.ago.strftime("%Y-%m-%d %H:%M")
      start_time = 3.months.ago.strftime("%Y-%m-%d %H:%M")
      sql = "SELECT 
		[OrgName],[OrgNumber],[OrgLine],[DestName],[DestNumber],[StartTime],[Direction],[Duration],[MediaFileName]
             FROM 
		.[dbo].[IV_CallRecord] 
	     WHERE 
		([StartTime]>'#{start_time}')
             AND 
		([OrgNumber] IN (#{p}) OR [DestNumber] IN (#{p}))
             ORDER BY 
		[#{sort_column}] #{sort_direction}"

      calls = InfraVisor.connection.select_rows(sql)

      calls_allowed_to_download = Array.new
      calls.each do |call| 
	calls_allowed_to_download << call[8] 
      end	

      return calls, calls_allowed_to_download
    end

    def sort_column
      %w[OrgName OrgNumber OrgLine DestName DestNumber StartTime Direction Duration].include?(params[:sort]) ? params[:sort] : "StartTime"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
