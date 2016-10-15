#bad_words = "#{Rails.root.to_s}/config/bad_words".split("\n")
BAD_WORDS ||= File.read("#{Rails.root.to_s}/config/bad_words").split("\n")
#Rails.application.configure do
# config.bad_words = bad_words
#end
