require "sqlite3"
require "json"
require_relative "../utils/normal_text"
require_relative "../utils/database_utils"


class Database
  attr_reader :db_name

  def initialize(db_name)
    @db_name = db_name
  end

  def select_all(table_name)
    db = get_db
    db.results_as_hash = true
    rows = Utils::DatabaseUtils.run(db, "SELECT * FROM #{table_name};")
    
    JSON.parse(JSON.pretty_generate(rows))
  end

  def select_row_with_id(table_name, id)
    db = get_db
    db.results_as_hash = true
    row = Utils::DatabaseUtils.run(db, "SELECT * FROM #{table_name} WHERE id = #{id};")

    JSON.parse(JSON.pretty_generate(row)).first
  end

  def create_table(table_name, table_schema)
    query = "CREATE TABLE IF NOT EXISTS #{table_name}("
    table_schema.each do |column_name, column_type|
      query += "#{column_name} #{column_type[:type]} #{column_type[:primary_key] == true ? "PRIMARY KEY" : ""}, "
    end
    query += ");"
    query = Utils::NormalText.remove_last(query, ", ", "")

    db = get_db()
    Utils::DatabaseUtils.run(db, query)
  end

  def drop_table(table_name)
    db = get_db()
    Utils::DatabaseUtils.run(db, "DROP TABLE #{table_name;}")
  end

  def insert(table_name, values)
    query = "INSERT INTO #{table_name}("
    values.each do |column, value|
      query += "#{column}, "
    end
    query += ") VALUES("
    query = Utils::NormalText.remove_last(query, ", ", "")

    values.each do |column, value|
      query += "\"#{value}\", "
    end
    query += ");"
    query = Utils::NormalText.remove_last(query, ", ", "")

    db = get_db
    Utils::DatabaseUtils.run(db, query)
  end

  def drop_row_with_id(table_name, id)
    db = get_db
    Utils::DatabaseUtils.run(db, "DELETE FROM #{table_name} WHERE id = #{id};")
  end

  private
  
  def get_db
    begin
      db_path = File.expand_path(@db_name, __dir__)
      db = SQLite3::Database.open(db_path)
      return db
    rescue SQLite3::Exception => e
      puts "[ERROR]: #{e.message}"
    end
  end
end