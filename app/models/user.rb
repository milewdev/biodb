class User < ActiveRecord::Base
  
    validates :email,
      presence: true,
      email_format: true,
      uniqueness: { case_sensitive: false }
    
    validates :password,
      password_format: true
      
    has_secure_password
  
    before_validation :cleanse_name
    before_validation :cleanse_title
    before_validation :cleanse_highlights
    before_validation :cleanse_jobs
  
  private
  
    # TODO: DRY up these cleansing routines
    def cleanse_name
      # TODO: convert nil to empty string
      return if self.name.nil?
      self.name = self.name.strip
      self.name = nil if self.name.length == 0
    end
  
    def cleanse_title
      # TODO: convert nil to empty string
      return if self.title.nil?
      self.title = self.title.strip
      self.title = nil if self.title.length == 0
    end
  
    # TODO: refactor
    def cleanse_highlights
      self.highlights = '[]' if self.highlights.nil? or self.highlights.strip.length == 0
      highlights = JSON.parse(self.highlights)
      highlights.each do |highlight|
        (highlight['name'] ||= '').strip!          # TODO: loop through the attributes
        (highlight['content'] ||= '').strip!
      end
      highlights = highlights.select do |highlight|
        highlight['name'].length > 0 or highlight['content'].length > 0     # TODO: loop through the attributes
      end
      self.highlights = JSON.generate(highlights)
    rescue JSON::ParserError => ex
      errors[:highlights] << "badly formed JSON: #{ex.message}"
    end
    
    # TODO: refactor
    def cleanse_jobs
      self.jobs = '[]' if self.jobs.nil? or self.jobs.strip.length == 0
      jobs = JSON.parse(self.jobs)
      jobs.each do |job|
        (job['company'] ||= '' ).strip!
        job['date_range'] = (job['date_range'] || '').gsub(' ', '')
        (job['role'] ||= '').strip!
        job['tasks'] = [] if job['tasks'].nil? or (job['tasks'].to_s.strip.length == 0)
        (job['tasks'].map! {|task| (task || '').strip }).select! {|task| task.length > 0 }
      end
      jobs.select! do |job|
        job['company'].length > 0 or
        job['date_range'].length > 0 or
        job['role'].length > 0 or
        job['tasks'].length > 0
      end
      jobs.each do |job|
        errors[:jobs] << 'job company name is missing' if job['company'].nil? or job['company'].strip.length == 0
        errors[:jobs] << 'job date range is missing' if job['date_range'].nil? or job['date_range'].strip.length == 0
        errors[:jobs] << "job date range \"#{job['date_range']}\" is unrecognizable" unless valid_date_range_value?(job['date_range'])
      end
      self.jobs = JSON.generate(jobs)
    rescue JSON::ParserError => ex
      errors[:jobs] << "badly formed JSON: #{ex.message}"
    end
    
    # TODO: extract the methods below into a library function, e.g. parseDateRange, and then refactor it
    
    class BadDateRangeError < StandardError ; end
    
    # date_range: date OR date-date
    # date: year OR year.month OR year.month.day
    # date must be valid, e.g. 2014.02.30 is invalid
    # date range must be valid, e.g. 2014.01.01-2013.01.01 is invalid
    # valid examples: 2014  2014.01  2014.01.25  2014-2015  2014.01-2015  2014-2015.03.17
    def valid_date_range_value?(date_range)
      m = match(date_range)
      y1 = m[1]
      m1 = m[2] || '1'
      d1 = m[3] || '1'
      from = Date.new(y1.to_i, m1.to_i, d1.to_i)
      y2 = m[4] || y1
      m2 = m[5] || '12'
      d2 = m[6] || last_day_of(y2, m2)
      to = Date.new(y2.to_i, m2.to_i, d2.to_i)
      raise BadDateRangeError if to.jd < from.jd
      true
    rescue BadDateRangeError, ArgumentError
      false
    end
    
    def match(date_range)
      m = /\A(\d{4})(?:\.(\d{1,2})(?:\.(\d{1,2}))?)?(?:-(\d{4})(?:\.(\d{1,2})(?:\.(\d{1,2}))?)?)?\z/.match(date_range)
      raise BadDateRangeError.new unless m
      m
    end
    
    def last_day_of(year, month)
      Date.new(year.to_i, month.to_i, 1).next_month.prev_day.day
    end
  
end
