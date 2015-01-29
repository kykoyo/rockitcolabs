class UsersController < ApplicationController
  #need to log in before going any pages
  before_filter :authenticate_user!
    
    def index
        if current_user==nil
            redirect_to root_path
        #show all users if superadmin
        elsif current_user.user_type=='superadmin'
            @users=User.all
        else
        #show current user's status if not superadimin
            @users=[current_user]
        end
    end


    def destroy
        @user=User.find(params[:id])
        flash[:errors]=[]
        if current_user.user_type=='superadmin'
        if @user==current_user
            flash[:errors]<<"You can't delete yourself"
        else
            @user.destroy
        end
        if @user.destroy
            redirect_to users_path, notice: "User deleted."
        end
        else
            flash[:errors]<<'Invalid user'
        end
    end

    #need to cover error processing
    def update
        user_params=params[:user].permit(:add_start, :add_end, :ent_start, :ent_end)
        @user=User.find(params[:id])
        @user.update(user_params)
        flash[:notice]='Changes submitted'
        redirect_to users_path
    end

end
