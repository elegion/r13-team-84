class SuggestedAnswersController < ApplicationController

  after_action :push_message, :push_question

  def create
    @suggested_answer = current_user.suggested_answers.create(suggested_answer_params)
    respond_to do |format|
      format.html { redirect_to @suggested_answer.room_question.room }
      format.js { head :ok }
    end
  end

  protected

  def room_question
    @suggested_answer.room_question
  end

  def suggested_answer_params
    params.require(:suggested_answer).permit(:value, :room_question_id)
  end

  def push_message
    channel = "/rooms/#{room_question.room_id}/message"
    data = {
      html: render_to_string('rooms/_user_message', layout: false,
                             locals: { suggested_answer: @suggested_answer }),
    }
    faye_client.publish(channel, data)
  end

  def push_question
    if @suggested_answer.is_valid?
      channel = "/rooms/#{room_question.room_id}/question"
      data = room_question.room.last_room_question.decorate.faye_hash
      faye_client.publish(channel, data)
    end
  end

end
