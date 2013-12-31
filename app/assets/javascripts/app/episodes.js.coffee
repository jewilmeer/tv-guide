$('#season-tabs').each ->
  if this.dataset.episodeNr?
    $(this).find(".s#{this.dataset.episodeSeasonNr} a").tab('show');
    $("#episode_#{this.dataset.episodeId}").addClass('active');
  else
    $(this).find('#program-season-tabs a:first').tab('show');

