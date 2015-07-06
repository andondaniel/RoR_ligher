module ActiveAdmin

  class Comment  < ActiveRecord::Base

    after_create :send_email

    def send_email
      AdminMailer.comment_created(self).deliver
    end

  end

end