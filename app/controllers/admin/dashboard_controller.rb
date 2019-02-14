# frozen_string_literal: true
class Admin::DashboardController < Admin::BaseController

  def index
    @people             = Person.order('created_at DESC').limit(5)
    @submissions        = Submission.order('created_at DESC').where('person_id is ?', nil).limit(5)
    @recent_signups     = Person.where('signup_at > :startdate', { startdate: 1.week.ago }).size
    @recent_submissions = Submission.where('person_id is ? AND created_at > ?', nil, 4.weeks.ago).size
    @deactivated        = Person.unscoped.where(active: false).where('deactivated_at > ?', 1.week.ago).size
  end

  def privacy_mode
    session[:privacy_mode] = !session[:privacy_mode]
    redirect_to :back
  end

  def inbox
    emails = EmailMessage.where(user: current_admin_user)
    sms = TwilioMessage.where(user: current_admin_user)
    @messages = (emails + sms).sort_by(&:time_sent).reverse
    @people = @messages.map(&:person).uniq
    current_admin_user.update(unread_messages: 0)
  end

  def message_lookup
    EmailMessage.find_replies(current_admin_user, params[:person_id])
    emails = EmailMessage.where(user: current_admin_user, person: params[:person_id]).order(:time_sent)
    sms = TwilioMessage.where(user: current_admin_user, person: params[:person_id]).order(:date_sent)
    @messages = (emails + sms).sort_by(&:time_sent)
    render partial: 'message_tab', locals: { person_id: params[:person_id] }
  end

end
