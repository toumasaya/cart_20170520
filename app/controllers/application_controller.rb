class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_flash_types :success
  add_flash_types :warning
  add_flash_types :danger
  add_flash_types :info
end
