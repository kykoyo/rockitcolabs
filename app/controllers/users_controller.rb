class UsersController < ApplicationController
    #before_filter :authenticate_user!
    
    #clarify if preuser's expired time is valid or not
    #before_filter :check_valid_pre_user, only: :index

    def index
        # @pre_user=PreUser.new
        # @hidden_token=(0...8).map { (65 + rand(26)).chr }.join
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
            redirect_to root_path, notice: "User deleted."
        end
        else
            flash[:errors]<<'Invalid user'
        end
    end

    def edit
        @user=User.find(params[:id])        
    end
    def update
        user_params=params[:user].permit(:add_start, :add_end, :ent_start, :ent_end)
        @user=User.find(params[:id])
        @user.update(user_params)
        flash[:notice]='Changes submitted'
        redirect_to users_path
    end

    private


    def check_valid_pre_user
        @pre_users=PreUser.all
        @pre_users.each do |pre_user|
        if pre_user.expired_time<Time.now
            pre_user.destroy
        end
    end
    end
end
