#encoding:utf-8

module Deepspace

  # Este módulo representa los tipos de armas

  module WeaponType

      # Definimos la clase tipo.
      #  Las armas serán instancias de la clase tipo
      
      POTENCIALASER = 2.0
      POTENCIAPLASMA = 3.0
      POTENCIAMISSILE = 4.0

      class Type
        
        def initialize(power)
          @power = power
        end
        
        attr_reader :power
        
        
        def to_s
        if self == LASER #self.power == POTENCIALASER
          resultado = "LASER"
        elsif self == PLASMA #self.power == POTENCIAPLASMA
          resultado = "PLASMA"
        elsif self == MISSILE #self.power == POTENCIAMISSILE
          resultado = "MISSILE"
        else
          resultado = "Arma desconocida con potencia "  + String(self.power)
        end
        resultado
        end
      end
      

      # Láser, el arma más débil
      LASER = Type.new(POTENCIALASER)
      # Misil, arma intermedia
      MISSILE = Type.new(POTENCIAPLASMA)
      # Plasma, el arma más poderosa
      PLASMA = Type.new(POTENCIAMISSILE)
      
  end
=begin
  #Algunas pruebas
  pistola = WeaponType::Type.new(7)
  puts pistola
  puts WeaponType::LASER
=end
  
end


