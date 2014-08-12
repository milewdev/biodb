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
  when: "2014"
)

Skill.create!(
  job_id: job,
  name: "C++",
  group: "language"
)
