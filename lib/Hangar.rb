#encoding:utf-8

require_relative 'HangarToUI'
require_relative 'Weapon'
require_relative 'ShieldBooster'

module Deepspace
  
  # Esta clase representa el hangar de una estación espacial
  
  class Hangar
    
    # Constructor de un hangar al que se le pasa la capacidad como parámetro
    
    def initialize(capacity)
      if !maxElements_correcto?(capacity)
        raise ArgumentError.new("Error en los argumentos de Hangar")
      end
      @maxElements = capacity
      @weapons=Array.new()
      @shieldBoosters=Array.new()
    end
    
    # Comprobaciones de que todos los parámetros son correctos
    
    def maxElements_correcto?(maxElements)
      if not maxElements.is_a? Integer
        resultado = false
      elsif not maxElements >= 0
        resultado = false
      else
        resultado = true
      end
      resultado
    end
    
    # Constructor de copia
    
    def self.newCopy(h)
      new(h.maxElements)
    end
    
    # Devuelve si queda espacio disponible en el hangar
    
    def spaceAvailable
      maxElements > @weapons.size + @shieldBoosters.size
    end
    
    # Añade un arma al hangar, con las comprobaciones necesarias para ello
    
    def addWeapon(w)
      if ! w.is_a? Weapon
        raise ArgumentError.new("Error al añadir un arma al Hangar")
      end
      if spaceAvailable
        @weapons.push(w)
        return true
      else
        return false
      end
    end
    
    # Añade un potenciador de escudo al hangar, con las comprobaciones 
    # pertinentes
    
    def addShieldBooster(s)
      if ! s.is_a? ShieldBooster
        raise ArgumentError.new("Error al añadir un potenciador de escudo al Hangar")
      end
      if spaceAvailable
        @shieldBoosters.push(s)
        return true
      else
        return false
      end
    end
    
    # Elimina el s-ésimo potenciador de escudo
    
    def removeShieldBooster(s)
      if s.between?(0, @shieldBoosters.size)
        elemento = @shieldBoosters.at(s)
        @shieldBoosters.delete_at(s)
      end
      elemento
    end
    
    # elimina el w-ésimo potenciador de escudo
    
    def removeWeapon(w)
      if w.between?(0, @weapons.size)
        elemento = @weapons.at(w)
        @weapons.delete_at(w)
      end
      elemento
    end
    
    # Devuelve una interfaz de usuario
    
    def getUIversion
      HangarToUI.new(self)
    end
    
    # Representación de una instancia como string, con fines de depuración
    
    def to_s
      resultado = "maxElements = #{@maxElements}\t"
      resultado +="weapons = [#{@weapons.join(", ")}]\t"
      resultado +="shields = [#{@shieldBoosters.join(", ")}]"
      resultado
    end
    
    # Consideraciones relativas a la visibilidad
    
    private :maxElements_correcto?, :spaceAvailable
    
    # Consultores seguros
  
    def maxElements
      @maxElements.clone
    end
    
    def weapons
      @weapons.clone
    end
    
    def shieldBoosters
      @shieldBoosters.clone
    end
    
    
  end
  
=begin
  #pruebas
  A = Hangar.new(2)
  w =  Weapon.new("fea", WeaponType::LASER, 3)
  w2 = Weapon.new("másfea", WeaponType::MISSILE, 5)
  puts A.addShieldBooster(ShieldBooster.new "guapo", 4, 50)
  puts A.addShieldBooster(ShieldBooster.new "másguapo", 4.3, 5)
  
  puts w
  
  
  puts A.addWeapon(w)
  puts A.addWeapon(w2)
  puts A.addWeapon(w)
  puts A
  puts A.removeWeapon(1)
  puts A
  puts A.removeWeapon(1)
  puts A
  
  B = Hangar.new(4)
  puts B.addWeapon(Weapon.new "feilla", WeaponType::PLASMA, 4)
  puts B.addWeapon(Weapon.new "feísima", WeaponType::PLASMA, 4)
  puts B.addShieldBooster(ShieldBooster.new "guapillo", 4, 5)
  puts B.addShieldBooster(ShieldBooster.new "guapísimo", 4.3, 5)
  puts B.maxElements
  puts B.weapons
  puts B.shieldBoosters
=end

end
