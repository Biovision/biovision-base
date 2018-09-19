module MetaTexts
  extend ActiveSupport::Concern

  included do
    validates_length_of :meta_description, maximum: 500
    validates_length_of :meta_keywords, maximum: 250
    validates_length_of :meta_title, maximum: 250

    protected

    def self.meta_text_fields
      %i[meta_description meta_keywords meta_title]
    end
  end
end
