class ReposController < ApplicationController

  def show
    auth = Authentication.find current_user.id
    github = Github.new oauth_token: auth.access_token

    @repo = Repo.find params[:id]
    
    @branches = github.repos.branches @repo.owner, @repo.name
    @issues = github.issues.list user: @repo.owner, repo: @repo.name
    @issue_pull_request = IssuePullRequest.new
  end

  def create
    auth = Authentication.find current_user.id
    github = Github.new oauth_token: auth.access_token
    param = params[:repo]
    repo = github.repos.get param[:owner], param[:name]
    args = {id:repo.id, owner: param[:owner], name: param[:name]}
    Repo.create! args
redirect_to cassius_spears_path
  end
end
