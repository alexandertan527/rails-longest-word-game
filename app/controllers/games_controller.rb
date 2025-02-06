require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

    @letters = []

    10.times do |n|
      @letters << alphabet[rand(0..25)]
    end
    @start_time = Time.now
  end

  def score

    @end_time = Time.now

    @time = @end_time - Time.parse(params[:start])

    response = URI.parse("https://dictionary.lewagon.com/#{params[:word]}")
    json = JSON.parse(response.read)
    real_word = json['found']

    letters_array = params[:letters].downcase.gsub(" ", "").chars

    def included?(attempt, grid)
      attempt.downcase.chars.all? { |letter| attempt.count(letter) <= grid.count(letter) }
    end

    def compute_score(attempt, time_taken)
      time_taken > 60.0 ? 0 : (attempt.size * (1.0 - (time_taken / 60.0)))
    end

    @result = if real_word
                if included?(params[:word], letters_array)
                  "Congratulations! #{params[:word].upcase} is a valid English Word. Your score is #{compute_score(params[:word], @time)}."
                else
                  "Sorry but #{params[:word]} can't be built out of #{params[:letters]}. Your score is 0."

                end
              else
                "Sorry but #{params[:word]} does not seem to be a valid English word... Your score is 0."
              end
  end
end
