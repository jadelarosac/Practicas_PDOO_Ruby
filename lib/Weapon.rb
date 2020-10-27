#encoding:utf-8

require_relative 'WeaponType'
require_relative 'WeaponToUI'
  
module Deepspace

  # Esta clase representa a las armas de las que puede disponer una estación 
  # espacial para potenciar su energía al disparar.

  class Weapon
    def initialize(name, type, uses)
      if !argumentos_correctos?(name, type, uses)
        raise ArgumentError.new("Error en los argumentos de Weapon")
      end
      @name = name
      @type = type
      @uses = uses
    end
  

    # Constructor de copia
    
    def self.newCopy(old_one)
      new(old_one.name, old_one.type, old_one.uses)
    end
    
    # Consulta la potencia del arma
    
    def power
      @type.power
    end
    
    # Usar el arma. Decrementa en una unidad sus usos y devuelve la potencia
    
    def useIt
      if uses > 0
        @uses -= 1
        return power
      else
        return 1.0
      end
    end
    
     # Comprueba que los argumentos tengan el formato correcto
    def argumentos_correctos?(name, type, uses)
      if not name_correcto? name
        resultado = false
      elsif not type_correcto? type
        resultado = false
      elsif not uses_correcto? uses
        resultado = false
      else
        resultado = true
      end
      resultado
    end

    def name_correcto?(name)
      name.is_a? String
    end
    
    def type_correcto?(type)
      type.is_a? WeaponType::Type
    end
    
    def uses_correcto?(uses)
      if not uses.is_a? Integer
        resultado = false
      elsif not uses >= 0
        resultado = false
      else
        resultado = true
      end
      resultado
    end
    
    # Con fines de depurar representamos como string el estado actual de la instancia
    
    def to_s
      resultado =  "name = #{@name}\t"
      resultado += "type = #{@type}\t"
      resultado +="uses = #{@uses}"
      resultado
    end
    
    # Obtenemos una interfaz de usuario
    
    def getUIversion
      WeaponToUI.new(self)
    end

    # Declaramos privados los métodos y atributos
    
    private :uses_correcto?, :type_correcto?, :name_correcto?
    private :argumentos_correctos?
    
    # Consultores seguros
    
    def name
      @name.clone
    end
    
    def type
      @type
    end
    
    def uses
      @uses.clone
    end
  
  end
  
=begin
  # Pruebas
  arma = Weapon.new("feo", WeaponType::MISSILE, 3)
  arma2 = Weapon.new("feo2", WeaponType::Type.new(10.0), 6)
  puts arma
  puts Weapon.newCopy(arma)
  puts String(arma2)
  puts arma.to_s
  puts arma.getUIversion
  puts arma.useIt
  puts arma
=end
end
