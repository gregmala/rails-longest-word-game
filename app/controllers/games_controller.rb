require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @included = included?(@word, @letters)
    @valid_word = valid_word?(@word)
    @score = @word.length
    if !@included
      @message = "Sorry but #{@word} can't be built out of #{@letters}"
    elsif !@valid_word
      @message = "Sorry but #{@word} does not seem to be a valid English word..."
    else
      @message = "Congratulations! #{@word} is a valid English word and is worth #{@score} points!"
    end
  end

  private

  def included?(word, letters)
    return false if letters.nil?
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def valid_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
