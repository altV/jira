require 'base64'
require 'faraday'
require 'json'
require 'time'
require 'ostruct'
require './api_helper'
require './report_task'
require './jira_issue'
require 'active_support/all'

api = ApiHelper
::DEBUG = true

search_results = api.issues_by_query('project = BWA AND resoluton = unresolved and issuetype = Task',"summary,key,description,duedate")
#is = JiraIssue.new

puts "search results: #{search_results}"

for _issue in search_results do # search_results.each do |issue|

  task = JiraIssue.new _issue["fields"]
  # puts Date.parse(issue.created).to_date

  puts " #{task.summary} jql_base: #{task.description}"
  puts "  This week progress: (#{task.start_of_week} - #{task.end_of_week}) "
  puts "     issues resolved: #{task.week_resolved_issues_count}"
  puts "       people worked: #{task.week_people_worked}"
  puts "        issues added: #{task.week_added_issues}"
  puts "       Week progress: #{task.week_resolved_issues_count * 100 / task.total_issues_count}%"

  puts "    Total statistics: "
  puts "        total issues: #{task.total_issues_count}"
  puts "     resolved issues: #{task.total_resolved_issues_count}"
  puts "   unresolved issues: #{task.total_unresolved_issues_count}"
  puts "    Overall Progress: #{task.total_resolved_issues_count * 100 / task.total_issues_count} %"

  #p Time.parse(issue["fields"]["duedate"]) if issue["fields"]["duedate"]
end





