class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @reports = Report.order(created_at: :desc)
  end

  def get_report
    report = Report.create(user: current_user, month: Time.zone.now.month - 1)
    flash[:success] = 'Report successfully created. Check your email soon.'
    redirect_to(request.referer || root_path)
  end
end
