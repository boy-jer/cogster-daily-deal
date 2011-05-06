Factory.define :hours do |h|
  h.business_id 1
  h.open_hour  '9'
  h.open_minute '00'
  h.open_meridian 'am'
  h.close_hour '5'
  h.close_minute '30'
  h.close_meridian 'pm'
end
