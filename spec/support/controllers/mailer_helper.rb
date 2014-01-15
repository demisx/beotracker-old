module Controllers
  module MailerHelpers
    def last_email
      ActionMailer::Base.deliveries.last
    end

    def reset_email
      ActionMailer::Base.deliveries = []
    end

    def email_count
      ActionMailer::Base.deliveries.size
    end

    def extract_confirmation_token(email)
      email && email.body && email.body.match(/confirmation_token=(.+)">/x)[1]
    end
  end
end