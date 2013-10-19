class SuggestedAnswersController < ApplicationController

  before_action :load_room_question
  after_action :push_room_questions

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

  def push_room_questions
    view = render_to_string('rooms/_room_questions', locals: { room: @room_question.room }, layout: false )
    channel = "/rooms/#{@room_question.room_id}"
    faye_client.publish(channel, view)
  end
  
end
