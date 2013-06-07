require 'emoji_data/version'
require 'emoji_data/emoji_char'
require 'json'

module EmojiData
  RAW_JSON = IO.read('vendor/emoji-data/emoji.json')
  EMOJI_MAP = JSON.parse( RAW_JSON )
  EMOJI_CHARS = EMOJI_MAP.map { |em| EmojiChar.new(em) }

  def self.chars
    @chars ||= self.codepoints.map { |cp| Emoji.codepoint_to_char(cp) }
  end

  def self.codepoints
    @codepoints ||= EMOJI_MAP.map { |es| es['unified'] }
  end

  def self.char_to_unified(char)
    char.codepoints.to_a.map {|i| i.to_s(16).rjust(4,'0')}.join('-').upcase
  end

  def self.unified_to_char(cp)
    find_by_unified(cp).to_char
  end

  def self.find_by_unified(cp)
    EMOJI_CHARS.detect { |ec| ec.unified == cp }
  end

  # not sure why the below doesnt work... but maybe fuck reverse compatibility for MYSELF
  # self.module_eval do
  #   alias_method :find_by_codepoint, :find_by_unified
  #   alias_method :char_to_codepoint, :char_to_unified
  #   alias_method :codepoint_to_char, :unified_to_char
  # end
end
