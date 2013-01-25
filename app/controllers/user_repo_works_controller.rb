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

  def show
    auth = Authentication.find current_user.id
    github = Github.new oauth_token: auth.access_token
    @user_repo = UserRepo.find params[:user_repo_id]
    @user_repo_work = UserRepoWork.find params[:id]
    @issues = github.issues.list user: @user_repo.repo.owner, repo: @user_repo.repo.name
  end

  def push
    @user_repo = UserRepo.find params[:user_repo_id]
    @user_repo_work = UserRepoWork.find params[:user_repo_work][:id]
    repo = Repo.find @user_repo.repo
    working = WorkingRepo.new current_user, repo.owner, repo
    unless params[:issue].empty?
      working.issue_number = params[:issue]
    end

    # upload path
    upload_path = "#{working.work_path}#{@user_repo_work.path}"
    # create path
    FileUtils.mkdir_p(upload_path) unless FileTest.exist?(upload_path)

    blob = BlobUploader.new upload_path
    blob.store! params[:user_repo_work][:blob]

    working.commit params[:user_repo_work][:blob].original_filename, @user_repo_work.path, params[:message]
    working.push
    unless params[:issue].empty?
      working.create_pull_request
    end
    redirect_to cassius_spears_path
  end
end
