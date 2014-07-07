module ApplicationHelper
  def root_now?
    /^\/$/.match request.original_fullpath
  end

  def items_now?
    /^\/items$/.match request.original_fullpath
  end

  def users_now?
    /^\/users$/.match request.original_fullpath
  end

  def upload_now?
    /^\/items\/new$/.match request.original_fullpath
  end
end
