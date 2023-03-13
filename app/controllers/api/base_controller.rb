class Api::BaseController < ApplicationController
  before_action :authorize_access_request!

  def per_page
    params[:per_page] || 10
  end

  def page
    params[:page] || 1
  end

  def meta_attributes(record)
    { 
      per_page: per_page,
      total_pages: record.total_pages,
      total_objects: record.total_entries
    }
  end
end
