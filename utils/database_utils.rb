module Utils
  class DatabaseUtils
    def self.run(db, query)
      data = db.execute(query)
      db.close

      # Returns fetched data
      data
    end
  end
end