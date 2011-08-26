Time::DATE_FORMATS.merge!(:date => "%m/%d/%Y")
Date::DATE_FORMATS.merge!(:default => "%m/%d/%Y")

require 'date'
def Date._parse_sla(str, e) # :nodoc:
  if str.sub!(%r|('?-?\d+)/\s*('?\d+)(?:\D\s*('?-?\d+))?|, ' ') # '
    s3e(e, $2, $1, $3)
    true
  end
end
