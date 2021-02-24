class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # Define initial values to show on page
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    
    # Load session values only when the user returns from visiting a movie page. If the
    # user arrives through a fresh page, the session is cleared. Note that all the web site
    # for this app matches the regex, meaning that the params will load session until
    # a fresh page is created.
    if request.referrer =~ /^https:\/\/safe-depths-17369.herokuapp.com\/movies\/.*/
      params[:sort] = session[:sort] if !session[:sort].nil?
      params[:ratings] = session[:ratings] if !session[:ratings].nil?
    elsif request.referrer =~ /^https:\/\/safe-depths-17369.herokuapp.com\/movies$/
      params[:sort] = session[:sort] if !session[:sort].nil?
      params[:ratings] = session[:ratings] if !session[:ratings].nil?
    else
      session.clear
    end
      
    @ratings_to_show = params[:ratings] || {}
    @sort_method = params[:sort] || ""
    
    # Selects which Table Header will be highlighted.
    if @sort_method == "title"
      @highlight_title = "bg-warning"
      @highlight_release_date = ""
    elsif @sort_method == "release_date"
      @highlight_title = ""
      @highlight_release_date = "bg-warning"
    end

    # Save the latest sorting and rating selection to be loaded when returning from a movie page.
    session[:sort] = @sort_method if !params[:sort].nil?
    session[:ratings] = @ratings_to_show if !params[:ratings].nil?
    
    # Prepares the list of movies to show. Method '.key' returns the keys from the 
    # hashtable, '.where' looks into the Data Base for elements matching the 
    # parameters, '.order' selects the parameter to apply the sorting ("title" or 
    # "release_date" in this case)
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
