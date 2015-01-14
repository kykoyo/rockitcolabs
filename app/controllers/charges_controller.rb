class ChargesController < ApplicationController
    def new
        @charge.new
    end

    def create
        #initializing error messages
        flash[:errors]=[]

        #make new charge with info from view
        email=params[:stripeEmail]
        token=params[:stripeToken]
        day=params[:day].to_i

        @charge=Charge.new(email: email, token: token, day: day)

        #search for UserTable if exists or not
        @user=User.find_by_email(@charge.email)

        #create user with random string if not used before, otherwise add counter
        if @user.nil?
            password=(0...8).map { (65 + rand(26)).chr }.join            
            @user=User.new(email: email, password: password, user_type: 'daypass', counter: day)
        elsif @user.user_type=='daypass'
            @user.counter+=day
        else
            flash[:errors]<<'You are already a member of us.'
        end

        # Amount in cents
        if day==1
            @amount=1000
        elsif day==3
            @amount=2500
        elsif day==5
            @amount=4000
        end

        begin

        customer = Stripe::Customer.create(
            :email => params[:stripeEmail],
            :card  => params[:stripeToken]
        )

        puts @amount
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
        if flash[:errors].size==0
            @charge.save
            @user.save
            render 'show'
        end

    end

    def show
        @user=User.find(params[:id])
    end
end
