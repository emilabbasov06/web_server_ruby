module Utils
  class NormalText
    def self.remove_last(text, from, to)
      last_index = text.rindex(from)

      if last_index
        text[last_index, from.size] = to
      end
      text
    end
  end
end