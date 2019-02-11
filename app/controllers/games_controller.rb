require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    i = 0
    until i == 10
      @grid << ("A".."Z").to_a.sample
      i += 1
    end
    @grid
  end


  def word_comparison
    @word = params[:word]
    @grid = params[:grid]
    @letters = @grid.split(' ').sort
    @user_word = @word.upcase.split('').sort
    count = 0
    @user_word.each do |letter|
      if @letters.include?(letter)
        count += 1
        @letters.delete_at(@letters.index(letter))
      end
    end
    count == @word.length
  end

  def score
    @word = params[:word]
    @grid = params[:grid]

    if !word_comparison
      @result = "not in the grid !"
    elsif word_comparison && english_word(@word)
      @result = "Good job !"
    else
      @result = "not an english name !"
    end
end

  def english_word(attempt)
    response = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
    response["found"]
  end

end

