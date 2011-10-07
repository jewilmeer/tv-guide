class AdminAreaController < ApplicationController
  before_filter :require_admin
  layout 'layouts/admin/application'
end