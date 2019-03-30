# frozen_string_literal: true

class SanitizerService
  REGEXP_CONTRACT_TYPES =
    {
      internship:       [/internship/, /stage/],
      vie:              /vie/,
      graduate_program: /graduate program/,
      full_time:        [/full.time/, /cdi/],
      fixed_term:       [/fixed.(term|time)/, /cdd/],
      apprenticeship:   [/apprenticeship/, /alternance/]
    }.freeze

  REGEXP_COMPANY_STRUCTURES =
    {
      large_company: [/large company/],
      sme:           [/sme/, /pme/, /small and (medium|mid)/],
      start_up:      [/start[ -]up/],
      others:        [/others?/]
    }.freeze

  REGEXP_MONTHS =
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
    }.freeze

  def initialize(func, arg)
    @func = func
    @arg = arg
  end

  def call
    if self.class.method_defined?(@func.to_sym)
      send(@func.to_s, @arg)
    else
      default(@arg)
    end
  end

  protected

  def string(value)
    default(value)
  end

  def symbol(value)
    default(value).to_sym
  end

  def integer(value)
    default(value.to_s.gsub(/\D/, "")).to_i
  end

  def email(value)
    value = value.to_s.downcase.gsub(/\s/, "")
    regex_email = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    regex_email.match?(value) ? value : nil
  end

  def url(value)
    value = default(value)
    regex_url = %r{https?://[\S]+}i
    regex_url.match?(value) ? value : nil
  end

  def location(value)
    string(value)
  end

  def date(value)
    now = ["immediate", "now", "dès que possible"]
    if now.include?(value.strip.downcase)
      date = Date.today
    else
      year = Date.today.year
      reg_sanitizer = RegexSanitizerService.new(value, REGEXP_MONTHS, nil)
      month reg_sanitizer.call
      day = value.gsub(/\D/, "").to_i
      date = Date.new(year, month, day)
      date = date.next_year while date < Date.today
    end
    date
  rescue StandardError
  end

  def md(value)
    value = ReverseMarkdown.convert(value, tag_border: " ")
    value.gsub("&nbsp;", " ").gsub(/\ {2,}/, "\n").gsub(/\n{3,}/, "\n\n").strip
  end

  def contract_type(value)
    reg_sanitizer = RegexSanitizerService.new(value, REGEXP_CONTRACT_TYPES, :other)
    reg_sanitizer.call
  end

  def company_structure(value)
    reg_sanitizer = RegexSanitizerService.new(value, REGEXP_COMPANY_STRUCTURES, :others)
    reg_sanitizer.call
  end

  def default(value)
    ActionController::Base.helpers.strip_tags(value.to_s)
  end
end
