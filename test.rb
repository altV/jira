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


puts api.issues_by_query("project = IDS AND 'Bundle/Project' in cascadeOption(10000, 13818)", "key,type,summary")



