class Api::V1::MessagesController < ApplicationController
    def show
        @messages = Message.all 
        render json: @messages.all 
    end 
    
    def create
        @project = Project.find(params[:project_id])
        @message = @project.messages.create(message_params.merge(user: current_user))

        if @message.save 
            ActionCable.server.broadcast "project_channel", content: @message.text
            render json: @message, status: :ok 
        else  
            render json: { error: 'invalid message' }, status: :failed
        end 
    end 

    def destroy
        @message = Message.find(params[:message_id])
        @message.destroy  
        
        render json: { message: 'message has delete' }, status: :ok
    end 

    private  

    def message_params 
        params.permit(:text, :sender_id, :image)
    end 
end
