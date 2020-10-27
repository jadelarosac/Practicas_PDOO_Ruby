#encoding:utf-8

require_relative 'SpaceStation'
require_relative 'PowerEfficientSpaceStationToUI'


module Deepspace
  class PowerEfficientSpaceStation < SpaceStation
    
    @@EFFICENCYFACTOR = 1.10
    
    def initialize(station)
      if not station_correcto? (station)
        raise ArgumentError.new("Error en los argumentos de PowerEfficientSpaceStation")
      end
      super(station.name)
      completeStation(station)
    end
    
    def receiveShot(shot)
      result = super
      @shieldPower = [@shieldPower, 0.0].max
      result
    end
    
    # Toma el loot y lo inserta en la estacion
    
    def setLoot(loot)
      super
      if loot.efficient
        return Transformation::GETEFFICIENT
      else
        return Transformation::NOTRANSFORM
      end
    end
    
    # Usa todas las armas montadas y devuelve
    # el producto de su potencia por el producto de la potencia
    # de fuego por el factor de eficiencia
    
    def fire
      @@EFFICENCYFACTOR * super
    end
    
    # Usa todos los potenciadores de escudo
    # montados y devuelve
    # el producto de su potencia por el factor de eficiencia
    
    def protection
      @@EFFICENCYFACTOR * super
    end
    
    # Comprueba que los argumentos sean correctos
       
    
    def station_correcto?(base)
      base.is_a? SpaceStation
    end
    
    # Devuelve una interfaz de usuario
    
    def getUIversion
      PowerEfficientSpaceStationToUI.new(self)
    end
    
    # Para depurar, devuelve un string con información sobre los atributos
    
    def to_s
      self.getUIversion.to_s
    end
    
    private :station_correcto?
    
  end
end
