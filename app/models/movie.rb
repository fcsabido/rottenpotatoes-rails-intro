class Movie < ActiveRecord::Base
    
  def self.all_ratings
    return ['G','PG','PG-13','R']
  end
  
  def self.with_ratings(ratings_list)

  # if ratings_list is nil, retrieve ALL movies
  if ratings_list.nil?
    return @movies =  Movie.all
  # if ratings_list is a hasg, retrieve all movies using 
  # its keys
  else
    return @movies = Movie.where(rating: rating_list.keys)
  end
    
  
  end

end
