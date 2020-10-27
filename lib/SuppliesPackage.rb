#encoding:utf-8

module Deepspace

  # Esta clase representa un paquete de suministros para una estación espacial

  class SuppliesPackage
    def initialize(ammopower, fuelunits, shieldpower)
      if !argumentos_correctos?(ammopower, fuelunits, shieldpower)
        raise ArgumentError.new("Error en los argumentos de SuppliesPackage")
      end

      @ammoPower = ammopower
      @fuelUnits = fuelunits
      @shieldPower = shieldpower
    end

    attr_reader :ammoPower, :fuelUnits, :shieldPower

    def self.newCopy(old_one)
      new(old_one.ammoPower, old_one.fuelUnits, old_one.shieldPower)
    end


    # Comprueba que los argumentos tengan el formato correcto
    
    def argumentos_correctos?(ammopower, fuelunits, shieldpower)
      if not ammopower_correcto?(ammopower)
        resultado = false
      elsif not fuelunits_correcto?(fuelunits)
        resultado = false
      elsif not shieldpower_correcto?(shieldpower)
        resultado = false
      else
        resultado = true
      end
      resultado
    end

    def ammopower_correcto?(ammopower)
      ammopower.is_a? Numeric
    end

    def fuelunits_correcto?(fuelunits)
      if not fuelunits.is_a? Numeric
        resultado = false
      elsif not fuelunits >= 0.0
        resultado = false
      else
        resultado = true
      end
      resultado
    end

    def shieldpower_correcto?(shieldpower)
      shieldpower.is_a? Numeric
    end
    
    # Representa el estado de la estancia como un string, con fines de depuración
    
    def to_s
      resultado =  "ammoPower = #{@ammoPower}\t"
      resultado += "fuelUnits = #{@fuelUnits}\t"
      resultado +="shieldPower = #{@shieldPower}\t"
      resultado
    end
    
    # Consideraciones de visibilidad

    private :ammopower_correcto?, :fuelunits_correcto?, :shieldpower_correcto?
    private :argumentos_correctos?
    
    # Consultores seguros
    
    def ammoPower
      @ammoPower.clone
    end
    
    def fuelUnits
      @fuelUnits.clone
    end
    
    def shieldPower
      @shieldPower.clone
    end

  end

=begin
  #Pruebas
  s = SuppliesPackage.new(1.0,1.0,1.0)
  s2 = SuppliesPackage.newCopy(s)
  puts s
  puts s2
=end  
end