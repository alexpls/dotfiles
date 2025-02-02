#!/usr/bin/env ruby

require 'json'

gh_output = `gh search prs --author=@me --state=open --json 'isDraft,number,repository,state,title,url'`
prs = JSON.parse(gh_output)

return if prs.count.zero?

puts "#{prs.count} PRs"

prs
  .group_by { |p| p["repository"]["name"] }
  .each do |repo, prs|
    puts "---"
    puts repo
    prs.each do |pr|
      puts "#{pr["title"]} | href=#{pr["url"]}"
    end
  end

