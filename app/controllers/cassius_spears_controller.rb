class CassiusSpearsController < ApplicationController
  def show
    auth = Authentication.find current_user.id
    github = Github.new oauth_token: auth.access_token
    @repos = github.repos.list current_user.profile.screen_name
      Repo.transaction do
        @repos.each do | repo |
          elem = Repo.find_or_initialize_by_id repo.id
          args = { id: repo.id, name: repo.name, object: repo , owner: repo.owner.login , work_path: ""}
          elem.update_attributes args
          elem.save!
        end
    end
    @remote_repos = Repo.where(owner: current_user.profile.screen_name).all
    @remote_repos = Repo.all
    @user_repos = UserRepo.where(user_id: current_user.id).all
    @user_repo = UserRepo.new
    @repo = Repo.new
    #@branches = github.repos.branches 'miio', 'ggj2012'
    #@issues = github.issues.list user: 'miio', repo: 'ggj2012'
    #@pull_reqs = 
  end
end
