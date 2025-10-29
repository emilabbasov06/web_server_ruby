require_relative "../views/views"
require_relative "http_utils"


module Utils
  class ControllerUtils
    def self.controller(data)
      path = data[:path]
      params = data[:params]

      if path == "/" && data[:method] == "POST"
        if params["_method"] == "DELETE"
          delete_blog(params["id"])
        else
          new_blog(params)
        end
      end

      if path == "/blogs"
        return Utils::HttpUtils.render_erb("blogs.html.erb", get_blogs)
      end

      if path =~ %r{^/blogs/(\d+)$}
        id = Utils::HttpUtils.extract_id_from_path(path)
        if !id.nil?
          blog = get_blog(id)
          return Utils::HttpUtils.render_erb("single_blog.html.erb", blog)
        end
      end


      view_file = Utils::RouterUtils.resolve(path)
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
  end
end