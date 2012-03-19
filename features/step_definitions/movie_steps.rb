# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert false, "Unimplmemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

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
  method = (all != "no") ? :has_content? : :has_no_content?
  Movie.all.each do |movie|
    if all != "no"
      assert (page.has_content?(movie.title)), "Failed to find movie " + movie.title
    else
      assert (page.has_no_content?(movie.title)), "Movie "+movie.title+" found"
    end
  end
end



