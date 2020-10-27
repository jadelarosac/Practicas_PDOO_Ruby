#encoding:utf-8

require_relative 'StationsManager'
require_relative 'SpaceCityToUI'

module Deepspace
  class SpaceCity < SpaceStation
    
    # Constructor con la base original y una referencia a StationsManager
    
    def initialize(base, manager)
      if not base_correcto?(base)
        raise ArgumentError.new("Error en los argumentos de SpaceCity")
      end
      @base = base
      @collaborators = manager.getCollaboratorIndices
      @manager = manager
      super(base.name)
      completeStation(base)
    end
    
    # Toma el loot y lo inserta en la ciudad
    
    def setLoot(loot)
      super
      Transformation::NOTRANSFORM
    end
    
    # Usa todas las armas montadas y devuelve
    # el producto de su potencia por el producto de la potencia
    # de fuego de todos los colaboradores
    
    def fire
      factor = super
      @collaborators.each{ |i| factor += @manager.get(i).fire }
      factor
    end
    
    # Usa todos los potenciadores de escudo
    # montados y devuelve
    # el producto de su potencia por el producto de la potencia 
    # de todos los colaboradores
    
    def protection
      factor = super
      @collaborators.each{ |i| factor += @manager.get(i).protection }
      factor
    end
    
    def receiveShot(shot)
      result = super
      @shieldPower = [@shieldPower, 0.0].max
      result
    end
    
    # Comprueba que los argumentos sean correctos
    
    def base_correcto?(base)
      base.is_a? SpaceStation
    end
    
    # Devuelve una interfaz de usuario
    
    def getUIversion
      SpaceCityToUI.new(self)
    end
    
    # Para depurar, devuelve un string con información sobre los atributos
    
    def to_s
      self.getUIversion.to_s
    end
    
    private :base_correcto?
    attr_reader :collaborators, :manager
    
  end
  
  
=begin
  H = SpaceStation.new("Bespin, la ciudad de las nubes", SuppliesPackage.new(3,4,5))
  E = SpaceStation.new("Enterprise", SuppliesPackage.new(4,4,4))
  manager = StationsManager.instance
  manager.add(H)
  manager.add(E)
  manager.setFirstStation(0)
  manager.getCollaboratorIndices
  B = SpaceCity.new(H, manager)
  puts B
  puts B.fire
  puts manager.get(1)
=end
end
