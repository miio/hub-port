class UserRepoWorksController < ApplicationController

  def index
    @user_repo = UserRepo.find params[:user_repo_id]
    @user_repo_works = UserRepoWork.where(user_id: current_user, repo_id: @user_repo.repo.id).all
    @user_repo_work = UserRepoWork.new
  end

  def create
    param = params[:user_repo_work]
    user_repo = UserRepo.find params[:user_repo_id]
    args = { user: current_user, repo: user_repo.repo, path: param[:path] }
    UserRepoWork.create! args
    redirect_to cassius_spears_path
  end
end
