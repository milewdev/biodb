# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Jobs
Job.delete_all

job = Job.create!(
  company: "Acme Software Inc.", 
  title: "Ruby Cutter", 
  start_date: DateTime.strptime("2014-06-21", "%Y-%m-%d"), 
  end_date: DateTime.strptime("2014-07-26", "%Y-%m-%d")
)

Skill.create!(
  job_id: job,
  name: "C++",
  group: "language"
)
