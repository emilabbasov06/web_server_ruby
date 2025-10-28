require "erb"
require "json"
require_relative "../database/database"


$path = File.expand_path("../database/server.db", __dir__)

def get_blogs
  server_db = Database.new($path)
  server_db.select_all("blogs")
end

def get_blog(id)
  server_db = Database.new($path)
  server_db.select_row_with_id("blogs", id)
end

def new_blog(params)
  server_db = Database.new($path)
  server_db.insert("blogs", {title: params["title"], content: params["content"]})
  puts "[INFO]: New blog added to database"
end

def delete_blog(id)
  server_db = Database.new($path)
  server_db.drop_row_with_id("blogs", id)
  puts "[INFO]: Blog has been removed from database"
end