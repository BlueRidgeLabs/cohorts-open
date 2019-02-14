# frozen_string_literal: true
json.success true
json.results @question.choices do |value|
  json.name value
  json.value value
end
