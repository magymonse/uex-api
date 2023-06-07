module Utility
  # Remove extra spaces, accents and convert to downcase
  def self.clean_string(string)
    I18n.transliterate(string).squish.downcase
  end
end
