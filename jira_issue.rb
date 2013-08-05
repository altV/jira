require './api_helper'
require 'active_support/all'

class JiraIssue
  # TODO: initialize custom fields with reasonable names
  # how to initialize custom fields
  # ApiHelper.query("/rest/api/2/field").select{|e| e['id'][/^custom.*/]} .each do |e| puts "#{e['id']} = #{e['name'].gsub(' ', '_').gsub("#","").gsub("/","").gsub("(","").gsub(")","").underscore}" end
  #

  def team
    @ids_team = %w(igammel slyubimov rdanilin maksarin aandreev nmamkina)
    @pwa_team = %w(lkovnatskiy amamon nsamokhin atitov)
    @mat_team = %w(agrishin agolenkovskiy)

    @ids_team.concat @pwa_team.concat @mat_team
  end



  attr_accessor :summary,
                :customfield_12700,
                :issuetype,
                :id,
                :description,
                :iconUrl,
                :name,
                :subtask,
                :customfield_14300,
                :timespent,
                :reporter,
                :name,
                :emailAddress,
                :avatarUrls,
                :displayName,
                :active,
                :customfield_12100,
                :customfield_14200,
                :customfield_12101,
                :customfield_13800,
                :customfield_14202,
                :customfield_14201,
                :updated,
                :created,
                :priority,
                :description,
                :customfield_14900,
                :issuelinks,
                :customfield_11908,
                :customfield_14906,
                :customfield_14907,
                :customfield_11402,
                :customfield_11503,
                :status,
                :description,
                :iconUrl,
                :name,
                :id,
                :customfield_11504,
                :customfield_12200,
                :customfield_11501,
                :labels,
                :workratio,
                :customfield_12300,
                :project,
                :avatarUrls,
                :environment,
                :customfield_13400,
                :aggregateprogress,
                :total,
                :customfield_11600,
                :components,
                :timeoriginalestimate,
                :customfield_13300,
                :customfield_14422,
                :customfield_14509,
                :customfield_14508,
                :customfield_14507,
                :customfield_14506,
                :customfield_14505,
                :customfield_14504,
                :votes,
                :customfield_10403,
                :fixVersions,
                :resolution,
                :resolutiondate,
                :customfield_13500,
                :customfield_10203,
                :aggregatetimeoriginalestimate,
                :customfield_10204,
                :customfield_11401,
                :customfield_11400,
                :customfield_12400,
                :duedate,
                :watches,
                :customfield_11500,
                :customfield_10603,
                :assignee,
                :customfield_14538,
                :customfield_10201,
                :customfield_10200,
                :aggregatetimeestimate,
                :versions,
                :customfield_10400,
                :timeestimate,
                :customfield_14500,
                :customfield_10300,
                :customfield_14501,
                :customfield_14502,
                :customfield_14400,
                :customfield_14503,
                :aggregatetimespent

  def initialize args = nil
    if args == nil then
      return
    end
    args.each do |key, value|
      instance_variable_set :"@#{key}", value
    end
  end


  def overdue?
    duedate != nill && Time.parse(duedate) < Time.now
  end

  def jql_base
    JSON.parse(description)["JQL"]
  end

  def total_issues_count
    if @total_issues_count == nil then
      @total_issues_count = ApiHelper.issues_count_by_query("#{jql_base}")
    end
    @total_issues_count
  end

  def total_resolved_issues_count
    if @total_resolved_issues_count == nil
      @total_resolved_issues_count = ApiHelper.issues_count_by_query("#{jql_base} and resolution != unresolved")
    end
    @total_resolved_issues_count
  end

  def total_unresolved_issues_count
    if @total_unresolved_issues_count == nil then
      @total_unresolved_issues_count = ApiHelper.issues_count_by_query("#{jql_base} and resolution = unresolved")
    end
    @total_unresolved_issues_count
  end

  def week_resolved_issues_count
    if @this_week_resolved_issues_count == nil then
      @this_week_resolved_issues_count = ApiHelper.issues_count_by_query("#{jql_base} and resolution != unresolved and resolutiondate >= '#{start_of_week}'")
    end
    @this_week_resolved_issues_count
  end

  def week_resolved_issues
    if @this_week_resolved_issues == nil then
      @this_week_resolved_issues = ApiHelper.issues_by_query(:jql => "#{jql_base} and resolution != unresolved and resolutiondate >= '#{start_of_week}'",
      :fields => 'key,type,comments', :expand => 'comments'
      )
    end
  end

  def week_people_worked
    result = ""
    team.each do |username|
      count = ApiHelper.issues_count_by_query("#{jql_base} and resolution != unresolved and resolutiondate >= '#{start_of_week}' and status was Resolved by #{username} after '#{start_of_week}'")
      if count != 0 then
        result += "#{username}(#{count}), "
      end
    end
    result
  end

  def week_added_issues
    0
  end

  def start_of_week
    #Time.now.beginning_of_week
    Date.today.beginning_of_week.to_s
  end

  def end_of_week
    #Time.now.beginning_of_week
    Date.today.end_of_week.to_s
  end

end
