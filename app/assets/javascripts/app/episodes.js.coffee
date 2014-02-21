$('#season-tabs').each ->
  $this = $(this);
  if $this.data('episodeNr')?
    $this.find(".s#{$this.data('episodeSeasonNr')} a").tab('show');
    $("#episode_#{$this.data('episodeId')}").addClass('active');
  else
    $this.find('#program-season-tabs a:first').tab('show');

