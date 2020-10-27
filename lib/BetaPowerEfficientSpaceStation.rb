#encoding:utf-8

require_relative 'PowerEfficientSpaceStation'
require_relative 'Dice'

module Deepspace
  class BetaPowerEfficientSpaceStation < PowerEfficientSpaceStation
    
    @@EXTRAEFFICIENCY = 1.2
    
    def initialize(station)
      super(station)
      @dice = Dice.new
    end
    
    def fire
      if @dice.extraEfficiency
        return @@EXTRAEFFICIENCY * super
      else
        return super
      end
    end
    
  end
  
=begin 
  # pruebas 
  H = SpaceStation.new("Halcón Milenario", SuppliesPackage.new(3,4,5))
  Ha = BetaPowerEfficientSpaceStation.new(H)
  puts Ha
  puts Ha.fire
=end
  
end
