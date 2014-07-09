class AdminController < AuthenticatedController

  def cache_content
    @cache_content = Point.cache_content
  end

end