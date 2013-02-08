class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.all_ratings
    
    if params[:order].nil?
      # use session info 
      @order = session[:order] # may be nil
    else
      @order = params[:order]
      session[:order] = @order
    end 
    
    if params[:ratings].nil? && session[:ratings].nil?  
        # neither params nor session have info about selected ratings
        @checked_ratings = @all_ratings # defaults to all ratings

    elsif session[:ratings].nil? || ( !params[:ratings].nil? && !session[:ratings].nil? )
      # only the session has info about seleted ratings
      # or newer params info overrides old session info
      # use the info from params to create next view
      @checked_ratings = params[:ratings].keys  if params[:ratings].is_a? Hash
      @checked_ratings = params[:ratings]       if params[:ratings].is_a? Array
      # save the new info from params in session
      session[:ratings] = @checked_ratings
      #session[:order]   = @order
    
    elsif params[:ratings].nil?
      # only sesion has info
      @checked_ratings = session[:ratings]
      #@order   = session[:order]
    end
                      

    @movies = Movie.where(:rating => @checked_ratings).order(@order) #Movie.order(@order)

    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
