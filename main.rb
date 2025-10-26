require "socket"
require_relative "config/router"


module Utils
  class HttpUtils
    def self.parse(request)
      method, path, version = request.lines[0].split

      {
        path: path,
        method: method,
        version: version,
        headers: self.parse_headers(request)
      }
    end

    def self.parse_headers(request)
      headers = {}

      request.lines[1..-1].each do |line|
        return headers if line == "\r\n"

        header, value = line.split
        header = self.normalize(header)

        headers[header] = value
      end

      headers
    end

    def self.normalize(header)
      header.gsub(":", "").downcase.to_sym
    end

    def self.controller(data)
      path = data[:path]
      view_file = RouterUtils.resolve(path)
      file_path = view_file ? File.join("tmp/www", view_file) : File.join("tmp/www", path[1..-1])


      unless File.exist?(file_path)
        file_path = File.join("tmp/www", "404.html")
        status_line = "#{data[:version]} 404 Not Found\r\n"
      else
        status_line = "#{data[:version]} 200 OK\r\n"
      end

      content = File.read(file_path)

      content_type = ""
      if file_path.end_with?(".html")
        content_type = "text/html"
      elsif file_path.end_with?(".css")
        content_type = "text/css"
      elsif file_path.end_with?(".js")
        content_type = "application/javascript"
      else
        content_type = "text/plain"
      end

      headers = "Content-Type: #{content_type}\r\n" \
            "Content-Length: #{content.bytesize}\r\n" \
            "Connection: close\r\n\r\n"

      status_line + headers + content
    end
  end
end

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


http = HttpServer.new("localhost", 3000)
socket = http.socket
puts "[INFO]: Server running on http://localhost:3000 (http://127.0.0.1:3000)"

begin
  loop do
    HttpServer.client(socket)
  end
rescue Interrupt
  puts "\n[INFO]: Server stopped"
end
