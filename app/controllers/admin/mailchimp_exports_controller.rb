# frozen_string_literal: true
class Admin::MailchimpExportsController < Admin::BaseController

  def index
    @mailchimp_exports = MailchimpExport.all
  end

end
