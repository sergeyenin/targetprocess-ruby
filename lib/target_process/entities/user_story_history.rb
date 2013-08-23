module TargetProcess
  class UserStoryHistory < Base
    belongs_to :entity_state
    belongs_to :modifier, 'GeneralUser'
    belongs_to :user_story
  end
end
