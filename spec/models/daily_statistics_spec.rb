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

  describe '#stats_for_date' do
    context 'when there are no stats' do
      it 'should return empty querysets' do
        res = DailyStatistics.stats_for_date('ru', Date.today)
        res[:fastest_answer].should be_empty
        res[:answers_in_a_row].should be_empty
        res[:correct_answers].should be_empty
      end
    end

    it 'should return fastest_answer' do
      s1 = create(:daily_statistics, fastest_answer: 1.2)
      s2 = create(:daily_statistics, fastest_answer: 1.1)
      create(:daily_statistics, fastest_answer: 0.1, stats_date: Date.yesterday)
      DailyStatistics.stats_for_date('ru', Date.today)[:fastest_answer].should eq([s2, s1])
    end
    it 'should return answers_in_a_row' do
      s1 = create(:daily_statistics, answers_in_a_row: 6)
      s2 = create(:daily_statistics, answers_in_a_row: 5)
      create(:daily_statistics, answers_in_a_row: 10, stats_date: Date.yesterday)
      DailyStatistics.stats_for_date('ru', Date.today)[:answers_in_a_row].should eq([s1, s2])
    end
    it 'should return correct_answers' do
      s1 = create(:daily_statistics, correct_answers: 10)
      s2 = create(:daily_statistics, correct_answers: 100)
      create(:daily_statistics, correct_answers: 1, stats_date: Date.tomorrow)
      DailyStatistics.stats_for_date('ru', Date.today)[:correct_answers].should eq([s2, s1])
    end
  end

  describe '#stats_for_range' do
    context 'when there are no stats' do
      it 'should return empty querysets' do
        res = DailyStatistics.stats_for_range('ru', Date.yesterday, Date.today)
        res[:fastest_answer].should be_empty
        res[:answers_in_a_row].should be_empty
        res[:correct_answers].reorder('').should be_empty
      end
    end

    let(:u1) { create(:user) }
    let(:u2) { create(:user) }
    let(:u3) { create(:user) }
    it 'should return fastest_answer' do
      u1_s1 = create(:daily_statistics, user: u1, fastest_answer: 1.2, stats_date: Date.yesterday)
      u1_s2 = create(:daily_statistics, user: u1, fastest_answer: 0.5, stats_date: Date.tomorrow)
      u1_s3 = create(:daily_statistics, user: u1, fastest_answer: 0.1, stats_date: Date.today)
      u1_s4 = create(:daily_statistics, user: u1, fastest_answer: 0.1, stats_date: Date.today - 7.days)
      u2_s1 = create(:daily_statistics, user: u2, fastest_answer: 2.2, stats_date: Date.today)
      u2_s2 = create(:daily_statistics, user: u2, fastest_answer: 5.2, stats_date: Date.yesterday)
      u3_s1 = create(:daily_statistics, user: u3, fastest_answer: 0.1, stats_date: Date.today - 7.days)
      DailyStatistics.stats_for_range('ru', Date.yesterday, Date.today)[:fastest_answer].should eq([u1_s3, u2_s1])
    end
    it 'should return answers_in_a_row' do
      u1_s1 = create(:daily_statistics, user: u1, answers_in_a_row: 5,   stats_date: Date.yesterday)
      u1_s2 = create(:daily_statistics, user: u1, answers_in_a_row: 25,  stats_date: Date.tomorrow)
      u1_s3 = create(:daily_statistics, user: u1, answers_in_a_row: 10,  stats_date: Date.today)
      u1_s4 = create(:daily_statistics, user: u1, answers_in_a_row: 105, stats_date: Date.today - 7.days)
      u2_s1 = create(:daily_statistics, user: u2, answers_in_a_row: 7,   stats_date: Date.today)
      u2_s2 = create(:daily_statistics, user: u2, answers_in_a_row: 17,  stats_date: Date.yesterday)
      u3_s1 = create(:daily_statistics, user: u3, answers_in_a_row: 200, stats_date: Date.today - 7.days)
      DailyStatistics.stats_for_range('ru', Date.yesterday, Date.today)[:answers_in_a_row].should eq([u2_s2, u1_s3])
    end
    it 'should return correct_answers' do
      u1_s1 = create(:daily_statistics, user: u1, correct_answers: 1, stats_date: Date.yesterday)
      u1_s2 = create(:daily_statistics, user: u1, correct_answers: 7, stats_date: Date.tomorrow)
      u1_s3 = create(:daily_statistics, user: u1, correct_answers: 25, stats_date: Date.today)
      u1_s4 = create(:daily_statistics, user: u1, correct_answers: 12, stats_date: Date.today - 7.days)
      u2_s1 = create(:daily_statistics, user: u2, correct_answers: 17, stats_date: Date.today)
      u2_s2 = create(:daily_statistics, user: u2, correct_answers: 14, stats_date: Date.yesterday)
      u3_s1 = create(:daily_statistics, user: u3, correct_answers: 1, stats_date: Date.today - 7.days)
      correct_answers = DailyStatistics.stats_for_range('ru', Date.yesterday, Date.today)[:correct_answers]
      correct_answers[0].user_id.should eql(u2.id)
      correct_answers[0].correct_answers.should eql(17+14)
      correct_answers[1].user_id.should eql(u1.id)
      correct_answers[1].correct_answers.should eql(1+25)
    end
  end
end
