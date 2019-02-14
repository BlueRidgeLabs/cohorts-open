# frozen_string_literal: true
class MandrillMailer < ApplicationMailer
  def outbound(to, subject, body)
    mail(to: to,
         from: ENV['MAILER_SENDER'],
         subject: subject,
         body: body,
         content_type: 'text/html')
  end
end
