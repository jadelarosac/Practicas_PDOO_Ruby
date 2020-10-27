#encoding:utf-8

require_relative 'Damage'
require_relative 'SpecificDamageToUI'


module Deepspace
  class SpecificDamage < Damage
    
    # Constructor con el número de armas y escudos que perder
    
    def initialize(weapons, nShields)
      if not argumentos_correctos?(weapons, nShields)
        raise ArgumentError.new("Error en los argumentos de SpecificDamage")
      end
      super(nShields)
      @weapons = weapons
    end
    
    # Método que copia el daño
    
    def copy
      self.class.new(self.weapons, self.nShields)
    end
    
    # Reduce @nWeapons y @nShields para que no sean mayor que w y s
    
    def adjust(w, s)
      newWeapons = Array.new
      copyW = Array.new(w)
      @weapons.each do |tipo|
        index = arrayContainsType(copyW, tipo)
        if index >= 0
          newWeapons.push(copyW.delete_at(index).type)
        end
      end
      newNShields = [s.size, @nShields].min
      self.class.new(newWeapons, newNShields)
    end
    
    
    # Método que devuelve el índice en el que el array de armas w contiene un
    # arma de tipo t. Si no la contiene, devuelve -1
    
    def arrayContainsType(w, t)
      tipos = Array.new
      w.each{ |weapon| tipos.push(weapon.type) }
      salida = tipos.find_index(t)
      if salida != nil
        return salida
      else
        return -1
      end
    end
    
    # Descarta el arma w de la lista de armas @weapons
    
    def discardWeapon(w)
      found = false
      @weapons.reject!{|i| found = true if !found && i == w}
    end
    
    
    # Determina si el daño tiene efecto o no
    
    def hasNoEffect
      super and @weapons.empty?
    end
    
    
    
    # Comprueba que los parámetros son correctos
    
    def argumentos_correctos?(w, s)
      if not super s
        resultado = false
      elsif not weapons_correcto? w
        resultado = false
      else
        resultado = true
      end
      resultado
    end
    
    # Comprueba si la lista de armas es correcta
    
    def weapons_correcto?(wl)
      if wl.is_a? Array
        return wl.all? { |w| w.is_a? (WeaponType::Type)  }
      end
      false
    end
    
    # Devuelve una interfaz de usuario
    
    def getUIversion
      SpecificDamageToUI.new(self)
    end
    
    # Crea un string con los datos de la instancia, con objetivos de depuración
    
    def to_s
      resultado = super
      resultado += "\tArmas: #{[@weapons.join(", ")]}"
      resultado
    end
    
    public_class_method :new
    private :weapons_correcto?, :argumentos_correctos?
    
    # Consultores seguros
    
    def weapons
      @weapons.clone
    end
    
    # Devuelve una copia del objeto
    
    def clone
      self.copy
    end
    
    
    
=begin
    #pruebas
    D = SpecificDamage.new([WeaponType::LASER, WeaponType::MISSILE, WeaponType::MISSILE], 5)
    A = D.copy
    puts D
    A.discardWeapon(WeaponType::MISSILE)
    D.discardShieldBooster
    puts D
    puts A
    puts D.hasNoEffect
    puts SpecificDamage.new([],0).hasNoEffect
    puts D.getUIversion
    B = A.adjust([WeaponType::MISSILE],1)
    puts A
    puts B
=end
    
  end
end
