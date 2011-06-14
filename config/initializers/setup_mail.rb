ActionMailer::Base.smtp_settings = {
  :address              => "break.example.com",#"smtp.gmail.com",
  :port                 => 587,
  :domain               => "rails@cogster.com",
  :user_name            => "rails@cogster.com",
  :password             => "Cogster3141",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
