# In this file we will connect to database (SQLite3) and add some blog posts
# After that we will send those post to (/blogs) to render them on HTML file


require "sqlite3"

class Database
  attr_reader :db_name

  def initialize(db_name)
    @db_name = db_name
  end

  def create_table(query)
    db = get_db
    db.execute(query)
    db.close
  end

  private
  
  def get_db
    begin
      db = SQLite3::Database.open(@db_name)
      return db
    rescue SQLite3::Exception => e
      puts "[ERROR]: #{e.message}"
    end
  end
end

new_db = Database.new("./server.db")
new_db.create_table("CREATE TABLE IF NOT EXISTS Cars(Id INTEGER PRIMARY KEY, 
        Name TEXT, Price INT)")