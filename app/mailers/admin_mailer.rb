class AdminMailer < ActionMailer::Base
  def comment_created(comment)
  	@comment = comment

    if comment.resource.class.method_defined?(:creator)
    	if comment.resource.creator
        if comment.resource.creator.fc_permissions?
    		  mail(:to => "#{comment.resource.creator.email}", :subject => "#{comment.author.name} has commented on a #{comment.resource_type} you created", :from => "jacob@spylight.com")
        else
          return
        end
    	else
    		return
    	end
    else
      return
    end
  end

  def fc_complete(episode)
  	@episode = episode
  	mail(:to => "aly@spylight.com, april@spylight.com", :subject => "An Episode has been marked as complete", :from => "jacob@spylight.com")
  end

  def as_complete(episode)
  	@episode = episode
  	mail(:to => "aly@spylight.com, april@spylight.com", :subject => "An Episode has been marked as complete", :from => "jacob@spylight.com")
  end

  def question_asked(question)
    @question = question
    mail(:to => "aly@spylight.com, april@spylight.com, rebbs92@gmail.com", :subject => "A new question has been asked", :from => "jacob@spylight.com")
  end
end
