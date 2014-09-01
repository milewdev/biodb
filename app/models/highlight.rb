class Highlight < ActiveRecord::Base

  belongs_to :user
  
  validates :content,
    presence: true
    
  validates :sort_order,
    presence: true,
    numericality: { only_integer: true, greater_than: 0 },
    uniqueness: { scope: :user_id, message: 'highlight sort_order must be unique for each user' }
  
end
