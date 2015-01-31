class EnterLogsController < ApplicationController
    #When curl, 'net/http' is required
    require 'net/http'
    
    #include UserActions
    def new
        #Set the instance variable to get params from views
        @enter=EnterLog.new
    end
    def create
        #Get the params from views and set as new enter_logs
        p=params[:enter_log].permit(:email)
        #p = user_permitted_params(params[:enter])
        @enter=EnterLog.new(p)

        #initializing error messages
        flash[:notice]=[]
    
        #Users authentication:
        #Find user by email and compare password
        @user=User.find_by_email(params[:enter_log][:email])
        if @user.valid_password?(params[:enter_log][:password])
            #check for their enter allowed time
            t=Time.gm(Time.now.year, Time.now.month, Time.now.day, Time.now.hour, Time.now.min, 0)
            if @user.ent_start!=nil&&@user.ent_end!=nil&&t.between?(@user.ent_start, @user.ent_end)
                curl
            else
                #check if accessable daypass user
                if @user.user_type=='daypass' && @user.counter!=0 && Time.now.hour.between?(9, 18)
                    @user.ent_start=t
                    @user.ent_end=Time.gm(Time.now.year, Time.now.month, Time.now.day, 18, 0, 0)
                    @user.counter-=1
                    @user.save
                    curl
                #Always open door if superadmin
                elsif @user.user_type=='superadmin'
                    curl
                else
                    flash[:notice]<<'You are not allowed for now'
                end
            end
        else
            flash[:notice]<<"Invalid password or email"
        end

        #Logging if the user could enter or not
        if flash[:notice].size==0
            @enter.enter=true
            redirect_to new_user_session_path
            flash[:notice]=nil
        else
            @enter.enter=false
            render 'devise/sessions/new'
        end
        @enter.save
    end
    private
    #Call URL(curl) that opens the door
    def curl
        #Never use important info directly. write them in environmental function
        uri = URI(ENV["door_open_url"])
        req = Net::HTTP.get(uri)
    end
end
