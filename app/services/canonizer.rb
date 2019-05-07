# frozen_string_literal: true

# Helper for canonizing and transliterating strings
class Canonizer
  # Keys are not latin letters
  TRANSLITERATION_MAP = {
    'а' => 'a', 'б' => 'b', 'в' => 'v', 'г' => 'g', 'д' => 'd', 'е' => 'e',
    'ё' => 'yo', 'ж' => 'zh', 'з' => 'z', 'и' => 'i', 'й' => 'j', 'к' => 'k',
    'л' => 'l', 'м' => 'm', 'н' => 'n', 'о' => 'o', 'п' => 'p', 'р' => 'r',
    'с' => 's', 'т' => 't', 'у' => 'u', 'ф' => 'f', 'х' => 'kh', 'ц' => 'c',
    'ч' => 'ch', 'ш' => 'sh', 'щ' => 'shh', 'ъ' => '', 'ы' => 'y', 'ь' => '',
    'э' => 'e', 'ю' => 'yu', 'я' => 'ya',
    'å' => 'ao', 'ä' => 'ae', 'ö' => 'oe', 'é' => 'e'
  }.freeze

  # @param [String] text
  def self.transliterate(text)
    pattern = Regexp.new "[#{TRANSLITERATION_MAP.keys.join}]"
    result = text.to_s.downcase.gsub(pattern, TRANSLITERATION_MAP)

    a = /[^-a-z0-9_]/ # non-allowed characters will be replaced with dash
    b = /\A[-_]*([-a-z0-9_]*[a-z0-9]+)[-_]*\z/ # chop leading and trailing dash
    result.gsub(a, '-').gsub(b, '\1').gsub(/--+/, '-').gsub(/-+\z/, '')
  end

  # @param [String] input
  def self.canonize(input)
    lowered = input.to_s.downcase.strip
    canonized = lowered.gsub(/[^a-zа-я0-9ё]/, '')
    canonized.empty? ? lowered : canonized
  end

  # @param [String] input
  def self.urlize(input)
    lowered = input.to_s.downcase.squish
    lowered.gsub(/[^a-zа-я0-9ё]/, '-').gsub(/-+\z/, '')
  end
end
