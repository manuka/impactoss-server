require File.expand_path("../config/boot", __FILE__)
require File.expand_path("../config/environment", __FILE__)
require "clockwork"

module Clockwork
  every(1.day, "Send Due Emails", at: "13:36", tz: Rails.application.config.time_zone) do
    SendDueEmailsJob.perform_now
  end

  every(1.day, "Send Overdue Emails", at: "13:40", tz: Rails.application.config.time_zone) do
    SendOverdueEmailsJob.perform_now
  end

  every(1.day, "Send Category Overdue Emails", at: "13:50", tz: Rails.application.config.time_zone) do
    SendCategoryOverdueEmailsJob.perform_now
  end

  error_handler do |error|
  end
end
