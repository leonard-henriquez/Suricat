class PagesController < ApplicationController
  layout 'homepage'
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def styleguide
  end
end
