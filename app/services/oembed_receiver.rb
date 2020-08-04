# frozen_string_literal: true

# Receiver for OEmbed-wrapped content
class OembedReceiver
  PATTERN = %r{<oembed url="([^"]+)"></oembed>}.freeze

  attr_accessor :url

  # @param [String] url
  def initialize(url = '')
    @url = url
  end

  # @param [String] text
  def self.convert(text)
    receiver = new
    text.gsub(PATTERN) do |fragment|
      receiver.url = fragment.match(PATTERN)[1]
      receiver.code
    end
  end

  def code
    @host = URI.parse(@url).host
    receive url_for_host
  end

  def fallback
    attributes = %(rel="external nofollow noopener noreferrer" target="_blank")
    %(<a href="#{@url}" #{attributes}>#{@host}</a>)
  end

  private

  # @param [String] embed_url
  def receive(embed_url)
    response = RestClient.get(embed_url)
    parse(response.body)
  rescue RestClient::Exception => e
    Rails.logger.warn("Cannot receive data for #{embed_url}: #{e}")
    fallback
  end

  # @param [String] response
  def parse(response)
    json = JSON.parse(response)
    json['html'] || fallback
  rescue JSON::ParserError => e
    Rails.logger.warn("Cannot parse response #{response}: #{e}")
    fallback
  end

  def url_for_host
    case @host
    when 'www.vimeo.com', 'vimeo.com'
      url_for_vimeo
    when 'www.youtube.com', 'youtube.com', 'youtu.be'
      url_for_youtube
    when 'twitter.com', 'www.twitter.com'
      url_for_twitter
    when 'www.facebook.com', 'facebook.com'
      url_for_facebook
    when 'www.instagram.com', 'instagr.am', 'instagram.com'
      url_for_instagram
    else
      default_url
    end
  end

  def url_for_youtube
    "https://www.youtube.com/oembed?url=#{CGI.escape(@url)}&format=json"
  end

  def url_for_twitter
    "https://publish.twitter.com/oembed?url=#{CGI.escape(@url)}"
  end

  def url_for_facebook
    url = CGI.escape(@url)
    if @url.match?('/videos/')
      "https://www.facebook.com/plugins/video/oembed.json/?url=#{url}"
    else
      "https://www.facebook.com/plugins/post/oembed.json/?url=#{url}"
    end
  end

  def url_for_instagram
    "https://api.instagram.com/oembed?url=#{CGI.escape(@url)}"
  end

  def url_for_vimeo
    "https://vimeo.com/api/oembed.json?url=#{CGI.escape(@url)}&responsive=true"
  end

  def default_url
    "https://#{@host}/oembed?url=#{CGI.escape(@url)}&format=json"
  end
end
