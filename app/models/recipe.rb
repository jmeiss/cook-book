require 'uri'

class Recipe < ActiveRecord::Base

  belongs_to :user

  has_many :directions, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :ingredients, dependent: :destroy

  accepts_nested_attributes_for :directions,  reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :images,      reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true

  attr_accessor :url_to_parse

  validates :name, :presence => true, :if => "url_to_parse.nil?"
  validates_associated :user

  SUPPORTED_DOMAINS_TO_PARSE = %w(www.marmiton.org)



  def to_param
    "#{id}-#{name}".parameterize if name
  end

  def self.build_recipe_from_url url
    return false unless Recipe.is_domain_supported_to_parse? url
    method_name = URI.parse(url).host.gsub(/\./, '_').camelize
    eval "Parser::#{method_name}.get_recipe('#{url}')"
  end

  def self.is_domain_supported_to_parse? url
    return SUPPORTED_DOMAINS_TO_PARSE.include?(URI.parse(url).host) if url
  end

end
