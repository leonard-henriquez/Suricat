# frozen_string_literal: true

class Opportunity < ApplicationRecord
  enum contract_type: %i[internship vie graduate_program fixed_term full_time apprenticeship other]
  belongs_to :job
  belongs_to :company
  belongs_to :sector, optional: true
  has_one :job_category, through: :job
  has_one :sector_category, through: :sector
  has_many :user_opportunities, dependent: :destroy
  has_many :users, through: :user_opportunities
  validates :url, presence: true, uniqueness: true
  validates :job_description, presence: true
  validates :contract_type, presence: true
  validates :location, presence: true
  validates :salary, presence: true

  after_initialize :init
  geocoded_by :company_location
  after_validation :geocode, if: :will_save_change_to_location?

  [Job, Company, Sector].each do |obj|
    (obj.attribute_names - attribute_names).each do |attr|
      object_name = obj.name.underscore
      delegate attr.to_sym, to: object_name, allow_nil: true, prefix: true
    end
  end

  def init
    self.salary ||= 0
  end

  def contract_type=(value)
    unless value.is_a? Symbol
      sanitizer = ApiSanitizerService.new(value, contract_types_format, :other)
      value = sanitizer.call
    end
    super(value)
  end

  def salary=(value)
    value ||= 0
    value = value.to_s.gsub(/\D/, "").to_i
    super(value)
  end

  def start_date=(str)
    now = ["immediate", "now", "dès que possible"]
    if now.include?(str.strip.downcase)
      date = Date.today
    else
      year = Date.today.year
      month = nil
      months.each do |month_int, regexes|
        month = month_int if regexes.any? { |regex| regex.match(str.downcase) }
      end
      day = str.gsub(/[^0-9]/, "").to_i
      date = Date.new(year, month, day)
      date = date.next_year while date < Date.today
    end
    super(date)
  rescue Exception => e
  end

  def logo=(str)
    super(str) unless /placeholder/.match(str)
  end

  def company_location
    company.nil? ? location : [company.name, location].compact.join(", ")
  end

  protected

  def contract_types_format
    {
      internship:       [/internship/, /stage/],
      vie:              /vie/,
      graduate_program: /graduate program/,
      full_time:        [/full.time/, /cdi/],
      fixed_term:       [/fixed.(term|time)/, /cdd/],
      apprenticeship:   [/apprenticeship/, /alternance/]
    }
  end

  def months
    {
      1  => [/jan\.?/, /jan\.?/],
      2  => [/fév\.?/, /feb\.?/],
      3  => [/mar\.?/, /mar\.?/],
      4  => [/avr\.?/, /apr\.?/],
      5  => [/mai/, /may/],
      6  => [/juin/, /jun\.?/],
      7  => [/juil\.?/, /jul\.?/],
      8  => [/août/, /aug\.?/],
      9  => [/sept\.?/, /sep\.?/],
      10 => [/oct\.?/, /oct\.?/],
      11 => [/nov\.?/, /nov\.?/],
      12 => [/déc\.?/, /dec\.?/]
    }
  end
end
