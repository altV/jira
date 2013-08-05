require 'base64'
require 'faraday'
require 'json'

::DEBUG = false

def debug msg
  if ::DEBUG then
    puts "[debug] > #{msg}"
  end
end


class ApiHelper

  @username = ''
  @password = ''
  @encoded = Base64.encode64 @username + ":" + @password

  @conn = Faraday.new(:url => '', :ssl => {:verify => false}) do |f|
    f.request :url_encoded
    # f.response :logger
    f.adapter Faraday.default_adapter
  end

  class << ApiHelper

  def enrich(obj)
    puts "enriching >>>>> "
    description = obj['fields']['description']
    if description.index("{") != 0
      return obj
    end

    puts description
    if description != nil
      j = JSON.parse(description)
      puts j.to_s
      obj["reporting_data"] = j
    end

    # if JQL provided - will do search using JQL and append search results to 'child_issues'
    #if obj["reporting_data"]["JQL"] != nil
    #  puts "[debug] > looking for child issues using JQL : " + obj["reporting_data"]["JQL"]
    #  obj["reporting_data"]["child_issues"] = issues_by_query(obj["reporting_data"]["JQL"])
    #end

    puts "enriching >>>>> "
    obj
  end

  def issue_by_key(key, expand = "")
    enrich query('/rest/api/2/issue/'+key, {:expand => expand})
  end

  def issues_by_query(jql, fields = "*all", max_results=1000)
    query('/rest/api/2/search', {:jql => jql, :fields => fields, :maxResults => max_results})["issues"]
  end

  def issues_count_by_query(jql, fields = "key", max_results=1000)
    debug jql
    query('/rest/api/2/search', {:jql => jql, :maxResults => max_results})["total"]
  end


  def query(url, params = nil)
    debug url
    debug params
    response = @conn.get do |req|
      req.url url
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = 'Basic ' + @encoded
      if params != nil
        req.params = params
      end
    end
    debug "[debug] > " + response.body
    JSON.parse(response.body)
  end

  def test(url, params = nil)
    response = @conn.get do |req|
      req.url url
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = 'Basic ' + @encoded
      if params != nil
        req.params = params
      end
    end
    # puts response.body
    result = JSON.parse(response.body)
    puts result.to_s
    result
  end

  def json_to_tree(o, depth = 0)
    str = ""
    offset = ""
    depth.times do
      offset += "\t"
    end

    o.each do |key, value|
      if value.is_a?(::Hash)
        str += offset + key + " :\n" + json_to_tree(value, depth+1) + "\n"
      else
        str += offset +  key + " : " + value.to_s + "\n"
      end
    end
    str
  end

  end
end
