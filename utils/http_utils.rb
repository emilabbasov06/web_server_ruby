require_relative "../views/views"


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

      if path == "/blogs"
        return render_erb("blogs.html.erb", get_blogs)
      end

      view_file = RouterUtils.resolve(path)
      file_path = view_file ? File.join("tmp/www", view_file) : File.join("tmp/www", path[1..-1])

      unless File.exist?(file_path)
        file_path = File.join("tmp/www", "404.html")
        status_line = "#{data[:version]} 404 Not Found\r\n"
      else
        status_line = "#{data[:version]} 200 OK\r\n"
      end

      content = File.read(file_path)

      content_type =
        if file_path.end_with?(".html")
          "text/html"
        elsif file_path.end_with?(".css")
          "text/css"
        elsif file_path.end_with?(".js")
          "application/javascript"
        else
          "text/plain"
        end

      headers = "Content-Type: #{content_type}\r\n" \
                "Content-Length: #{content.bytesize}\r\n" \
                "Connection: close\r\n\r\n"

      status_line + headers + content
    end


    def self.render_erb(file_name, blogs)
      @blogs = blogs.map { |row| row.transform_keys(&:to_sym) }

      erb_path = File.expand_path("../tmp/www/#{file_name}", __dir__)
      template = ERB.new(File.read(erb_path))
      html = template.result(binding)

      "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n#{html}"
    end


    def self.serve_static(file_name)
      content = File.read("tmp/www/#{file_name}")
      "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n#{content}"
    end

    def self.not_found
      "HTTP/1.1 404 Not Found\r\nContent-Type: text/html\r\n\r\n<h1>404 - Not Found</h1>"
    end
  end
end