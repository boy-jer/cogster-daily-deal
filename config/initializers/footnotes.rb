if defined?(Footnotes) && Rails.env.development?
  Footnotes.run!
  Footnotes::Filter.prefix = "gvim://open?url=file://%s&line=%d&column=%d&rails_root=#{Rails.root}"
end
