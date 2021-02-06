class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if (params.keys.length == 2) # must use sessions data
      @using_session = true
      if (session[:ratings] == nil)
        @ratings_to_show = []
      else
        @ratings_to_show = session[:ratings].keys
      end
      if (session[:sort_by] != nil)
        if (session[:sort_by] == 'title')
          @movies = Movie.sort_on('title',@ratings_to_show)
        else
          @movies = Movie.sort_on('release_date',@ratings_to_show)
        end
      else
        @movies = Movie.with_ratings(@ratings_to_show)
      end
    else # params are not empty
      @using_session = false
      session.clear
      if (params[:ratings] == nil)
        @ratings_to_show = []
      else
        @ratings_to_show = params[:ratings].keys
      end
      if (params[:sort_by] != nil)
        if (params[:sort_by] == 'title')
          @movies = Movie.sort_on('title',@ratings_to_show)
        else
          @movies = Movie.sort_on('release_date',@ratings_to_show)
        end
      else
        @movies = Movie.with_ratings(@ratings_to_show)
      end
      if (params['sort_by'] != nil)
        session['sort_by'] = params['sort_by']
      end
      if (params['ratings'] != nil)
        session['ratings'] = params['ratings']
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
