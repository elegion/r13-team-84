class SuggestedAnswersController < ApplicationController

  before_action :load_room_question
  after_action :push_room_questions

  def create
    @suggested_answer = @room_question.suggested_answers.build(suggested_answer_params)
    @suggested_answer.save!
    respond_to do |foramt|
      foramt.html { redirect_to @room_question.room }
      foramt.js { head :ok }
    end
  end

protected

  def load_room_question
    @room_question = RoomQuestion.find(params[:room_question_id])
  end

  def suggested_answer_params
    params.require(:suggested_answer).permit(:value).merge(user_id: current_user.id)
  end

  def push_room_questions
    channel = "/rooms/#{@room_question.room_id}/message"
    data = {
        user: current_user.name,
        message: @suggested_answer.value
    }
    faye_client.publish(channel, data)
  end
  
end
