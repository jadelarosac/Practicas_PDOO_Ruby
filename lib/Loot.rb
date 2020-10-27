#encoding:utf-8

require_relative 'LootToUI'
  
module Deepspace

  # Esta clase representa el botín que se obtiene al vecer a una nave enemiga

  class Loot
    
    # Constructor con 5 parámetros:
    # - Número de suministros
    # - Número de armas
    # - Número de escudos
    # - Número de hangares
    # - Número de medallas

    def initialize(nsupplies, nweapons, nshields, nhangars, nmedals, eff = false, city = false)
      if !argumentos_correctos?(nsupplies, nweapons, nshields, nhangars, nmedals, eff, city)
        raise ArgumentError.new("Error en los argumentos de Loot")
      end
      @nSupplies = nsupplies
      @nWeapons = nweapons
      @nShields = nshields
      @nHangars = nhangars
      @nMedals = nmedals
      @efficient = eff
      @spaceCity = city
    end

    # Comprobaciones relativas a los parámetros
    
    def argumentos_correctos?(nsupplies, nweapons, nshields, nhangars, nmedals, eff, city)
      if not nsupplies_correcto?(nsupplies)
        resultado = false
      elsif not nweapons_correcto?(nweapons)
        resultado = false
      elsif not nshields_correcto?(nshields)
        resultado = false
      elsif not nhangars_correcto?(nhangars)
        resultado = false
      elsif not nmedals_correcto?(nmedals)
        resultado = false
      elsif not efficient_correcto?(eff)
        resultado = false
      elsif not city_correcto?(city)
        resultado = false
      else
        resultado = true
      end
      resultado
    end
    
    def city_correcto?(city)
      city.is_a?(FalseClass) or city.is_a?(TrueClass)
    end
    
    def efficient_correcto?(eff)
      eff.is_a?(FalseClass) or eff.is_a?(TrueClass)
    end

    def nsupplies_correcto?(nsupplies)
      if not nsupplies.is_a? Integer
        resultado = false
      elsif not nsupplies >= 0
        resultado = false
      else
        resultado = true
      end
      resultado
    end

    def nweapons_correcto?(nweapons)
      if not nweapons.is_a? Integer
        resultado = false
      elsif not nweapons >= 0
        resultado = false
      else
        resultado = true
      end
      resultado
    end
    
    def nshields_correcto?(nshields)
      if not nshields.is_a? Integer
        resultado = false
      elsif not nshields >= 0
        resultado = false
      else
        resultado = true
      end
      resultado
    end

    def nhangars_correcto?(nhangars)
      if not nhangars.is_a? Integer
        resultado = false
      elsif not nhangars >= 0
        resultado = false
      else
        resultado = true
      end
      resultado
    end

    def nmedals_correcto?(nmedals)
      if not nmedals.is_a? Integer
        resultado = false
      elsif not nmedals >= 0
        resultado = false
      else
        resultado = true
      end
      resultado
    end
    
    # Método que devuelve un string con información del estado para depurar
    
    def to_s
      resultado =  "nSupplies = #{@nSupplies}\t"
      resultado += "nWeapons = #{@nWeapons}\t"
      resultado += "nShields = #{@nShields}\t"
      resultado += "nHangars = #{@nHangars}\t"
      resultado += "nMedals = #{@nMedals}\t"
      resultado += "eficient = #{@efficient}\t"
      resultado += "spaceCity = #{@spaceCity}"
      resultado
    end
    
    # Devuelve una interfaz de usuario
    
    def getUIversion
      LootToUI.new(self)
    end

    # Consideraciones de visibilidad
    
    private :nmedals_correcto?, :nhangars_correcto?
    private :nweapons_correcto?, :nsupplies_correcto?
    private :argumentos_correctos?
    private :efficient_correcto?, :city_correcto?
    
    # Consultores de los atributos

    attr_reader :nSupplies, :nWeapons, :nShields, :nHangars, :nMedals
    
    def nSupplies
      @nSupplies.clone
    end
    
    def nWeapons
      @nWeapons.clone
    end
    
    def nShields
      @nShields.clone
    end
    
    def nHangars
      @nHangars.clone
    end
    
    def nMedals
      @nMedals.clone
    end
    
    def efficient
      @efficient.clone
    end
    
    def spaceCity
      @spaceCity.clone
    end
    
    # Devuelve una copia del objeto
    
    def clone
      self.class.new(@nSupplies, @nWeapons, @nShields, @nHangars, @nMedals, @efficient, @spaceCity)
    end

  end

=begin
  #pruebas
  recompensa = Loot.new(1,2,3,4,5)
  recompensa3 =Loot.new(5,4,3,2,1, true, true)
  recompensa2 = recompensa.clone 
  puts recompensa.nSupplies
  puts recompensa.nWeapons
  puts recompensa.nShields
  puts recompensa.nHangars
  puts recompensa.nMedals
  puts recompensa.efficient
  puts recompensa.spaceCity
  puts recompensa2
  puts recompensa3
=end
  
end
