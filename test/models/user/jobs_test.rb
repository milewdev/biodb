require 'test_helper'

describe User do
  
  @MISSING_VALUES = [ nil, '', ' ' * 3 ]

  describe 'when jobs is valid' do
    let(:user) { User.create!(valid_jobs) }
    it 'is saved' do
      User.find(user.id).jobs.must_equal valid_jobs[:jobs]
    end
  end
  
  @MISSING_VALUES.each do |missing_value|
    describe "when jobs is missing: #{missing_value}" do
      let(:user) { User.create!(missing_jobs(missing_value)) }
      it 'is saved as an empty array' do
        User.find(user.id).jobs.must_equal '[]'
      end
    end
  end
  
  describe "when a job is empty" do
    let(:user) { User.create!(empty_job) }
    it 'is saved as an empty array' do
      User.find(user.id).jobs.must_equal '[]'
    end
  end
  
  @MISSING_VALUES.each do |missing_value|
    describe "when the company name is missing: #{missing_value}" do
      let(:user) { User.create(missing_job_company_name(missing_value)) }
      it 'generates an error' do
        user.errors[:jobs].must_include 'job company name is missing'
      end
    end
  end
  
  @MISSING_VALUES.each do |missing_value|
    describe "when the date range is missing: #{missing_value}" do
      let(:user) { User.create(missing_job_date_range(missing_value)) }
      it 'generates an error' do
        user.errors[:jobs].must_include 'job date range is missing'
      end
    end
  end
  
  [ '2014', '2014.09', '2014.09.30', '2014-2015', '2014.09-2015', '2014.09.30-2015', '2014-2015.03', '2014-2015.03.25' ].each do |valid_value| 
    describe "when the date range is valid: #{valid_value}" do
      let(:user) { User.create!(valid_job_date_range(valid_value)) }
      it 'does not generate an error' do
        user.errors[:jobs].must_be_empty
      end
    end
  end
  
  # TODO: add a few more bad values
  ['201', '2014.a', '2014-201', '2014.13', '2014.1-2013.1'].each do |bad_value|
    describe "when the date range is unrecognizable: #{bad_value}" do
      let(:user) { User.create(invalid_job_date_range(bad_value)) }
      it 'generates an error' do
        user.errors[:jobs].must_include "job date range \"#{bad_value}\" is unrecognizable"
      end
    end
  end
  
  @MISSING_VALUES.each do |missing_value|
    describe "when the role is missing: #{missing_value}" do
      let(:user) { User.create!(missing_job_role(missing_value)) }
      it 'does not generate an error' do
        user.errors[:jobs].must_be_empty
      end
      it 'is saved as an empty string' do
        JSON.parse(User.find(user.id).jobs)[0]['role'].must_equal ''
      end
    end
  end
  
  @MISSING_VALUES.each do |missing_value|
    describe "when the tasks are missing: #{missing_value}" do
      let(:user) { User.create!(missing_job_tasks(missing_value)) }
      it 'does not generate an error' do
        user.errors[:jobs].must_be_empty
      end
      it 'is saved as an empty array' do
        JSON.parse(User.find(user.id).jobs)[0]['tasks'].must_equal []
      end
    end
  end
  
  @MISSING_VALUES.each do |missing_value|
    describe "when a task is missing: #{missing_value}" do
      let(:user) { User.create!(missing_job_task(missing_value)) }
      it 'does not generates an erorr' do
        user.errors[:jobs].must_be_empty
      end
      it 'is not saved' do
        # TODO: clean up somehow; this 'magic' string is from where?
        user.jobs.must_equal '[{"company":"company","date_range":"2014","role":"role","tasks":[]}]'
      end
    end
  end
  
  describe "when tasks is unrecognizable" do
    let(:user) { User.create(unrecognizable_job_tasks) }
    it 'generates an error' do
      user.errors[:jobs][0].must_match( /badly formed JSON/ )
    end
  end
  
  describe 'when attributes have leading and/or trailing whitespace' do
    let(:user) { User.create!(whitespaced_job_attributes)}
    it 'trims the spaces before saving' do
      User.find(user.id).jobs.must_equal stripped_job_attributes[:jobs]
    end
  end
  
  def valid_jobs
    {
      email: 'email@test.com',
      password: 'Password1234',
      password_confirmation: 'Password1234',
      name: 'name',
      title: 'title',
      highlights: JSON.generate( [{name: "languanges", content: "C, C++, Ruby"}] ), 
      jobs: JSON.generate( [{company: "company", date_range: "2014", role: "role", tasks: ["wrote tests", "wrote code", "deployed app"]}] )
    }
  end
  
  def missing_jobs(missing_value)
    valid_jobs.merge({
      jobs: missing_value
    })
  end
  
  def empty_job
    valid_jobs.merge({
      jobs: JSON.generate( [{company: "", date_range: "", role: "", tasks: [""]}] )
    })
  end
  
  def missing_job_company_name(missing_value)
    valid_jobs.merge({
      jobs: JSON.generate( [{company: missing_value, date_range: "2014", role: "role", tasks: ["wrote tests", "wrote code", "deployed app"]}] )
    })
  end
  
  def missing_job_date_range(missing_value)
    valid_jobs.merge({
      jobs: JSON.generate( [{company: "company", date_range: missing_value, role: "role", tasks: ["wrote tests", "wrote code", "deployed app"]}] )
    })
  end
  
  def valid_job_date_range(valid_value)
    valid_jobs.merge({
      jobs: JSON.generate( [{company: "company", date_range: valid_value, role: "role", tasks: ["wrote tests", "wrote code", "deployed app"]}] )
    })
  end
  
  def invalid_job_date_range(invalid_value)
    valid_jobs.merge({
      jobs: JSON.generate( [{company: "company", date_range: invalid_value, role: "role", tasks: ["wrote tests", "wrote code", "deployed app"]}] )
    })
  end
  
  def missing_job_role(missing_value)
    valid_jobs.merge({
      jobs: JSON.generate( [{company: "company", date_range: "2014", role: missing_value, tasks: ["wrote tests", "wrote code", "deployed app"]}] )
    })
  end
  
  def missing_job_tasks(missing_value)
    valid_jobs.merge({
      jobs: JSON.generate( [{company: "company", date_range: "2014", role: "role", tasks: missing_value}] )
    })
  end
  
  # Note: singular 'task'; compare with missing_job_tasks above
  def missing_job_task(missing_value)
    valid_jobs.merge({
      jobs: JSON.generate( [{company: "company", date_range: "2014", role: "role", tasks: [missing_value]}] )
    })
  end
  
  def unrecognizable_job_tasks
    valid_jobs.merge({
      jobs: '[{"company":"company","date_range":"2014","role":"role","tasks":GARBAGE}]'
    })
  end
  
  def whitespaced_job_attributes
    valid_jobs.merge({
      jobs: JSON.generate( [{company: " company ", date_range: " 2014 - 2017.3 ", role: " role ", tasks: [" wrote tests ", " wrote code ", " deployed app "]}] )
    })
  end
  
  def stripped_job_attributes
    valid_jobs.merge({
      jobs: JSON.generate( [{company: "company", date_range: "2014-2017.3", role: "role", tasks: ["wrote tests", "wrote code", "deployed app"]}] )
    })
  end
  
end
