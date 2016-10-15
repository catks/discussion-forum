module CensorConcern
  extend ActiveSupport::Concern
  BAD_WORDS ||= File.read("#{Rails.root.to_s}/config/bad_words").split("\n")

  def censor_fields(*fields)
    fields.each do |field|
      self.send("#{field}=",super(censor(self.send(field))))
    end
  end

  def censor(text)
    text&.split(" ")&.reduce("") do |words, word|
      words + bad_words_hash[word]
    end
  end

  def bad_words
    #raise NotImplementedException, 'Please implement #bad_words method in your model'
    #Rails.configuration.bad_words
    BAD_WORDS
  end

  private

  #Return the same word if not a bad word or **** if it is
  def bad_words_hash
    Hash.new{ |h,k| h[k] = k}.merge(
      Hash[bad_words.map{ |word| [word,word.gsub(/./,"*")]}]
    )
  end
end
