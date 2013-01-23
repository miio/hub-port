class WorkingRepo
  REPO_PATH = "#{Rails.root}/user_repos/"

  def initialize user, repo
    @user = user
    @repo = repo
    remote_addr = "git@github.com:#{self.repo.owner}/#{self.repo.name}.git"
    clone_args = {quiet: false, verbose: true, progress: true, branch: 'master'}
    @grit = self.create_or_open "#{REPO_PATH}/#{self.repo.owner}/#{self.repo.name}/", remote_addr, clone_args
  end

  def issue_number= issue_number
    @issue_number = issue_number
    @grit.git.pull
    Dir.chdir(@grit.working_dir) { system("git -b #{self.branch_prefix}#{issue_number} master") }
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
    Dir.chdir(@grit.working_dir) { system("git push origin #{self.branch_prefix}#{@issue_number}:master") }
  end

  def rebase
    Dir.chdir(@grit.working_dir) { system("git -b #{self.branch_prefix}#{@issue_number} master") }

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
    @grit.commit_index(message)
  end

  def create_pull_request
    
  end

  def clear_working

  end

  def branch_prefix
    "issue/"
  end

  def work_path
    "#{REPO_PATH}/#{self.repo.owner}/#{self.repo.name}/"
  end

end
