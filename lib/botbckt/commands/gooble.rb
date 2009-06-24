module Botbckt #:nodoc:

  # Sends text repeatedly to Google Translate via the JSON API 
  # to garble the output. Translation starts and ends with 
  # MAIN_LANGUAGE unless a language option is passed in. If
  # an option is present it is used as the starting language.
  # 
  #
  #  < user> ~gooble We the People of the United States, in Order to form a more perfect Union
  #  < botbckt> Popular in the United States to create the completed
  #
  # With language option:
  # 
  #  < user> ~gooble --german Guten tag
  #  < botbckt> Good day
  #
  # or the short version
  #
  #  < user> ~gooble -de Guten tag
  #  < botbckt> Good day
  
  class Gooble < Command
  
    MAIN_LANGUAGE       = "en"
    TRANSLATE_ATTEMPTS  = 4
    # Yeah this is wordy but it's self documenting.
    LANGUAGES           = 
      {
        "Albanian"    => "sq",
        "Arabic"      => "ar",
        "Bulgarian"   => "bg",
        "Catalan"     => "ca",
        "Chinese"     => "zh-CN",
        "Croatian"    => "hr",
        "Czech"       => "cs",
        "Danish"      => "da",
        "Dutch"       => "nl",
        "English"     => "en",
        "Estonian"    => "et",
        "Filipino"    => "tl",
        "Finnish"     => "fi",
        "French"      => "fr",
        "Galician"    => "gl",
        "German"      => "de",
        "Greek"       => "el",
        "Hebrew"      => "iw",
        "Hindi"       => "hi",
        "Hungarian"   => "hu",
        "Indonesian"  => "id",
        "Italian"     => "it",
        "Japanese"    => "ja",
        "Korean"      => "ko",
        "Latvian"     => "lv",
        "Lithuanian"  => "lt",
        "Maltese"     => "mt",
        "Norwegian"   => "no",
        "Polish"      => "pl",
        "Portuguese"  => "pt",
        "Romanian"    => "ro",
        "Russian"     => "ru",
        "Serbian"     => "sr",
        "Slovak"      => "sk",
        "Slovenian"   => "sl",
        "Spanish"     => "es",
        "Swedish"     => "sv",
        "Thai"        => "th",
        "Turkish"     => "tr",
        "Ukrainian"   => "uk",
        "Vietnamese"  => "vi"
      }
    
    trigger :gooble do |sender, channel, gooble_string|
      # start with english unless asked for something else
      gooble_string =~ /(-\w{2}|--\w+)?(.*)/i
      option, text = $1, $2
      clean_option = option.gsub(/-/,'') if option

      start_language = case option
        when /^--/ then
          LANGUAGES[clean_option.capitalize!] || MAIN_LANGUAGE
        when /^-/ then
          LANGUAGES.value?(clean_option) ? clean_option : MAIN_LANGUAGE
        else
          MAIN_LANGUAGE
      end

      # languages to use for the goobling
      languages = [start_language]
      languages << LANGUAGES.values.sort_by{ rand }.slice(0...TRANSLATE_ATTEMPTS)
      languages << MAIN_LANGUAGE # always end with main 
      
      gooble(text, languages.flatten) do |result|
        say result, channel
      end
    end
  
    private

    # args
    # text<String>: text to translate
    # langs<Array>: languages to translate from/to
    def self.gooble(text, languages, &block) #:nodoc:
      if languages.length >= 2
        pair     = "#{languages[0]}|#{languages[1]}"
        open("http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=#{CGI.escape(text)}&langpair=#{CGI.escape(pair)}") do |json|
          response = JSON.parse(json) # could check for failed response with response['responseStatus'] != 200 
          languages.shift
          gooble(response['responseData']['translatedText'], languages)
        end
      else
        yield text
      end
    end

  end
end