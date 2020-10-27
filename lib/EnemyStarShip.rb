#encoding:utf-8

require_relative 'Loot'
require_relative 'Damage'
require_relative 'ShotResult'
require_relative 'EnemyToUI'

module Deepspace
  
  # Clase que representa una nave espacial enemiga
  
  class EnemyStarShip
    
    # Constructor con 5 parámetros que recibe:
    # - El nombre 
    # - La potencia de disparo 
    # - La potencia de escudo
    # - La recompensa que se recibe al derrotarla
    # - El daño que causa al derrotar a una estación
    
    def initialize(n, a, s, l, d)
      if not argumentos_correctos?(n, a, s, l, d)
        raise ArgumentError.new("Error en los argumentos de EnemyStarShip")
      end
      @name = n
      @ammoPower = a
      @shieldPower = s
      @loot = l
      @damage = d
    end
    
    # Constructor de copia
    
    def self.newCopy(e)
      new(e.name, e.ammoPower, e.shieldPower, e.loot, e.damage)
    end
    
    # Devuelve la potencia de escudo redirigiendo al consultor del método
    
    def protection
      shieldPower
    end
    
    # Devuelve la potencia de fuego redirigiendo al consultor del método
    
    def fire
      ammoPower
    end
    
    # Calcula dado un disparo shot si la nave enemiga resiste o no
    
    def receiveShot(shot)
      if @shieldPower < shot
        return ShotResult::DONOTRESIST
      else
        return ShotResult::RESIST
      end
    end
    
    # Comprobaciones de que los argumentos son correctos
    
    def argumentos_correctos?(n, a, s, l, d)
      if not name_correcto? n
        resultado = false
      elsif not ammopower_correcto? a
        resultado = false
      elsif not shieldpower_correcto? s
        resultado = false
      elsif not loot_correcto? l
        resultado = false
      elsif not damage_correcto? d
        resultado = false
      else
        resultado = true
      end
      resultado
    end
    
    def name_correcto? n
      n.is_a? String
    end
    
    def ammopower_correcto? a
      a.is_a? Numeric
    end
    
    def shieldpower_correcto? s
      s.is_a? Numeric
    end
    
    def loot_correcto? l
      l.is_a? Loot
    end
    
    def damage_correcto? d
      d.is_a? Damage
    end
    
    # Crea un string con los datos de la instancia, con objetivos de depuración
    
    
    def to_s
      resultado =  "Nombre: #{@name}\t"
      resultado += "Munición: #{@ammoPower}\t"
      resultado += "Escudo: #{@shieldPower}\t"
      resultado += "Recompensa: {#{@loot}}\t"
      resultado += "Daño: {#{@damage}}"
      resultado
    end
    
    # Devuelve una interfaz de usuario
    
    def getUIversion
      EnemyToUI.new(self)
    end
    
    # Especificaciones de visibilidad
    
    private :argumentos_correctos?, :name_correcto?
    private :ammopower_correcto?, :shieldpower_correcto?
    private :loot_correcto?, :damage_correcto?
    
    # Consultores seguros de los atributos
    
    def name
      @name.clone
    end
    
    def ammoPower
      @ammoPower.clone
    end
    
    def shieldPower
      @shieldPower.clone
    end
    
    def loot
      @loot.clone
    end
    
    def damage
      @damage.clone
    end
  end
  
=begin
  #pruebas
  E = EnemyStarShip.new("a",0.3,0.4,Loot.new(1,2,3,4,5),Damage.newNumericWeapons(2,3))
  puts E.fire
  puts E.protection
  puts E.name
=end

end
