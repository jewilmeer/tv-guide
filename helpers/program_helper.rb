module ProgramHelper
  def seasons_per_tab_row 
    8
  end

  def available_seasons program
    (1..program.max_season_nr).to_a
  end

  def seasons_for_tab program
    if program.max_season_nr <= seasons_per_tab_row
      available_seasons(program).reverse!
    else
      available_seasons(program).reverse!.take (seasons_per_tab_row) -1
    end
  end

  # return an array of all seasons not able to fit inside the tab
  # these episodes will be displayed within a dropbox
  def seasons_for_dropdown program
    available_seasons(program).reverse!.drop( (seasons_per_tab_row)-1 ).reverse!
  end
end