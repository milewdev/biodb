class Job < ActiveRecord::Base
  
  # relationships
  has_many :skills, dependent: :destroy

  # cleansing
  before_validation :strip_leading_and_trailing_whitespace

  # validation
  validates :company,
    length: { maximum: 100 }

  validates :title,
    length: { maximum: 100 }
    
  validates :synopsis,
    length: { maximum: 10_000 }

  validates :when,
    presence: false

  # TODO: date validation in 'when' field
  # validate :when

  protected

  # TODO: rename method to cleanse
  def strip_leading_and_trailing_whitespace
    # TODO: extract method strip_leading_and_trailing_whitespace
    self.company = self.company.sub(/\A\s+/, '').sub(/\s+\z/, '') if attribute_present?(:company)
    self.title = self.title.sub(/\A\s+/, '').sub(/\s+\z/, '') if attribute_present?(:title)
    self.synopsis = self.synopsis.sub(/\A\s+/, '').sub(/\s+\z/, '') if attribute_present?(:synopsis)
    self.when = self.when.sub(/\A\s+/, '').sub(/\s+\z/, '') if attribute_present?(:when)
  end

end
