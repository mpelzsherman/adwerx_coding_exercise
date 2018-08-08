require 'net/http'
require 'uri'
require 'json'

class GitHub
  attr_accessor :username, :token

  def initialize(username, token)
    @username = username
    @token = token
  end

  def fetch(url)
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(username, token)

    req_options = {
        use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end

  def repos
    fetch "https://api.github.com/repositories?fork=false&language%5B%5D=ruby&language%5B%5D=javascript&license%5B%5D=apache-2.0&license%5B%5D=gpl&license%5B%5D=lgpl&license%5B%5D=mit&order=desc&pushed=%3E2018-08-07T00%3A15%3A04-04%3A00&sort=stars&stars=1..2000"
  end

  def repo_info(repo_name)
    fetch "https://api.github.com/repos/#{repo_name}"
  end

  def user_info(id)
    fetch "https://api.github.com/user/#{id}"
  end
end
