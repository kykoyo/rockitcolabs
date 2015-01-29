class ChargesController < ApplicationController
#this controller is to store purchase information for daypass user

    def new
        #All parameters come from views, so no @charge or anything.
    end

    def create
        #initializing error messages
        flash[:error]=[]

        #make new charge with info from view
        email=params[:stripeEmail]
        token=params[:stripeToken]
        day=params[:day].to_i

        @charge=Charge.new(email: email, token: token, counter: day)

        #search for UserTable if exists or not
        @user=User.find_by_email(@charge.email)

        #create user with random string if not used before, otherwise add counter
        if @user.nil?
            password=(0...8).map { (65 + rand(26)).chr }.join            
            @user=User.new(email: email, password: password, user_type: 'daypass', counter: day)
        elsif @user.user_type=='daypass'
            @user.counter+=day
        else
            flash[:error]<<'You are already a member of us.'
        end

        #Set the amount according to how many days the user buys
        if day==1
            @amount=1000
        elsif day==3
            @amount=2500
        elsif day==5
            @amount=4000
        end

        #Devise default receiver. For the detailed info, see reference_list.txt
        begin

        customer = Stripe::Customer.create(
            :email => params[:stripeEmail],
            :card  => params[:stripeToken]
        )

        charge = Stripe::Charge.create(
            :customer    => customer.id,
            :amount      => @amount,
            :description => 'Rails Stripe customer',
            :currency    => 'usd'
        )
        rescue Stripe::CardError => e
            flash[:error]<< e.message
            redirect_to charges_path
        end

        #Never save any information until no errors detected
        if flash[:error].size==0
            @charge.save
            @user.skip_confirmation!
            @user.save
            render 'show'
        else
            render 'new'
        end

    end

    def show
        #Show payments info after transaction
        @user=User.find(params[:id])
    end
end
