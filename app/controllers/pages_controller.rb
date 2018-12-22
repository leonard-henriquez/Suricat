# frozen_string_literal: true

class PagesController < ApplicationController
  layout "no_sidebar"

  skip_before_action :authenticate_user!, only: [:home]

  def home; end

  def extension; end

  def styleguide; end
end
