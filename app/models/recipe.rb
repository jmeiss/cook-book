require 'uri'

class Recipe < ActiveRecord::Base

  belongs_to :user

  has_many :directions
  has_many :ingredients

  accepts_nested_attributes_for :directions, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true

  attr_accessor :url_to_parse

  validate :is_domain_supported_to_parse
  validates :name, :presence => true, :if => "url_to_parse.nil?"
  validates_associated :user

  before_create :build_recipe_form_url, :unless => "url_to_parse.nil?"

  SUPPORTED_DOMAINS_TO_PARSE = %w(www.marmiton.org)



  def to_param
    "#{id}-#{name.parameterize}" if name
  end

  def build_recipe_form_url
    method_name = RecipeParser.get_method_name_for_url url_to_parse
    RecipeParser.send "get_#{method_name}_recipe", url_to_parse
  end

  def is_domain_supported_to_parse
    if url_to_parse && !SUPPORTED_DOMAINS_TO_PARSE.include?(URI.parse(self.url_to_parse).host)
      errors.add(:url_to_parse, "Désolé, ce site n'est pas supporté. Merci d'ajouter la recette manuellement.")
    end
  end

end
