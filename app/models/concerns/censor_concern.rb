module CensorConcern
  extend ActiveSupport::Concern
  BAD_WORDS ||= File.read("#{Rails.root.to_s}/config/bad_words").split("\n")
  BAD_WORDS_REGEX = Regexp.union(BAD_WORDS.map{ |word| Regexp.new(word,true) })
  def censor_fields(*fields)
    fields.each do |field|
      self.send("#{field}=",super(censor(self.send(field))))
    end
  end

  def censor(text)
    text&.split(" ")&.reduce("") do |words, word|
      words + " " + bad_words_hash[word]
    end.lstrip
  end

  def bad_words
    #raise NotImplementedException, 'Please implement #bad_words method in your model'
    #Rails.configuration.bad_words
    BAD_WORDS
  end

  private

  #Return the same word if not a bad word or **** if it is
  def bad_words_hash
    Hash.new do |h,k|
      matched_data = k.match BAD_WORDS_REGEX
      if matched_data
        h[k] = matched_data[0].gsub(/./,"*")
      else
        h[k] = k
      end
    end
  end
end
