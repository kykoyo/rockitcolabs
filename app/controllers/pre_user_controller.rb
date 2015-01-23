class PreUserController < ApplicationController
    def create
        p=params[:pre_user].permit(:name, :email, :user_type)
        @hidden_token=(0...8).map { (65 + rand(26)).chr }.join
        @pre_user=PreUser.new(p, hidden_token: @hidden_token, expired_time: Time.now+7*24*60*60)
        
        if @pre_user.name.nil? || @pre_user.email.nil?
            flash[:errors]='Complete data required'
        else
            respond_to do |format|
                if @pre_user.save
                    AutoMail.auto_mail(@pre_user).deliver
                    format.html{redirect_to users_path, notice: 'Invitation has successfully sent.'}
                else
                    format.html{redirect_to users_path, notice: 'Something went wrong.'}
                end
            end
        end
    end
end
