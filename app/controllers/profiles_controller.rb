class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

    require 'csv'

    require 'rubygems' # not necessary with ruby 1.9 but included for completeness
    require 'twilio-ruby'

  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.search(params[:search])

    respond_to do |format|
      format.html
      format.csv { send_data Profile.all.to_csv } #render text: @records.to_csv }
    end
  end

  def import
    if current_user.profile.title == "admin" or current_user.profile.title == "master"
      Profile.import(params[:file])
      redirect_to profiles_path, notice: "Records Imported"
    else
      redirect_to profiles_path, notice: "No Records Imported; You are not Admin."
    end
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    if @profile.email == "john@superiorlending.net" #@profile.firstname == "John" and @profile.lastname == "Johnson" and
      @dosomethingspecial="showRams()"
    end

    #@recs = Records.where(processor_id: current_user.id).order(sort_column + " " + sort_direction)
    #      @records = Record.where(processor_id: current_user.id).order(sort_column + " " + sort_direction)

    ##@recs = Record.where('processor_id= ? OR loanofficer_id= ? OR marketer_id= ?',params[:id],params[:id],params[:id])
    ##@successrate = @recs.sum(:progress)

    #do this for all of the other things you have to track (above)
    #make sure you set watchers - if it hasn't been changed from 0 to 1  in progress before thatn fill out the first touch time. easy as that.
    #add in each statistic to the scheme then when it is triggered calculate the statistic once and fill it out. It'll be the Record Scheme because these statistics are on each record.
    #that way here we don't have waisted resources trying to figure it out - a calculation we could get wrong anyway, these dont' ever change.


 #   @recs.each do |rec|
 #     @firsttime = @firsttime + rec.created_at - Time.now # distance_of_time(rec.created_at, Time.now)
 #     @lasttime = @lasttime + rec.created_at - rec.updated_at # distance_of_time(rec.created_at, rec.updated_at)
 #     if rec.progress = "11"
 #       tempcount = tempcount +1
 #     end
 #   end
 #  @sucessrate = tempcount / recs.count
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit

    if @profile.email == "john@superiorlending.net" #@profile.firstname == "John" and @profile.lastname == "Johnson" and
      @dosomethingspecial="showRams()"
    end

    @listoftitles = [["Loan Officer", "loan officer"],["Processor", "processor"],["Marketer", "marketer"],["Realtor", "realtor"],["Escrow Officer", "escrow officer"]]

    if current_user.profile.title == "admin"
      @recs = Record.all
      @listoftitles.push(["Admin","admin"])
    end

    if current_user.profile.title == "master"
      @listoftitles = [["Loan Officer", "loan officer"],["Processor", "processor"],["Marketer", "marketer"],["Realtor", "realtor"],["Escrow Officer", "escrow officer"],["Admin", "admin"]]
    end

    if Profile.find_by_id(params[:id]).user_id == current_user.id || current_user.profile.title = "master"
      @recs = Record.where('processor_id= ? OR loanofficer_id= ? OR marketer_id= ?',params[:id],params[:id],params[:id])
      if @profile.email == "jordan.kay@gmail.com" and current_user.email == "jordan.kay@gmail.com"
        @listoftitles = [["Loan Officer", "loan officer"],["Processor", "processor"],["Marketer", "marketer"],["Realtor", "realtor"],["Escrow Officer", "escrow officer"],["Admin", "admin"],["Master", "master"]]
        @recs = Record.all
      end
    else
      redirect_to root_path
    end
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to root_path, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to root_path, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def changestatus2
    if current_user.profile.status == "free"
      current_user.profile.update_attributes :status => "busy" #params[:id]#Profile.find(params[:id]).user_id)
    else
      current_user.profile.update_attributes :status => "free"
    end

   #UserMailer.welcome_email(current_user.profile).deliver

      if User.exists?(1)
        uprofile = User.find(1).profile
        if uprofile.name.blank?
          fromname = uprofile.email
        else
          fromname = uprofile.name
        end
      else
        fromname = "none"
      end

    temptime = Time.now
    subject = "Progress made on " + Record.find(1).firstname + " " + Record.find(1).lastname + "'s Loan"
    message = fromname + " changed " + Record.find(1).firstname + " " + Record.find(1).lastname + "'s " + "progression step 1" + " from " + "'Not Done'" + " to " +  "'Done'" + " "+ temptime.strftime("on %m/%d/%Y") + " " + temptime.strftime("at %l:%M%p") +"."
    UserMailer.send_simple("Jordan Miller", "jordan.kay@gmail.com", subject, message)
   # UserMailer.send_simple_message
    redirect_to root_path
  end

  def changestatus3
    if current_user.profile.status == "free"
      current_user.profile.update_attributes :status => "busy" #params[:id]#Profile.find(params[:id]).user_id)
    else
      current_user.profile.update_attributes :status => "free"
    end
    @record = Record.find(72)

    listofnewpeeps = []

    listofnewpeeps.push(Profile.find_by_id(@record.loanofficer_id)) if !Profile.find_by_id(@record.loanofficer_id).blank?
    listofnewpeeps.push(Profile.find_by_id(@record.processor_id)) if !Profile.find_by_id(@record.processor_id).blank?
    listofnewpeeps.push(Profile.find_by_id(@record.marketer_id)) if !Profile.find_by_id(@record.marketer_id).blank?
    listofnewpeeps.push(Profile.find_by_id(@record.real_id)) if !Profile.find_by_id(@record.real_id).blank?
    listofnewpeeps.push(Profile.find_by_id(@record.escrow_id)) if !Profile.find_by_id(@record.escrow_id).blank?

    Profile.where(:title => "admin").each do |prof|
      listofnewpeeps.push(prof)
    end
    mytext = "listofnewpeeps"
    listofnewpeeps.each do |peep|
      if !peep.blank?
        mytext = mytext + ":" + peep.id.to_s
      end
    end


    redirect_to root_path, notice: mytext
  end

  def changestatus
    # put your own credentials here
    account_sid = 'AC56c471e13ee6660cd2dfbe5b39088498'
    auth_token = 'ee24d5ac278a24beb6ce4f54d6c96e77'

    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token

    @client.account.messages.create({
    	:from => '+14155992671',
    	:to => '+18018312055',
    	:body => 'test',
    })
    redirect_to root_path
  end

  def resetpassword
    if current_user.profile.title == "master"
      user = User.find_by_id(params[:id])
     if user
        #user.password = "password123"
        #user.password_confirmation = "password123"
        #user.save
        if user.update(:password => "password123", :password_confirmation => "password123")
          redirect_to root_path, notice: 'Password was successfully updated.'
        end
      else
        redirect_to root_path, notice: 'Password was not successfully updated.'
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      #if current_user.id.to_i == params[:id].to_i
	  	  if Profile.find_by_id(params[:id]).blank?
  	      @profile = Profile.new
  	      @profile.email = current_user.email
  	      @profile.user_id = current_user.id
  	      @profile.save
  	      @profile = Profile.find(params[:id])
  	    else
          @profile = Profile.find(params[:id])
        end
      #else
      #	@profile = Profile.find(params[:id])#redirect_to root_path, notice: params[:id]
      #end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:name, :phone, :email, :title, :bio, :assignmail, :progressmail, :phasemail, :status, :user_id)
    end
end
