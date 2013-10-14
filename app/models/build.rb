class Build < ActiveRecord::Base
  scope :completed, -> { where('completed_at is not null') }
  
  belongs_to :project

  after_create :queue_build

  validates :branch_name, :presence => true

  def queue_build
    build = Build.find(id)
    build.started_at = DateTime.now
    build.save
    
    #start queueing
    RedisHandler.perform_async(id) 
  end 
end
