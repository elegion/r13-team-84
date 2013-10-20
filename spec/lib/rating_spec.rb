require 'spec_helper'
require 'rating'

describe 'Rating' do
  describe "#elo_change" do
    it 'should return positive value' do
      Rating::elo_change(10, 100).should be > 0
      Rating::elo_change(100, 10).should be > 0
      Rating::elo_change(10, 10).should be > 0
    end

    it 'should be greater, the greater rating diff is' do
      Rating::elo_change(100, 1000).should be > Rating::elo_change(100, 200)
    end
  end

  describe '#update_ratings' do
    let(:winner) { create(:user, rating: 100) }
    let(:loser1) { create(:user, rating: 100) }
    let(:loser2) { create(:user, rating: 100) }
    let(:winner_rating_delta) { winner.rating - 100}
    let(:loser1_rating_delta) { loser1.rating - 100}
    let(:loser2_rating_delta) { loser2.rating - 200}

    it 'should decrease losers ratings' do
      Rating::update_ratings([winner, loser1, loser2], winner)
      loser1_rating_delta.should be < 0
      loser2_rating_delta.should be < 0
    end

    it 'should loose more rating, the more rating delta is' do
      Rating::update_ratings([winner, loser1, loser2], winner)
      (-loser1_rating_delta).should be < (-loser2_rating_delta)
    end

    it 'should increase winner rating' do
      Rating::update_ratings([winner, loser1, loser2], winner)
      winner_rating_delta.should be > 0
    end

    it 'should gain/loose less rating the more player there are' do
      game1_winner = create(:user, rating: 100)
      game1_loser1 = create(:user, rating: 100)

      game2_winner = create(:user, rating: 100)
      game2_loser1 = create(:user, rating: 100)
      game2_loser2 = create(:user, rating: 100)

      Rating::update_ratings([game1_winner, game1_loser1], game1_winner)
      Rating::update_ratings([game2_winner, game2_loser1, game2_loser2], game2_winner)

      game1_winner.rating.should be == game2_winner.rating
      game1_loser1.rating.should be < game2_loser1.rating
    end
  end
end
