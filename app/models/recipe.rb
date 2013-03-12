class Recipe < ActiveRecord::Base

  belongs_to :user

  has_many :directions
  has_many :ingredients

  accepts_nested_attributes_for :directions, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true

  def to_param
    "#{id}-#{name.parameterize}"
  end

end
