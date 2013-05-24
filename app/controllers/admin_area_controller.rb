class AdminAreaController < ApplicationController
  before_filter :require_admin
  layout 'layouts/admin/application'

  def program_nav_links
    {
      :previous => Program.where('status = ?', @program.status).order(:name).
                    where('name > ?', @program.name).first,
      :next     => Program.where('status = ?', @program.status).order(:name).
                    where('name < ?', @program.name).last
    }
  end
end