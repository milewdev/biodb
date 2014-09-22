class User < ActiveRecord::Base
  
    validates :email,
      presence: true,
      email_format: true,
      uniqueness: { case_sensitive: false }
    
    validates :password,
      password_format: true
    
    has_secure_password
  
    before_validation :cleanse_name
    before_validation :cleanse_highlights
  
  private
  
    def cleanse_name
      return if self.name.nil?
      self.name = self.name.strip
      self.name = nil if self.name.length == 0
    end
  
    def cleanse_highlights
      if not self.highlights.nil?
        self.highlights = self.highlights   # " one \n \n two \n"
          .gsub( /^[ \t]+/, '' )            # "one \n\ntwo \n"
          .gsub( /[ \t]+$/, '' )            # "one\n\ntwo\n"
          .gsub( /\n\n+/, "\n" )            # "one\ntwo\n"
          .sub( /\n+\z/, '' )               # "one\ntwo"
        self.highlights = nil if self.highlights.length == 0
      end
    end
  
end
