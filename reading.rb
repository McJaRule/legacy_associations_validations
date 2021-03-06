class Reading < ActiveRecord::Base
  belongs_to :lesson

  validates :lesson_id, presence: true
  validates :order_number, presence: true
  validates :url, presence: true
  validates :url, format: {with: /\A(http|https):\/\/\S+/i}

  default_scope { order('order_number') }

  scope :pre, -> { where("before_lesson = ?", true) }
  scope :post, -> { where("before_lesson != ?", true) }

  def clone
    dup
  end
end
