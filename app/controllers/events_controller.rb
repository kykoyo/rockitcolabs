class EventsController < ApplicationController
  helper_method :update_user
  
  def index
    @counter=Event.where(owner_id: current_user).size

    if current_user==nil
        redirect_to root_path
    #show all users if superadmin
    elsif current_user.user_type=='superadmin'
        @events=Event.all
    else
    #show current user's status if not superadimin
        @events=Event.where(owner_id: current_user)
    end
  end


	def new
    @event=Event.new
    @token=(0...8).map { (65 + rand(26)).chr }.join

    #filtering if member and redirecting to new_for_member.
    #picking all events current_user has
    @current_event=Event.find_by_owner_id(current_user)
    @counter=Event.where(owner_id: current_user).size

    if current_user.user_type=='member'
      #if member has one or more events then link to edit page
      if @counter>=1
        redirect_to edit_event_path(@current_event.id)
      else
        redirect_to new_event_for_member_path
      end
    end
	end

  
	def create
    flash[:errors]=[]

    #prevent duplicating events from back button or logs
    duplicate_event=Event.find_by_token(params[:event][:token])
    if duplicate_event.nil?
    else
      flash[:errors]<<'Something went wrong.'
    end

    p=params[:event].permit(:title, :description, :start, :end, :token)
    @event=Event.new(p)

    # filter2: checking the time of event is valid
    if @event.start>=@event.end
      flash[:errors]<<"Invalid Start Time or End Time"
    end

    setting_user

    #DO NOT save any events or users until no errors
    if flash[:errors].size == 0
      @event.save

      #set owner's entering time 1 hour earlier/later from events
      owner=@event.owner
      if owner.user_type=='instructor'
        owner.ent_start=@event.start-60*60
        owner.ent_end=@event.end+60*60
      end

      render 'show'
    else
      # There were some errors - we don't save anything to the db.
      render 'new'
    end

	end


	def show
    @event = Event.find(params[:id])
	end


  def new_for_member
    @event=Event.new
    @token=(0...8).map { (65 + rand(26)).chr }.join

    #filtering if non-member or not
    if current_user.user_type!='member'
      redirect_to new_event_path
    end
  end

  def destroy
    @event=Event.find(params[:id])
    @event.destroy
    if @event.destroy
      redirect_to events_path, notice: "Event deleted"
    end
  end


  def edit
    @event=Event.find(params[:id])
    @user_info=""
    user_obj=@event.users
    user_obj.each do |user|
      @user_info+=user.email
      @user_info+=", "
      @user_info+=user.name
      @user_info+=", "
      @user_info+=user.phone.to_s
      @user_info+="\n"
    end
  end


  def update
    @event=Event.find(params[:id])
    p=params[:event].permit(:title, :description, :start, :end)

    flash[:errors]=[]

    #prevent duplicating events
    duplicate_event=Event.where(token: @event.token)
    if duplicate_event.size>=2
      flash[:errors]<<'Something went wrong.'
    end

    # filter2: checking the time of event is valid
    if @event.start>=@event.end
      flash[:errors]<<"Invalid Start Time or End Time"
    end


    setting_user

    if flash[:errors].size == 0
      @event.update(p)
      render 'show'
    else
      # There were some errors - we don't save anything to the db.
      render 'edit'
    end
    
  end


  private

  def setting_user  # this is all about setting owners and participants
    # First, set the owner using info sent from views
    # filter1: for setting the owner id, get user from id sent from view, if nil use the current_users id
    needed_id=params[:event][:users]
    if needed_id==nil
      user_obj=User.find(current_user)
    else
      user_obj=User.find(needed_id)
    end

    # set event's owner using data above
    @event.owner=user_obj

    # Second, create user if not in user table and connect them to the event

    # Take all the lines in the results of the text area tag
    # all_lines should be an array split line by line
    input = params[:Participants_Info]
    all_lines=input.split("\n")

    # For each line:
    all_participants = []

    #for each line, split comma by comma and get the data into email, name, phone
    
    all_lines.each do |line|

      data=line.split(',')

      #filter4: checking if there are exactly 3 data
      if data.size==3  
        data_array=data.map do |data_strip|
          data_strip.strip
        end

        #filter5: checking if email data containing @ or not
        email=data_array[0]
        if email.include?('@')
          name=data_array[1]
          phone=data_array[2] 

          #filter6: check if the participant is an existing user by email
          # if there is a user by that email - associate that user to the event
          user_obj = User.find_by_email(email)
          # else create a user and associate to that user.
          if user_obj.nil?
            user_obj=User.new(name: name, email: email, phone: phone, user_type: 'guest', password: '11111111')
          end
          all_participants << user_obj

          #error messages
        else
          flash[:errors] << "Line #{line} doesn't have a valid email."
        end
      else
        flash[:errors] << "Line #{line} doesn't have 3 entries"
      end
    end

    if @event.owner.user_type=='member' && @event.users.size+all_participants.size>2
      flash[:errors]<<'Member can invite up to 2 guests.'
    end
  # all_participants now has all the user objects - some of which are already in the db, and some are not.
    if flash[:errors].size == 0
      all_participants.each do |selected_user|
        # We don't know if this selected user is saved in the database
        if selected_user.id.nil?
          selected_user.save
        end
        # if there has already been a connection between selected_user and event, don't double-make it
        if UserEvent.find_by_user_id(selected_user)==nil || UserEvent.find_by_user_id(selected_user).event_id!=@event
          @event.users << selected_user
        end
      end
    end

    
  end


end
