require_relative '../github'

namespace :github do

  desc "Fetch Projects from Github"
  task :fetch => :environment do

    # for SQL debugging:
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    username = ENV['GITHUB_USERNAME']
    unless username
      abort 'GITHUB_USERNAME not found in ENV'
    end

    token = ENV['GITHUB_API_TOKEN']
    unless token
      abort 'GITHUB_API_TOKEN not found in ENV'
    end

    github = GitHub.new(username, token)

    p "Fetching repos..."
    repos = github.repos

    unless repos.is_a?(Array) && repos.count == 100
      abort "Error fetching repos"
    end

    while (repos)
      puts "\n#{repos.count} repos fetched. Saving to database."
      repos.each do |repo|
        owner = begin
          github.user_info(repo['id'])['name']
        rescue StandardError => e
          puts e.message
          next
        end

        unless owner
          puts "Owner unavailable, skipping #{repo['full_name']}"
          next
        end

        num_stars = begin
          github.repo_info(repo['full_name'])['watchers_count']
        rescue StandardError =>  e # repo blocked
          puts e.message
          next
        end

        unless num_stars
          puts "num_stars unavailable, skipping #{repo['full_name']}"
          next
        end

        Project.new({
                        name: repo['full_name'],
                        owner: owner,
                        url: repo['html_url'],
                        num_stars: num_stars}).save
      end
    end
  end
end
