require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def create_session
    if session[:current_score].nil?
      session[:current_score] = 0
    else
      session[:current_score]
    end
  end

  def update_session(score)
    session[:current_score] += score
    return session[:current_score]
  end

  def new
    create_session
    @letters = []
    10.times do
      @letters <<('A'..'Z').to_a.sample
    end
  end

  def score

    answer_array = params[:answer].downcase.split("")
    letters_array = params[:letters].downcase.split(',')
    hash_1 = {}
    hash_2 = {}
    answer_array.each do |letter|
      if hash_1.keys.include? letter
        hash_1[letter] += 1
      else
        hash_1[letter] = 1
      end
    end

    letters_array.each do |letter|
      if hash_2.keys.include? letter
        hash_2[letter] += 1
      else
        hash_2[letter] = 1
      end
    end

    if comparing_hashes(hash_1, hash_2) != false
      if actual_word(params[:answer])
        i = params[:answer].split("").length
        score = update_session(i)
        @result = "Congrats! #{params[:answer].upcase} is valid English word and your score is #{score}"
        return @result
      else
        score = update_session(0)
        @result = "Sorry but #{params[:answer].upcase} is not an English word and your score is #{score}"
        return @result
      end
    else
      score = update_session(0)
      @result = "Sorry but #{params[:answer].upcase} can not be built with #{params[:letters].upcase}  and your score is #{score}"
    end
  end

  def comparing_hashes(hash_1, hash_2)
    hash_1.each do |key, value|
      if hash_2[key].nil?
        return false
      elsif value > hash_2[key]
        return false
      end
    end
  end

  def actual_word(word)
    api_response = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{word}").read)
    api_response["found"]
  end

end
