class UsersController < ApplicationController
    # extend UserHelper
    # helper :all
  #need to log in before going any pages
  before_filter :authenticate_user!
    
    def index
        if current_user==nil
            redirect_to root_path
        #show all users if superadmin
        elsif current_user.user_type=='superadmin'
            #Before giving data to views, order users by user_type
            @users=User.all.sort{|a, b| custom_sort(a.user_type)<=>custom_sort(b.user_type)}
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

    private
    #Sort users by user_type
    def custom_sort(user_type)
        if user_type=='superadmin'
            return 1
        elsif user_type=='member'
            return 2
        elsif user_type=='instructor'
            return 3
        elsif user_type=='guest'
            return 4
        else
            return 5
        end
    end
end
