$ ->
	$('.date[data-timestamp').each ->
		$this = $ this
		$this.text (moment $this.data 'timestamp').fromNow()