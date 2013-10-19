class SuggestedAnswersController < ApplicationController

  before_action :load_room_question

  def create
    suggested_answer = @room_question.suggested_answers.build(suggested_answer_params)
    suggested_answer.save!
    redirect_to @room_question.room
  end

protected

  def load_room_question
    @room_question = RoomQuestion.find(params[:room_question_id])
  end

  def suggested_answer_params
    params.require(:suggested_answer).permit(:value).merge(user_id: current_user.id)
  end
  
end
