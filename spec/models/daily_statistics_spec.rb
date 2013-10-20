require 'spec_helper'

describe DailyStatistics do
  describe '#update_for_user' do
    let(:user) { create(:user) }

    context('when there is no stats for user for today') do
      it 'should create new statistics for user' do
        expect {
          DailyStatistics.update_for_user(user, 'ru', 1.2, 1)
        }.to change(DailyStatistics, :count).from(0).to(1)
      end

      it 'should have fastest answer 1.2' do
        DailyStatistics.update_for_user(user, 'ru', 1.2, 1).fastest_answer.should == 1.2
      end

      it 'should have answers_in_a_row = 1' do
        DailyStatistics.update_for_user(user, 'ru', 1.2, 1).answers_in_a_row.should == 1
      end

      it 'should have correct_answers = 1' do
        DailyStatistics.update_for_user(user, 'ru', 1.2, 1).correct_answers.should == 1
      end
    end

    context('when there are already stats for user for today') do
      let! (:current_stats) { create(:daily_statistics, user: user, locale: 'ru', fastest_answer:10, answers_in_a_row: 2, correct_answers: 3) }

      it 'should not create new statistics for user' do
        expect {
          expect {
            DailyStatistics.update_for_user(user, 'ru', 1.2, 1)
          }.not.to change(DailyStatistics, :count)
        }
      end

      it 'should update fastest_answer, if new is faster' do
        new_fastest_answer = current_stats.fastest_answer / 2
        DailyStatistics.update_for_user(user, 'ru', new_fastest_answer, 1).fastest_answer.should == new_fastest_answer
      end

      it 'should not update fastest_answer, if new is slower' do
        new_fastest_answer = current_stats.fastest_answer * 2
        DailyStatistics.update_for_user(user, 'ru', new_fastest_answer, 1).fastest_answer.should == current_stats.fastest_answer
      end

      it 'should update answers_in_a_row, if new is greater' do
        new_answers_in_a_row = current_stats.answers_in_a_row * 2
        DailyStatistics.update_for_user(user, 'ru', 1.2, new_answers_in_a_row).answers_in_a_row.should == new_answers_in_a_row
      end

      it 'should not update answers_in_a_row, if new is less' do
        new_answers_in_a_row = current_stats.answers_in_a_row / 2
        DailyStatistics.update_for_user(user, 'ru', 1.2, new_answers_in_a_row).answers_in_a_row.should == current_stats.answers_in_a_row
      end

      it 'should increase correct answers count' do
        DailyStatistics.update_for_user(user, 'ru', 1.2, 1).correct_answers.should == current_stats.correct_answers + 1
      end
    end
  end
end
