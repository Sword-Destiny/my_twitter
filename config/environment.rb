# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!


Thread.new {
  while true
    sleep(60)
    run_thread
  end
}


def run_thread
  HotRecommend.task
  TagRecommend.task
end
