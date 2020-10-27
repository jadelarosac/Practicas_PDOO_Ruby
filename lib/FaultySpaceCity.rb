#encoding:utf-8

require_relative 'SpaceCity'
require_relative 'Dice'

module Deepspace
  class FaultySpaceCity < SpaceCity
    def initialize(base, manager)
      super
      @dice = Dice.new
    end
    
    def fire
      power = super
      if @dice.loseCollaborator
        index = @dice.whatCollaboratorLose(@collaborators)
        @collaborators = @collaborators.delete_at(index)
      end
      power
    end
    
  end
end
