require "./api_helper"

# Report task
class ReportTask

  def initialize(jira_issue = nil)
    debug "[debug] > jira_issue = " + jira_issue.to_s
    @name = jira_issue == nil ? "" : jira_issue['fields']['summary']
    @description = jira_issue == nil ? "" : jira_issue['fields']['summary']
    @key = jira_issue == nil ? "" : jira_issue['key']
    @progress = 0
    @participants = []
    @reporting_data = jira_issue != nil ? jira_issue["reporting_data"] : nil
    @this_week_progress = build_this_week_progress
  end


  def build_this_week_progress
    jql = @reporting_data["JQL"]
    # got complete list of issues
    issues = ApiHelper.issues_by_query(jql, "key,status")

    # checking transitions
    issues.each do |issue|
      ApiHelper.issue_by_key(issue["key"], "transitions")
    end


    issues.to_s
  end

  def to_s
    s = "[#{@key}] : #{@name}\n\tThis week progress:\n" + @this_week_progress
    s
  end

end