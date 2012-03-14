#!/usr/bin/env ruby

require 'rubygems'
require 'twitter'

Username = ARGV.first || "michalvalasek"

def get_batch(page)
  begin
    batch = Twitter.user_timeline(Username,{:page=>page,:count=>200})
    puts "#{page}. Batch fetched"
    batch
  rescue Twitter::Error => err
    puts "Problem with fetching next batch: #{err}"
    retry
  end
end

archive_file = File.open("storage/#{Username}.txt",'a+')

fetched_tweets = 0
page = 1

puts
start_message = "Fetching tweets for user: #{Username}"
puts start_message
puts "=" * start_message.length

begin
  batch = get_batch(page)
  batch.each do |tweet|
    archive_file.puts "#{tweet.created_at}\n#{tweet.text}\n\n"
  end
  page += 1
  fetched_tweets += batch.size
end until batch.empty?

archive_file.close

end_message = "Fetched tweets: #{fetched_tweets}"
puts "=" * end_message.length
puts end_message