class Canonizer
  TRANSLITERATION_MAP = {
      'а' => 'a', 'б' => 'b', 'в' => 'v', 'г' => 'g', 'д' => 'd', 'е' => 'e',
      'ё' => 'yo', 'ж' => 'zh', 'з' => 'z', 'и' => 'i', 'й' => 'j', 'к' => 'k',
      'л' => 'l', 'м' => 'm', 'н' => 'n', 'о' => 'o', 'п' => 'p', 'р' => 'r',
      'с' => 's', 'т' => 't', 'у' => 'u', 'ф' => 'f', 'х' => 'kh', 'ц' => 'c',
      'ч' => 'ch', 'ш' => 'sh', 'щ' => 'shh', 'ъ' => '', 'ы' => 'y', 'ь' => '',
      'э' => 'e', 'ю' => 'yu', 'я' => 'ya',
  }

  # @param [String] text
  def self.transliterate(text)
    result = text.downcase
    TRANSLITERATION_MAP.each { |r, e| result.gsub!(r, e) }
    result.downcase.gsub(/[^-a-z0-9_]/, '-').gsub(/^[-_]*([-a-z0-9_]*[a-z0-9]+)[-_]*$/, '\1').gsub(/--+/, '-')
  end

  # @param [String] input
  def self.canonize(input)
    lowered   = input.downcase.strip
    canonized = lowered.gsub(/[^a-zа-я0-9ё]/, '')
    canonized.empty? ? lowered : canonized
  end

  # @param [String] input
  def self.urlize(input)
    lowered = input.downcase.squish
    lowered.gsub(/[^a-zа-я0-9ё]/, '-').gsub(/-\z/, '')
  end
end
