require 'net/http'
require 'open-uri'
require 'json'

class MoviesController < ApplicationController
  before_action :set_movie, only: [:show]


  def index
    @movies = Movie.all
  end

  def show
    create_similars(@movie)
    create_recommendations(@movie)
    @review = Review.new
    @reviewable = @movie
    @list_item = ListItem.new
    @listable = @movie
    @lists = List.where(["user_id = :user_id", { user_id: current_user.id }])
    @providers = @movie.providers
    @media_providers = @movie.media_providers
    @free_providers = @providers.where(service: "free").uniq
    @sub_providers = @providers.where(service: "sub").uniq
    @purchase_providers = @providers.where(service: "purchase").uniq
    @tve_providers = @providers.where(service: "tve").uniq
    #raise
  end

  def toggle_favorite
    @movie = Movie.find(params[:id])
    current_user.favorited?(@movie) ? current_user.unfavorite(@movie) : current_user.favorite(@movie)
  end

  private

  def set_movie
    @movie = Movie.includes(:media_providers).find(params[:id])
  end

  def create_similars(movie)
    @similars = movie.similar_titles_watchmode.map { |similar|
      Movie.find_by(watchmode_id: similar.to_i)
    }
    @similars.compact!
  end

  def create_recommendations(movie)
    @recommendations = movie.recommendations_tmdb.map { |reco|
      Movie.find_by(tmdb_id: reco.to_i)
    }
    @recommendations.compact!
  end
end
