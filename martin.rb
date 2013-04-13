require 'rubygems'
require 'mechanize'

require 'sinatra'

get '/' do

	status = get_martin_status
	message = '';
	if status[:playing] == true then
		message = 'Yes, of course.'
	else
		message = 'Nope. Last game was ' + status[:last_game] + '.'
	end

	erb :index, :locals => { :message => message }
end

def get_martin_status
	a = Mechanize.new { |agent|
	  agent.user_agent_alias = 'Mac Safari'
	}

	a.get('http://battlelog.battlefield.com/bf3/user/HorridoMartin/') do |page|
		# Current server
	  	current_server = page.search '.profile-view-status-info .common-playing-link a'

	  	if current_server.length > 0 then
	  		return { :playing => true, :current_server => current_server[0][:title] }
	  	else
	  		last_game = page.search '#profile-battlereports .base-ago'

	  		return { :playing => false, :last_game => last_game[0].text }
	  	end
	end
end

__END__

@@ layout
<!DOCTYPE html>
<title>Is Martin playing Battlefield?</title>
<style>

body {
	margin: 10% 0;
}

h1, h2 {
	font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
	text-align: center;

	line-height: 135%;
}

</style>

<body>
	<h1>Is Martin currently playing Battlefield?</h1>
	<%= yield %>
</body>

@@ index

<h2><%= message %></h2>