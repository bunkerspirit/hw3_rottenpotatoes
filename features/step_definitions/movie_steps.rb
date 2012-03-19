# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  e1_location = page.body.index(e1)
  e2_location = page.body.index(e2)
  assert !e1_location.nil?
  assert !e2_location.nil?
  assert e1_location < e2_location
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.gsub(' ','').split(',').each do |r|
    self.send ((uncheck)?"uncheck":"check").to_sym, "ratings[#{r}]"
  end
end

Then /I should (not )?see following movies: (.*)/ do |notsee, movie_titles|
  method = (notsee) ? :has_no_content? : :has_content?
  movie_titles.split(',').each do |movie_title|
    if page.respond_to? :should
      page.should page.send method, movie_title
    else
      assert (page.send method, movie_title), "Check \""+notsee.to_s+"\" failed for "+movie_title
    end
  end
end

Then /I should see (all of the|no) ?movies/ do |all|
  Movie.all.each do |movie|
    if all != "no"
      assert (page.has_content?(movie.title)), "Failed to find movie " + movie.title
    else
      assert (page.has_no_content?(movie.title)), "Movie "+movie.title+" found"
    end
  end
end



