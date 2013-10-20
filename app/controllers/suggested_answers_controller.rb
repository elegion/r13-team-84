class SuggestedAnswersController < ApplicationController

  before_action :load_room_question
  after_action :push_message, :push_question

  def create
    @suggested_answer = @room_question.suggested_answers.build(suggested_answer_params)
    @suggested_answer.save!
    respond_to do |format|
      format.html { redirect_to @room_question.room }
      format.js { head :ok }
    end
  end

  protected

  def load_room_question
    @room_question = RoomQuestion.find(params[:room_question_id])
  end

  def suggested_answer_params
    params.require(:suggested_answer).permit(:value).merge(user_id: current_user.id)
  end

  def push_message
    channel = "/rooms/#{@room_question.room_id}/message"
    html = render_to_string('rooms/_room_message', layout: false,
                            locals: { suggested_answer: @suggested_answer })
    faye_client.publish(channel, html: html)
  end

  def push_question
    channel = "/rooms/#{@room_question.room_id}/question"
    html = render_to_string('rooms/_room_question', layout: false,
                            locals: { room: @room_question.room })
    faye_client.publish(channel, html: html)
  end

end
