class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    # creating grid
    grid = []
    10.times { grid << ("A".."Z").to_a.sample(1)[0] }
    @grid = grid
    @grid_joined = @grid.join("")
    @start_time = Time.now
  end

  def score
    @start_time = Time.new(params[:start_time])
    @end_time = Time.now
    @grid = params[:grid].split("")
    result = {}
    word = params[:attempt].upcase.split("")
    url = "https://wagon-dictionary.herokuapp.com/#{params[:attempt]}"
    word_dicc = open(url).read
    word_dicc_h = JSON.parse(word_dicc)
    result[:time] = @end_time - @start_time
    result[:score] = score_calculator(word, result[:time])
    checking(result, @grid, word_dicc_h, word)
    @result = result
  end

  def checking(hash, grid, word_modified, attempt_modified)
    if !word_modified["found"]
      hash[:score] = 0
      hash[:message] = "I am sorry but your word is not an english word"
    elsif (grid & attempt_modified).sort != attempt_modified.sort
      hash[:score] = 0
      hash[:message] = "It's not in the grid"
    else
      hash[:message] = "Well done!"
    end
  end

  def score_calculator(attempt, time)
    partial_score = attempt.length
    score_modifier = 1.0 / time
    (partial_score - 1) + score_modifier
  end
end