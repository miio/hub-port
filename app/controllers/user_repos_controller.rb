class UserReposController < ApplicationController

  def index
   repo = Repo.find 7737178
   working = WorkingRepo.new current_user, repo.owner, repo
   working.issue_number = 2
   working.commit "filename", "", "Grit test for hub port"
   working.push
   working.create_pull_request
  end

  def create
    param = params[:user_repo]
    repo = Repo.find param[:repo_id]
    args = {user: current_user, repo: repo}
    UserRepo.create! args
    
    WorkingRepo.new current_user, repo.owner, repo
    
    redirect_to cassius_spears_path
  end

end
