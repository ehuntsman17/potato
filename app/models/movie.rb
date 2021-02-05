class Movie < ActiveRecord::Base
  def self.all_ratings()
    return ['G','PG','PG-13','R']
  end
  
  def self.with_ratings(ratings_list)
    if (ratings_list.length == 0)
      return Movie.all
    else
      return Movie.where("rating IN (?)", ratings_list)
    end
  end
  
  def self.sort_on(attr, ratings_list)
    if (ratings_list.length == 0)
      return Movie.all.order("#{attr}")
    else
      return Movie.where("rating IN (?)", ratings_list).order("#{attr}")
    end
  end
  
end
