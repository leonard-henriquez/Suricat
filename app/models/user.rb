# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :importances, dependent: :destroy
  has_many :criteria, through: :importances
  has_many :events, dependent: :destroy
  has_many :user_opportunities, dependent: :destroy
  has_many :opportunities, through: :user_opportunities

  after_create :create_importances

  def create_importances
    importance_names = Importance.names.keys.map(&:to_sym)
    # returns [:contract_type, :structure, :industry, :job, :location, :salary]
    importance_names.each do |importance_name|
      Importance.create(user: self, name: importance_name, value: nil)
    end
  end
end
