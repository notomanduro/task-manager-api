class Api::V1::InvitationsController < ApplicationController
    def show
        # @invitations = Invitation.all 
        # render json: @invitations 

        @project = Project.find(params[:project_id])
        @invitations = Invitation.where(:project_id => @project.id)
        render json: @invitations
    end 

    def create
        @project = Project.find(params[:project_id])
        @invitation  = @project.invitations.create(invitation_params.merge(sender: current_user))
        # @invitation.sender_id  = current_user.id 

        if @invitation.save
            # if user already exist
            if @invitation.recipient != nil 
                # send notification email
                @user = User.find(params[:user_id]) 
                InviteMailer.existing_user_invite(@invitation).deliver 
                # add user to project 
                @invitation.recipient.project.push(@invitation.project)
                render json: {
                    messages: 'user invited', 
                    is_messages: true, 
                    data: { invitation: @invitation }
                }, status: :ok
            else 
               InviteMailer.with(user: @user).welcome_email.deliver_now 
               render json: @invitation
            end  
        else 
            render json: { messages: 'invitation failed' }, status: :failed
        end  
    end 


    def destroy
        @invitation.find(params[:id])
        @invitation.destroy 
        render json: {
            messages: 'user has remove'
        }  
    end 

    private 

    def invitation_params
        params.require(:invitation).permit(:project_id, :sender_id, :email) 
    end 
end
