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
        flash[:error]=[]
    
        #Users authentication:
        #Find user by email and compare password
        @user=User.find_by_email(params[:enter_log][:email])
        if @user.valid_password?(params[:enter_log][:password])
            #check for their enter allowed time
            if @user.ent_start!=nil&&@user.ent_end!=nil&&Time.now.between?(@user.ent_start, @user.ent_end)
                curl
            else
                #check if accessable daypass user
                if @user.user_type=='daypass' && @user.counter!=0 && Time.now.hour.between?(9, 18)
                    @user.ent_start=Time.now
                    @user.ent_end=Time.mktime(Time.now.year, Time.now.month, Time.now.day, 18, 0, 0)
                    @user.counter-=1
                    curl
                #Always open door if superadmin
                elsif @user.user_type=='superadmin'
                    curl
                end
            end
        else
            flash[:error]<<"Invalid password or email"
        end

        #Logging if the user could enter or not
        if flash[:error].size==0
            @enter.enter=true
            render 'devise/sessions/new'
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
