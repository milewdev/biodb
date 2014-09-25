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
  
  private
  
    # TODO: DRY up these cleansing routines
    def cleanse_name
      return if self.name.nil?
      self.name = self.name.strip
      self.name = nil if self.name.length == 0
    end
  
    def cleanse_title
      return if self.title.nil?
      self.title = self.title.strip
      self.title = nil if self.title.length == 0
    end
  
    def cleanse_highlights
      self.highlights = '[]' if self.highlights.nil? or self.highlights.strip.length == 0
      highlights = JSON.parse(self.highlights)
      highlights.each do |highlight|
        highlight['name'].strip!          # TODO: loop through the attributes
        highlight['content'].strip!
      end
      highlights = highlights.select do |highlight|
        highlight['name'].length > 0 or highlight['content'].length > 0     # TODO: loop through the attributes
      end
      self.highlights = JSON.generate(highlights)
    rescue JSON::ParserError => ex
        errors[:highlights] << "badly formed JSON: #{ex.message}"
    end
  
end
