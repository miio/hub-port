class WorkingRepo
  REPO_PATH = "#{Rails.root}/user_repos/"

  COMMIT_WITH_ISSUE_NUMBER = true
  PULL_REQUEST_COPY_ISSUE = true
  PULL_REQUEST_COPY_ISSUE_PREFIX = "develop "
  PULL_REQUEST_COPY_ISSUE_SUFFIX = ""
  def initialize user, owner, repo
    @user = user
    @owner = owner
    @repo = repo
    #TODO set user rsa keys
    remote_addr = "git@github.com:#{@repo.owner}/#{@repo.name}.git"
    clone_args = {quiet: false, verbose: true, progress: true, branch: 'master'}
    @grit = self.create_or_open "#{self.work_path}", remote_addr, clone_args
  end

  def issue_number= issue_number
    @issue_number = issue_number
    @grit.git.pull
    Dir.chdir(@grit.working_dir) { system("git checkout -b #{self.branch_name} master") }
  end

  def create_or_open path, remote_addr, args, is_bare = false
    begin
      return Grit::Repo.new path, is_bare: is_bare
    rescue
      if is_bare
        git = Grit::Repo.init_bare(path)
        git.git.add_remote(:origin, remote_addr)
        git.git.fetch remote_addr
      else
        git = Grit::Git.new path
        git.clone(
          args, remote_addr, path
        )
      end
      return Grit::Repo.new path, is_bare: is_bare
    end
  end

  def push
    Dir.chdir(@grit.working_dir) { system("git push origin #{self.branch_name}:#{self.branch_name}") }
  end

  def delete_branch
    Dir.chdir(@grit.working_dir) { system("git branch -D #{self.branch_name}") }
  end

  def rebase
    Dir.chdir(@grit.working_dir) { system("git rebase #{self.branch_name} master") }
  end

  def commit file_name, file_path, message
    @grit.git.pull
    file_name = 'test1.txt'
    file_path = "#{self.work_path}#{file_path}#{file_name}"
    File.open(file_path, 'ab+') { |f| f << 'Committed using Grit' }

    # git add & git commit!
    blob = Grit::Blob.create(
      @grit, { name: file_name, data: File.read(file_path) }
    )
    Dir.chdir(@grit.working_dir) { @grit.add(blob.name) }
    if COMMIT_WITH_ISSUE_NUMBER
      message = "refs ##{@issue_number} #{message}"
    end
    @grit.commit_index(message)
  end

  def create_pull_request title = ""
    github = Github.new oauth_token: @user.profile.access_token
    begin
      pull_req = github.pull_requests.get @repo.owner, @repo.name, @issue_number
    rescue
      if PULL_REQUEST_COPY_ISSUE
        issue = github.issues.get @repo.owner, @repo.name, @issue_number
        title = "#{PULL_REQUEST_COPY_ISSUE_PREFIX}#{issue.title}#{PULL_REQUEST_COPY_ISSUE_SUFFIX}"
      end
      pull_reqs = github.pull_requests.list @repo.owner, @repo.name
      link_branches = pull_reqs.map {|i| i.head.ref}
      unless link_brnches.include?("#{self.branch_name}")
        github.pull_requests.create(@repo.owner, @repo.name,
                                    title: title,
                                    head: "#{user.profile.screen_name}:#{self.branch_name}",
                                    base: "master"
                                   )
      end
    end
  end

  def clear_working
    Dir.chdir(@grit.working_dir) { system("git reset --hard") }
  end

  def branch_prefix
    "issue/"
  end

  def branch_name
    "#{self.branch_prefix}#{@issue_number}"
  end

  def work_path
    "#{REPO_PATH}/#{@user.profile.screen_name}/#{@repo.owner}/#{@repo.name}/"
  end

end
