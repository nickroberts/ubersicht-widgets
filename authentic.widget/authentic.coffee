# Authentic Weather for Übersicht
# reduxd, 2015

# ------------------------------ CONFIG ------------------------------

# locale
locale: 'en-US'

# forecast.io api key
apiKey: '14666b202d721c2dfbaa8aa4854ba3fb'

# degree units; 'c' for celsius, 'f' for fahrenheit
unit: 'f'

# icon set; 'black', 'white', and 'blue' supported
icon: 'white'

# weather icon above text; true or false
showIcon: true

# temperature above text; true or false
showTemp: true

# show forecast
showForecast: true

# refresh every '(60 * 1000)  * x' minutes
refreshFrequency: (60 * 1000) * 10

# ---------------------------- END CONFIG ----------------------------

exclude: "minutely,hourly,alerts,flags"

command: "echo {}"

makeCommand: (apiKey, location) ->
  "curl -sS 'https://api.forecast.io/forecast/#{apiKey}/#{location}?units=si&exclude=#{@exclude}'"

render: (o) -> """
	<article id="content">

		<!-- snippet -->
		<div id="snippet">
		</div>

		<!--phrase text box -->
		<h1>
		</h1>

		<!-- subline text box -->
		<h2>
		</h2>

		<!-- forecast -->
		<div id="forecast">
		</div>
	</article>
"""

afterRender: (domEl) ->
  geolocation.getCurrentPosition (e) =>
    coords     = e.position.coords
    [lat, lon] = [coords.latitude, coords.longitude]
    @command   = @makeCommand(@apiKey, "#{lat},#{lon}")

    @refresh()

update: (o, dom) ->
	# parse command json
	data = JSON.parse(o)

	console.log(data)

	return unless data.currently?
	# get current temp from json
	t = data.currently.temperature

	# process condition data (1/2)
	s1 = data.currently.icon
	s1 = s1.replace(/-/g, "_")

	# snippet control

	snippetContent = []

	# icon dump from android app
	if @showIcon
		snippetContent.push "<img src='authentic.widget/icon/#{ @icon }/#{ s1 }.png'></img>"

	if @showTemp
		if @unit == 'f'
			snippetContent.push "#{ Math.round(t * 9 / 5 + 32) }&deg; F"
		else
			snippetContent.push "#{ Math.round(t) }&deg; C"

	$(dom).find('#snippet').html snippetContent.join ''

	if @showForecast and data.daily and data.daily.data and data.daily.data.length
		forecastData = $('<div class="forecast-data" />')
		forecastContent = []
		for i in [0...5]
			forecastContent.push @getDay data.daily.data[i]
		forecastData.html forecastContent.join ''
		$(dom).find('#forecast').html forecastData

	# process condition data (2/2)
	s1 = s1.replace(/(day)/g, "")
	s1 = s1.replace(/(night)/g, "")
	s1 = s1.replace(/_/g, " ")
	s1 = s1.trim()

	# get relevant phrase
	@parseStatus(s1, t, dom)

getDay: (day) ->
	d = new Date
	d.setTime(day.time * 1000)
	dayName = d.toLocaleDateString(@locale, { weekday: 'long' })
	s1 = day.icon
	s1 = s1.replace(/-/g, "_")
	if @unit == 'f'
		temperatureHigh = "#{ Math.round(day.temperatureHigh * 9 / 5 + 32) }&deg; F"
		temperatureLow = "#{ Math.round(day.temperatureLow * 9 / 5 + 32) }&deg; F"
	else
		temperatureHigh = "#{ Math.round(day.temperatureHigh) }&deg; C"
		temperatureLow = "#{ Math.round(day.temperatureLow) }&deg; C"
	return """
		<div class='day'>
			<div>#{ dayName }</div>
			<div class='icon'>
				<img src='authentic.widget/icon/#{ @icon }/#{ s1 }.png'></img>
			</div>
			<div>
				<span class='high'>#{ temperatureHigh }</span> / <span class='low'>#{ temperatureLow }</span>
			</div>
		</div>
	"""

# phrases dump from android app
parseStatus: (summary, temperature, dom) ->
	c = []
	s = []
	$.getJSON 'authentic.widget/phrases.json', (data) ->
		$.each data.phrases, (key, val) ->
			# condition based
			if val.condition == summary
				if val.min < temperature
					if val.max > temperature
						c.push val
						s.push key

					if typeof val.max == 'undefined'
						c.push val
						s.push key

				if typeof val.min == 'undefined'
					if val.max > temperature
						c.push val
						s.push key

					if typeof val.max == 'undefined'
						c.push val
						s.push key

			# temp based
			if typeof val.condition == 'undefined'
				if val.min < temperature
					if val.max > temperature
						c.push val
						s.push key

					if typeof val.max == 'undefined'
						c.push val
						s.push key

				if typeof val.min == 'undefined'
					if val.max > temperature
						c.push val
						s.push key

					if typeof val.max == 'undefined'
						c.push val
						s.push key

		r = c[Math.floor(Math.random()*c.length)]

		title = r.title
		highlight = r.highlight[0]
		color = r.color
		sub = r.subline
		nextTest = s[Math.floor(Math.random()*c.length)]

		text = title.replace(/\|/g, " ")

		c1 = new RegExp(highlight, "g")
		c2 = "<i style=\"color:" + color + "\">" + highlight + "</i>"

		text2 = text.replace(c1, c2)
		text3 = text2.replace(/>\?/g, ">")

		$(dom).find('h1').html text3
		$(dom).find('h2').html sub

# adapted from authenticweather.com
style: """
	width 448px
	right 10px
	top 80px
	font-family 'HelveticaNeue-Light', 'Helvetica Neue Light', 'Helvetica Neue', Helvetica, 'Open Sans', sans-serif
	font-smooth always
	color #ffffff

	#content
		background: rgba(0, 0, 0, 0.5)
		padding: 10px
		border-radius: 5px

	#snippet
		font-size 2em
		font-weight 500

		img
			max-width 100px
			margin-right 20px

	h1
		font-size 3.3em
		font-weight 600
		line-height 1em
		letter-spacing -0.04em
		margin 0 0 0 0

	h2
		font-weight 500
		font-size 1em
		margin-bottom: 0

	i
		font-style normal

	#forecast
		.forecast-data
			margin-top: 20px
			display: flex
			flex-flow: row nowrap
			justify-content: space-around
			align-items: center

			.day
				display: flex
				flex: 1
				flex-flow: column nowrap
				justify-content: flex-start
				align-items: center
				font-size: 12px
				.icon
					display: flex
					flex: 1
					justify-content: center
					align-items: center
					margin: 5px 0
					height: 48px
					width: 48px
					img
						max-height: 100%
						max-width: 100%
				.low
				  color: #ccc
"""
