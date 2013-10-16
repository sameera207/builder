class Git

  def initialize(project)
    @repo = Grit::Repo.new(project.local_path)
  end

  def branches
    @repo.branches.map{ |branch| branch.name } 
  end

end
