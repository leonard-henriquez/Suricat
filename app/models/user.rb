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

  # turn the field authentication_token into a working authentication token
  acts_as_token_authenticatable

  def first_name=(value)
    write_attribute(:first_name, value.split.map(&:capitalize).join(' '))
  end

  def last_name=(value)
    write_attribute(:last_name, value.split.map(&:capitalize).join(' '))
  end

  after_create :create_importances

  def create_importances
    importance_names = Importance.names.keys.map(&:to_sym)
    # returns [:contract_type, :company_structure, :sector_name, :job_name, :location, :salary]
    importance_names.each do |importance_name|
      Importance.create(user: self, name: importance_name, value: 50)
    end
  end

  def importances_value
    importances_value = {}
    importances.each { |i| importances_value[i.name.to_sym] = i.value || 0 }
    importances_value
  end

  def criteria
    criteria_list = {}
    importances.each do |i|
      name = i.name.to_sym
      value = i.criteria.map(&:value.to_proc)
      criteria_list[name] = value
    end

    criteria_list
  rescue StandardError => e
    puts "%%%%%% Criteria failed %%%%%%"
    puts e.inspect
    puts criteria_list.inspect
  end
end
