class EventsController < ApplicationController
  before_filter :authenticate_member, :only => 'new'

  def index
    @events = Event.all
  end

	def new
    @event=Event.new
	end
  
	def create
	  p=params[:event].permit(:title, :description)
	  @event=Event.new(p)

	  needed_id=params[:event][:users]
	  user_obj=User.find(needed_id)

          # This user is the owner of the event.
	  @event.owner=user_obj

          # Take all the lines in the results of the text area tag
          input = params[:Participants_Info]
          all_lines=input.split("\n")
          # all_lines  should be an array
          # For each line:

          #initialize flash[:errors] <-(error message) to be an array
          flash[:errors] = []
          all_participants = []

          all_lines.each do |line|

            data=line.split(',')
            if data.size==3  
              data_array=data.map do |data_strip|
                data_strip.strip
              end
              email=data_array[0]
              if email.include?('@')
                name=data_array[1]
                phone=data_array[2] # get email from line somehow

                # if there is a user by that email - associate that user to the event
                user_obj = User.find_by_email(email)
                # else create a user and associate to that user.
                if user_obj.nil?
                  user_obj=User.new(name: name, email: email, phone: phone, user_type: 'guest', password: '11111111')
                  # No user with that email
                end
                all_participants << user_obj
              else
                flash[:errors] << "Line #{line} doesn't have a valid email."
              end
            else
              flash[:errors] << "Line #{line} doesn't have 3 entries"
            end
          end

          # all_participants now has all the user objects - some of which are already in the db, and some are not.

          # Do something after creating the event
          # If we saw no errors, let's render the show
          if flash[:errors].size == 0

            # Homework - Ideally, we should save all participants in the database here, and not earlier in the action.
            @event.save
            all_participants.each do |selected_user|
              # We don't know if this selected user is saved in the database
              if selected_user.id.nil?
                selected_user.save
              end
              @event.users << selected_user
            end
            
            render 'index' # meaning: use the show view in the views/events folder
          else
            # There were some errors - we don't save anything to the db.
            render 'new'
          end
	end

	def show
          #	  @events=Event.all
          @event = Event.find(params[:id])
	end
  def new_for_member
    @event=Event.new
  end

  def create_for_member
    p=params[:event].permit(:title, :description)
    @event=Event.new(p)


    needed_id=params[:event][:users]
    user_obj=User.find(needed_id)

          # This user is the owner of the event.
    @event.owner=user_obj

          # Take all the lines in the results of the text area tag
          input = params[:Participants_Info]
          all_lines=input.split("\n")
          # all_lines  should be an array
          # For each line:

          #initialize flash[:errors] to be an array
          flash[:errors] = []
          all_participants = []

          #if member is inviting 2 or less visitor, then allow. else make error message.
          if all_lines.size>=2

            all_lines.each do |line|

              data=line.split(',')
              if data.size==3  
                data_array=data.map do |data_strip|
                  data_strip.strip
                end
                email=data_array[0]
                name=data_array[1]
                phone=data_array[2] # get email from line somehow
                  
                if email.include?('@')
                  # if there is a user by that email - associate that user to the event
                  user_obj = User.find_by_email(email)
                  # else create a user and associate to that user.
                  if user_obj.nil?
                    user_obj=User.new(name: name, email: email, phone: phone, user_type: 'guest', password: '11111111')
                    # No user with that email
                  end
                  all_participants << user_obj
                else
                  flash[:errors] << "Line #{line} doesn't have a valid email."
                end
              else
                flash[:errors] << "Line #{line} doesn't have 3 entries"
              end
            end
          else
            flash[:errors] << "You are allowed to invite only 2 visitors"
          end

          # all_participants now has all the user objects - some of which are already in the db, and some are not.

          # Do something after creating the event
          # If we saw no errors, let's render the show
          if flash[:errors].size == 0

            # Homework - Ideally, we should save all participants in the database here, and not earlier in the action.
            @event.save
            all_participants.each do |selected_user|
              # We don't know if this selected user is saved in the database
              if selected_user.id.nil?
                selected_user.save
              end
              @event.users << selected_user
            end
            
            render 'show' # meaning: use the show view in the views/events folder
          else
            # There were some errors - we don't save anything to the db.
            render 'new'
          end
  end

  def destroy
    @event=Event.find(params[:id])
    @event.destroy
    redirect_to events_path
  end

  def edit
    @event=Event.find(params[:id])
  end

  def update
    p=params[:event].permit(:title)
    if @event.update(p)
      redirect_to event_path
    else
      render 'edit'
    end
  end

  private

  def authenticate_member
    if current_user.user_type=='member'
      render 'new_for_members'
      if current_user.event.size!=0
        render 'edit'
      end
    end
  end


end
