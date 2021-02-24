class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    
    # if !params[:home].nil?
    #   session[:home] = params[:home]
    #   session[:sort] = params[:sort] if !params[:sort].nil?
    #   session[:ratings] = params[:ratings] if !params[:ratings].nil?
    #   session[:title_sort] = params[:title_sort] if !params[:title_sort].nil?
    #   session[:release_date_sort] = params[:release_date_sort] if !params[:release_date_sort].nil?
    if params[:home].nil? && !session[:home].nil?
      params[:sort] = session[:sort] if !session[:sort].nil?
      params[:ratings] = session[:ratings] if !session[:ratings].nil?
    #  params[:title_sort] = session[:title_sort] if !session[:title_sort].nil?
     # params[:release_date_sort] = session[:release_date_sort] if !session[:release_date_sort].nil?
      #session.clear
      redirect_to ({:sort => params[:sort], :ratings => params[:ratings]}) and return
    end
    
    @ratings_to_show = params[:ratings] || {}
    
    @highlight = ""
    @sort_method = ""
    
    if params[:sort] == "title" || !params[:title_sort].nil?
      @sort_method = "title"
      @highlight_title = "bg-warning"
      @highlight_release_date = ""
    elsif params[:sort] == "release_date" || !params[:release_date_sort].nil?
      @sort_method = "release_date"
      @highlight_title = ""
      @highlight_release_date = "bg-warning"
    end
 
      
      
    #if params[:home].nil?
    #  @highlight_title = "bg-warning"
    #  @highlight_release_date = "bg-warning"
    #end
    session[:sort] = params[:sort] if !params[:sort].nil?
    session[:ratings] = params[:ratings] if !params[:ratings].nil?
    session[:title_sort] = params[:title_sort] if !params[:title_sort].nil?
    session[:release_date_sort] = params[:release_date_sort] if !params[:release_date_sort].nil?

    
    if @ratings_to_show == {}
      return @movies =  Movie.all.order(@sort_method)
    elsif !params[:ratings].nil?
      return @movies = Movie.where(rating: (params[:ratings]).keys).order(@sort_method)
    elsif !session[:ratings].nil?
      return @movies = Movie.where(rating: (session[:ratings]).keys).order(@sort_method)
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
