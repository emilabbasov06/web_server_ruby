require "socket"
require_relative "config/router"
require_relative "utils/http_utils"


class HttpServer

  class << self
    def client(socket)
      client = socket.accept
      request = client.readpartial(2048)
      response = Utils::HttpUtils.controller(Utils::HttpUtils.parse(request))
      

      client.write(response)
      client.close
    end
  end

  attr_reader :address, :port

  def initialize(address, port)
    @address = address
    @port = port
  end

  def socket
    begin
      TCPServer.new(@address, @port)
    rescue Errno::ECONNREFUSED => e
      puts "[ERROR]: #{e.message}"
    end
  end

end

# Adding some routes
Utils::RouterUtils.create_route("/", "index.html")
Utils::RouterUtils.create_route("/blogs", "blogs.html")
Utils::RouterUtils.create_route("/new", "new_blog.html")


http = HttpServer.new("localhost", 3000)
socket = http.socket
puts "[INFO]: Server running on http://localhost:3000 (http://127.0.0.1:3000)"

begin
  loop do
    HttpServer.client(socket)
  rescue => e
    puts "[ERROR]: #{e.class} - #{e.message}"
  end
rescue Interrupt
  puts "\n[INFO]: Server stopped"
  socket.close if socket
  exit
end