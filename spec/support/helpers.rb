module HelperMethods
  def verify_translations
    page.should have_no_css('.translation_missing')
    page.should have_no_content('translation missing')
  end
end

RSpec.configuration.include HelperMethods