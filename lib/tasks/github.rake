namespace :github do

  desc "Fetch Projects from Github"
  task :fetch => :environment do

    # For Github API query debugging
    # stack = Faraday::RackBuilder.new do |builder|
    #   builder.use Faraday::Request::Retry, exceptions: [Octokit::ServerError]
    #   builder.use Octokit::Middleware::FollowRedirects
    #   builder.use Octokit::Response::RaiseError
    #   builder.use Octokit::Response::FeedParser
    #   builder.response :logger
    #   builder.adapter Faraday.default_adapter
    # end
    # Octokit.middleware = stack

    # for SQL debugging:
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    token = ENV['GITHUB_API_TOKEN']
    unless token
      abort 'GITHUB_API_TOKEN not found in ENV'
    end

    client = Octokit::Client.new(access_token: token)
    # client.auto_paginate = true
    p "Fetching repos..."
    repos = client.all_repositories({
                                        pushed: ">#{DateTime.now - 1.day}",
                                        stars: 1..2000,
                                        fork: false,
                                        license: %w(apache-2.0 gpl lgpl mit),
                                        language: %w(ruby javascript),
                                        sort: 'stars',
                                        order: 'desc'
                                    })
    p "#{repos.count} repos fetched. Saving to database."
    repos.each do |repo|
      Project.new({
                      name: repo.full_name,
                      owner: client.user(repo.id).name,
                      url: repo.html_url,
                      num_stars: client.repository(repo.full_name).watchers_count}).save
    end
  end
end
