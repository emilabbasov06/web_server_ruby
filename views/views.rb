require "erb"
require "json"
require_relative "../database/database"


def get_blogs
  path = File.expand_path("../database/server.db", __dir__)
  server_db = Database.new(path)
  server_db.select_all("blogs")
end