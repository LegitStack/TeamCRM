class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :edit, :update, :destroy]

  require 'csv'
  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = Notification.all
    #@notifications = Notification.where(user_id: current_user.id).order("asc")
    respond_to do |format|
      format.html
      format.csv { send_data @notifications.to_csv } #render text: @records.to_csv }
    end
  end

  def import
    if current_user.profile.title == "admin" or current_user.profile.title == "master"
      Notification.import(params[:file])
      redirect_to notifications_path, notice: "Records Imported"
    else
      redirect_to notifications_path, notice: "No Records Imported; You are not Admin."
    end
  end


  # GET /notifications/1
  # GET /notifications/1.json
  def show
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_params
      params.require(:notification).permit(:maker_id, :user_id, :thirdparty_id, :record_id, :changetype, :change)
    end
end
