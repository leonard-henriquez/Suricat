# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user_1 = User.create(
  first_name: 'test',
  last_name: 'test_1',
  email: 'test@test.com',
  password: '123456'
)

user_2 = User.create(
  first_name: 'testy',
  last_name: 'testy_1',
  email: 'test2@test.com',
  password: '123456'
)

job_category_1 = JobCategory.create(
  name: 'Category_1'
)

job_category_2 = JobCategory.create(
  name: 'Category_2'
)

job_1 = Job.create(
  name: 'Job_Title_1',
  job_category: job_category_1
)

job_2 = Job.create(
  name: 'Job_Title_2',
  job_category: job_category_1
)

job_3 = Job.create(
  name: 'Job_Title_3',
  job_category: job_category_2
)

job_4 = Job.create(
  name: 'Job_Title_4',
  job_category: job_category_2
)

company_1 = Company.create(
  name: 'Company_1',
  structure: :large_company
)

company_2 = Company.create(
  name: 'Company_2',
  structure: :sme
)

sector_category_1 = SectorCategory.create(
  name: 'Category_1'
)

sector_category_2 = SectorCategory.create(
  name: 'Category_2'
)

sector_1 = Sector.create(
  name: 'Sector_Title_1',
  sector_category: sector_category_1
)

sector_2 = Sector.create(
  name: 'Sector_Title_2',
  sector_category: sector_category_1
)

sector_3 = Sector.create(
  name: 'Sector_Title_3',
  sector_category: sector_category_2
)

sector_4 = Sector.create(
  name: 'Sector_Title_4',
  sector_category: sector_category_2
)

opportunity_1 = Opportunity.create(
  job: job_1,
  company: company_1,
  sector: sector_1,
  salary: 1000,
  job_description: 'Job_Description_1',
  contract_type: :internship,
  location: 'roubaix',
  url: 'url_1',
  logo: 'https://d1guu6n8gz71j.cloudfront.net/system/asset/logos/1744941/logo_mobile.png?1541332792'
)

opportunity_2 = Opportunity.create(
  job: job_2,
  company: company_1,
  sector: sector_4,
  salary: 1000,
  job_description: 'Job_Description_2',
  contract_type: :vie,
  location: 'lille',
  url: 'url_2',
  logo: 'https://d1guu6n8gz71j.cloudfront.net/system/asset/logos/1744941/logo_mobile.png?1541332792'
)

opportunity_3 = Opportunity.create(
  job: job_2,
  company: company_2,
  sector: sector_3,
  salary: 1000,
  job_description: 'Job_Description_3',
  contract_type: :fixed_term,
  location: 'paris',
  url: 'url_3',
  logo: 'https://d1guu6n8gz71j.cloudfront.net/system/asset/logos/1744941/logo_mobile.png?1541332792'
)

opportunity_4 = Opportunity.create(
  job: job_4,
  company: company_1,
  sector: sector_2,
  salary: 1000,
  job_description: 'Job_Description_4',
  contract_type: :full_time,
  location: 'new york',
  url: 'url_4',
  logo: 'https://d1guu6n8gz71j.cloudfront.net/system/asset/logos/1744941/logo_mobile.png?1541332792'
)

user_opportunity_1 = UserOpportunity.create(
  user: user_1,
  opportunity: opportunity_2,
  personnal_grade: 1,
  status: :review
)

user_opportunity_2 = UserOpportunity.create(
  user: user_1,
  opportunity: opportunity_3,
  personnal_grade: 3,
  status: :pending
)

user_opportunity_3 = UserOpportunity.create(
  user: user_1,
  opportunity: opportunity_4,
  personnal_grade: 2,
  status: :applied
)

event_1 = Event.create(
  user: user_1,
  start_time: DateTime.new(2018,11,3),
  name: 'Event_1'
)

event_2 = Event.create(
  user: user_2,
  start_time: DateTime.new(2018,11,9),
  name: 'Event_2'
)

event_3 = Event.create(
  user: user_1,
  start_time: DateTime.new(2018,12,9),
  name: 'Event_3'
)

importance_1 = Importance.find_by(
  user: user_1,
  name: :contract_type
)

criteria_1_1 = Criterium.create(
  importance: importance_1,
  value: 'vie',
  rank: 1
)

criteria_1_2 = Criterium.create(
  importance: importance_1,
  value: 'internship',
  rank: 2
)

importance_2 = Importance.find_by(
  user: user_1,
  name: :structure
)

criteria_2_1 = Criterium.create(
  importance: importance_2,
  value: 'large-company',
  rank: 1
)

criteria_2_2 = Criterium.create(
  importance: importance_2,
  value: 'start-up',
  rank: 2
)

importance_3 = Importance.find_by(
  user: user_1,
  name: :industry
)

criteria_3_1 = Criterium.create(
  importance: importance_3,
  value: 'Sector_Title_1',
  rank: 1
)

criteria_3_2 = Criterium.create(
  importance: importance_3,
  value: 'Sector_Title_2',
  rank: 2
)

importance_4 = Importance.find_by(
  user: user_1,
  name: :job
)

criteria_4_1 = Criterium.create(
  importance: importance_4,
  value: 'Job_Title_1',
  rank: 1
)

criteria_4_2 = Criterium.create(
  importance: importance_4,
  value: 'Job_Title_3',
  rank: 2
)

importance_5 = Importance.find_by(
  user: user_1,
  name: :location
)

criteria_5_1 = Criterium.create(
  importance: importance_5,
  value: 'paris',
  rank: 1
)

criteria_5_2 = Criterium.create(
  importance: importance_5,
  value: 'lille',
  rank: 2
)

importance_6 = Importance.find_by(
  user: user_1,
  name: :salary
)

criteria_6_1 = Criterium.create(
  importance: importance_6,
  value: 1000,
  rank: 1
)

criteria_6_2 = Criterium.create(
  importance: importance_6,
  value: 1000,
  rank: 2
)
