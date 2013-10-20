module Rating
  # default values:
  # ELO_K = 32
  # ELO_FACTOR = 400
  ELO_K = 8.0  # The grater - the more points user will receive/loose per game
  ELO_FACTOR = 400.0  # The greater - the less rating will loose/change will depend on ratings delta

  def self.elo_change(winner_rating, looser_rating)
    diff = winner_rating - looser_rating
    percent = 1.0 / (1.0 + 10.0 ** (diff / ELO_FACTOR))
    ELO_K * percent
  end

  def self.update_ratings(players, winner)
    deltas = [0]
    losers_count = (players.count - 1) || 1
    for player in players do
      next if player.id == winner.id
      delta = elo_change(winner.rating, player.rating) / losers_count
      player.rating -= delta
      deltas.push(delta)
      player.save!
    end

    winner.rating += deltas.reduce(:+)
    winner.save!
  end
end
