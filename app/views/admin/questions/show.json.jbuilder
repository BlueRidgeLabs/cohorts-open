# frozen_string_literal: true
json.success true
json.results @question.answers.map(&:value).uniq do |value|
  json.name value
  json.value value
end
