require 'spec_helper'

describe RecipeParser do

  describe 'get_method_name_for_url' do
    it "should return domain name for url" do
      ['http://www.marmiton.org/', 'http://www.marmiton.org/recettes/recette_les-timbales_21864.aspx'].each do |url|
        RecipeParser.get_method_name_for_url(url).should eq('www_marmiton_org')
      end
    end
  end

end