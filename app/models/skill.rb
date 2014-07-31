class Skill < ActiveRecord::Base
  
  # relationships
  belongs_to :job
  
  # cleansing
  before_validation :strip_leading_and_trailing_whitespace
  
  # validation
  validates :job_id,
    uniqueness: { scope: [:name], case_sensitive: false, message: "- this skill already exists for this job (same name)" }
  
  validates :name,
    length: { in: 2..100 }
    
  validates :group,
    length: { in: 2..100 }

  protected

  def strip_leading_and_trailing_whitespace
    self.name = self.name.sub(/\A\s+/, '').sub(/\s+\z/, '') if attribute_present?(:name)
    self.group = self.group.sub(/\A\s+/, '').sub(/\s+\z/, '') if attribute_present?(:group)
  end
  
end
