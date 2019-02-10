# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home; end

  def extension; end

  def styleguide; end
end
