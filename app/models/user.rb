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
end
