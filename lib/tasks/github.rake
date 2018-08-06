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
    while (repos)
      next_repo_page = client.last_response.rels[:next]
      puts "\n#{repos.count} repos fetched. Saving to database."
      repos.each do |repo|
        owner = begin
          client.user(repo.id).name
        rescue
          'unknown'
        end

        num_stars = begin
          client.repository(repo.full_name).watchers_count
        rescue # repo blocked
          next
        end

        Project.new({
                        name: repo.full_name,
                        owner: owner,
                        url: repo.html_url,
                        num_stars: num_stars}).save
      end
      repos = next_repo_page ? next_repo_page.get.data : nil
    end
  end
end
