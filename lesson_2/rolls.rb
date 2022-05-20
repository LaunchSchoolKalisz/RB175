require "socket" # Gives accesss to a library to help create/interact with servers

server = TCPServer.new("localhost", 3003) #Create TCP server (layer under HTTP) on localhost
loop do 
  client = server.accept # Waits until someone tries to request something from the server. Once there is a request, it accepts and opens a connection to the client (returns and stored as the client object) 

  request_line = client.gets # Gets the FIRST line of the request (the method, GET or POST)
  next if !request_line || request_line =~ /favicon/ 
  puts request_line # Print that line to the console

  client.puts "HTTP/1.1 200 OK" #add a valid status line to your response first, before adding the content of the message body for browsers like Chrome which expects a well-formed response to be sent to it for rendering
  client.puts "Content-Type: text/plain\r\n\r\n" # add in a response header value
  
  # http_method == "GET"
  # path == "/"
  # params = { "rolls" => "2", "sides" => "6"}

  http_method, path_and_params, http = request_line.split(" ")
  path, params = path_and_params.split("?")
  params = params.split("&") #Should be an array, containing 'rolls=2', 'sides=6'
  
  params = params.each_with_object({}) do |pair, hash|
    key, value = pair.split("=")
    hash[key] = value
  end

  client.puts request_line # Send back to the client so it appears in the web browser
  client.puts http_method
  client.puts path
  client.puts params

  rolls = params["rolls"].to_i
  sides = params["sides"].to_i

  rolls.times do |_|
    client.puts rand(sides) + 1
  end

  client.close
end