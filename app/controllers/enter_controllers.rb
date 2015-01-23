class EnterController < ApplicationController
  include UserActions
    def enter
      #p=params[:user].permit(:email, :password)
      p = user_permitted_params(params[:user])
      
        @user=User.find_by_email(p.email)
        flash[:errors]=[]
        if @user.password==p.password
            if Time.now.between?(@user.ent_start, @user.ent_end)
                #CURL
            else
                if @user.user_type=='daypass' && @user.counter!=0 && Time.now.hour.between(9, 18)
                    @user.ent_start=Time.now
                    @user.ent_end=Time.mktime(Time.now.year, Time.now.month, Time.now.day, 18, 0, 0)
                    @user.counter--
                    #CURL
                elsif @user.user_type=='superadmin'
                    #CURL
                end
            end
        else
            flash[:errors]<<"Invalid password or email"
        end
    end
end
