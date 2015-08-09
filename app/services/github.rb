class Github

  def initialize
    Octokit.auto_paginate = true
    @client = Octokit::Client.new login: ENV['GITHUB_USER'], password: ENV['GITHUB_PASSWORD']
  end

  def store_repos
    repos.each do |fetched_repo|
      repo = Repo.find_or_initialize_by(repo_id: fetched_repo.id)
      repo.repo_name = fetched_repo.name
      repo.owner_id = fetched_repo.owner.id
      repo.owner_name = fetched_repo.owner.login
      repo.save!

      begin
        @client.branches(fetched_repo.id).each do |fetched_branch|
          Branch.find_or_create_by(repo_id: fetched_repo.id, name: fetched_branch.name)
        end
      rescue
        puts "NO BRANCHES: #{fetched_repo.id}"
      end
    end
  end

  def store_yesterdays_commits
    Branch.all.each do |branch|
      repo = Repo.find_by(repo_id: branch.repo_id)
      commits = @client.commits(repo.repo_id, branch.name, author: 'johnthepink', since: DateTime.yesterday.iso8601)
      commits.each do |fetched_commit|
        commit = Commit.find_or_initialize_by(sha: fetched_commit.sha)
        commit.message = fetched_commit.commit.message
        commit.date_committed = fetched_commit.commit.committer.date
        commit.save!
      end
      puts "#{repo.repo_name}::#{branch.name}::#{commits.count}"
    end
    return nil
  end

  def repos
    @repos ||= @client.repos
  end

end
