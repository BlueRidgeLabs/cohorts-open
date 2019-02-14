# frozen_string_literal: true
module SignupHelper
  def content_or_default(content, &default_content)
    content.present? && safe_join([content.html_safe]) || capture(&default_content)
  end

  def form_hash(form)
    form && form.hash_id || ENV['WUFOO_DEFAULT_FORM']
  end
end
