class IssuePullRequestsController < ApplicationController
  def create
    auth = Authentication.find current_user.id
    github = Github.new oauth_token: auth.access_token
    param = params[:issue_pull_request]
    repo = Repo.find param[:repo]
    github.pull_requests.create(repo.owner, repo.name,
                                issue: param[:issue],
                                head: "#{repo.owner}:#{param[:branch]}",
                                base: "master"
                               )

  end
end
