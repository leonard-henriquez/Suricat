class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :criteria
  has_many :events, dependent: :destroy
  has_many :user_opportunities
  has_many :opportunities, through: :user_opportunities
end
