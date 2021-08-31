class MoviesController < ApplicationController

  def index

    if params[:ratings]
      session[:ratings] = params[:ratings]
    end

    if session[:ratings]
      active_ratings = session[:ratings].keys
    else
      active_ratings = Movie.all_ratings
    end

    @all_ratings = Movie.all_ratings

    @active_ratings = active_ratings
    if params[:sort_by]
      session[:sort_by] = params[:sort_by]
    end
    if session[:sort_by]
      @movies = Movie.where(rating: active_ratings).order(session[:sort_by])
    else
      @movies = Movie.where(rating: active_ratings)
    end
    @hilite = 'hilite'
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
    #default: render 'new' template
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    else
      render 'new'
    end
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    if @movie.update(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movies_path(@movie)
    else
      render 'edit'
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def movie_params
    params.require(:movie).permit(:title,:rating, :release_date)
  end
end