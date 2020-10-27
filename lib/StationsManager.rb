#encoding:utf-8

require 'singleton'
require_relative 'SpaceStation'

module Deepspace
  class StationsManager
    
    include Singleton
    
    def initialize
      @stations=[]
      @currentStationIndex=-1
    end

    def add(station)
      @stations<<station
    end
    
    def size
      @stations.size
    end

    def setFirstStation(i)
      if ((i>=0)&&(i<@stations.length))
        @currentStationIndex=i
        @stations[@currentStationIndex]
      end
    end

    def nextStation
      @currentStationIndex=(@currentStationIndex+1)%@stations.size
      @stations[@currentStationIndex]
    end

    # Se informa al manager de una transformación
    def transformCurrentStation(new_station)
      @stations[@currentStationIndex]=new_station
    end

    #Estos métodos son para las ciudades
    def getCollaboratorIndices
      result = Array.new(@stations.size){ |elem| elem = elem  } # Todos los índices
      result.delete(@currentStationIndex) # Quitamos el de la estación actual
      result
    end

    def get(i)
      if ((i>=0)&&(i<@stations.length))
        @stations[i]
      end
    end

  end
end
