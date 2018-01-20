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

# for i in 1..10 do
#   for j in 1..10 do
#     f = Follow.new
#     f[:user_id]=i
#     f[:follower_id]=j
#     f.save
#   end
# end

def run_thread
  HotRecommend.task
  TagRecommend.task
end
