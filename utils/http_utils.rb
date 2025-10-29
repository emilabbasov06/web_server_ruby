require "uri"


module Utils
  class HttpUtils
    def self.parse(request)
      method, path, version = request.lines[0].split

      _, body = request.split("\r\n\r\n", 2)

      params = {}
      if method == "POST" && body && !body.strip.empty?
        params = URI.decode_www_form(body).to_h
      end

      {
        path: path,
        method: method,
        version: version,
        headers: self.parse_headers(request),
        params: params
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

    def self.extract_id_from_path(path)
      last_segment = path.split("/").last
      return nil unless last_segment =~ /^\d+$/
      last_segment.to_i
    end

    def self.normalize(header)
      header.gsub(":", "").downcase.to_sym
    end

    def self.render_erb(file_name, data)
      @data = data
      erb_path = File.expand_path("../tmp/www/#{file_name}", __dir__)
      template = ERB.new(File.read(erb_path))
      html = template.result(binding)

      "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n#{html}"
    end

  end
end