class EnterLogsController < ApplicationController
    require 'net/http'
    
    #include UserActions
    def new
        @enter=EnterLog.new
    end
    def create
        p=params[:enter_log].permit(:email)
        #p = user_permitted_params(params[:enter])
        @enter=EnterLog.new(p)

        flash[:error]=[]
      
        @user=User.find_by_email(params[:enter_log][:email])
        if @user.valid_password?(params[:enter_log][:password])
            if @user.ent_start!=nil&&@user.ent_end!=nil&&Time.now.between?(@user.ent_start, @user.ent_end)
                curl
            else
                if @user.user_type=='daypass' && @user.counter!=0 && Time.now.hour.between(9, 18)
                    @user.ent_start=Time.now
                    @user.ent_end=Time.mktime(Time.now.year, Time.now.month, Time.now.day, 18, 0, 0)
                    @user.counter-=1
                    curl
                elsif @user.user_type=='superadmin'
                    curl
                end
            end
        else
            flash[:error]<<"Invalid password or email"
        end
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
    def curl
        uri = URI(ENV["door_open_url"])
        req = Net::HTTP.get(uri)
    end
end
