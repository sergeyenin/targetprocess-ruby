module TargetProcess
  class TargetProcess::RequestHistory
    include TargetProcess::Base
    belongs_to :entity_state
    belongs_to :modifier, 'GeneralUser'
    belongs_to :request

  end
end
