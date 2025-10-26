class Router
  attr_reader :path, :view

  def initialize(path, view)
    @path = path
    @view = view
    
    {
      path: @path,
      view: @view
    }
  end
end

module Utils
  class RouterUtils
    @@routes = []

    def self.create_route(path, view)
      @@routes.push(Router.new(path, view))
    end

    def self.resolve(path)
      route = @@routes.find { |r| r.path == path }
      route ? route.view : nil
    end
  end
end