#encoding:utf-8

require_relative 'Damage'
require_relative 'Hangar'
require_relative 'SuppliesPackage'
require_relative 'SpaceStationToUI'
require_relative 'ShotResult'
require_relative 'Loot'
require_relative 'CardDealer'
require_relative 'Transformation'

module Deepspace
  
  # Clase que representa a las estaciones espaciales del juego
  
  class SpaceStation
    
    # Constantes que representan la cantidad máxima de combustible disponible y
    
    @@MAXFUEL = 100.0
    @@SHIELDLOSSPERUNITSHOT = 0.1
    
    # Constructor con dos parámetros, nombre y suministros
    
    def initialize(name, supplies = SuppliesPackage.new(0, 0, 0))
      if not argumentos_correctos?(name, supplies)
        raise ArgumentError.new("Error en los argumentos de SpaceStation")
      end
      @name = name
      @ammoPower = 0.0
      @fuelUnits = 0.0
      @nMedals = 0
      @shieldPower = 0.0
      @pendingDamage = nil
      @hangar = nil
      @weapons = Array.new()
      @shieldBoosters = Array.new()
      receiveSupplies supplies
    end
    
    # Constructor de copia
    
    def completeStation(old_one)
      @ammoPower = old_one.ammoPower
      @fuelUnits = old_one.fuelUnits
      @nMedals = old_one.nMedals
      @shieldPower = old_one.shieldPower
      @pendingDamage = old_one.pendingDamage
      @hangar = old_one.hangar
      @weapons = old_one.weapons
      @shieldBoosters = old_one.shieldBoosters
    end
    
    # Cambiamos la cantidad de combustible actual por el parámetro f
    
    def assignFuelValue f
      if not fuelunits_correcto? f
        raise ArgumentError.new("Error en el argumento de assignFuelValue de SpaceStation")
      end
      @fuelUnits = f
    end
    
    # Representa el daño pendiente
    
    def cleanPendingDamage
      if @pendingDamage != nil
        if @pendingDamage.hasNoEffect
          @pendingDamage = nil
        end
      end
    end
    
    # Añade el arma w al hangar
    
    def receiveWeapon w
      if @hangar == nil
        return false
      end
      @hangar.addWeapon w
    end
    
    # Añade el escudo s al hangar
    
    def receiveShieldBooster s
      if @hangar == nil
        return false
      end
      @hangar.addShieldBooster s
    end
    
    # Añade el hangar h a la estación espacial
    
    def receiveHangar h
      if not h.is_a? Hangar
        raise ArgumentError.new("Error al añadir un hangar a la estación espacial")
      end
      if @hangar == nil
        @hangar = h
      end
    end
    
    # Descarta el hangar
    
    def discardHangar
      @hangar = nil
    end
    
    # Recibe el paquete de suministros sp
    
    def receiveSupplies sp
      if not sp.is_a? SuppliesPackage
        raise ArgumentError.new("Error al añadir un SuppliesPackage a la estación espacial")
      end
      @ammoPower += sp.ammoPower
      @fuelUnits += sp.fuelUnits
      @shieldPower += sp.shieldPower
    end
    
    # Establece el daño pendiente
    
    def setPendingDamage damage
      if not damage.is_a? Damage
        raise ArgumentError("Error al Establecer daños en la estación espacial")
      end
      @pendingDamage = damage.adjust(@weapons, @shieldBoosters)
      cleanPendingDamage
    end
    
    # Monta la i-ésima arma del hangar para que pueda usarse
    
    def mountWeapon(i)
      weapon = @hangar.removeWeapon(i)
      if weapon != nil
        @weapons.push(weapon)
      end
    end
    
    # Monta el i-ésimo potenciador de escudo para que pueda usarse 
    
    def mountShieldBooster(i)
      shield = @hangar.removeShieldBooster(i)
      if shield != nil
        @shieldBoosters.push(shield)
      end
    end
    
    # Hace que el hangar se descarte del arma i-ésima
    
    def discardWeaponInHangar(i)
      if @hangar != nil
        @hangar.removeWeapon(i)
      end
    end
    
    # Hace que el hangar se descarte del potenciador de escudo i-ésimo
    
    def discardShieldBoosterInHangar(i)
      if @hangar != nil
        @hangar.removeShieldBooster(i)
      end
    end
    
    # Calcula la velocidad
    
    def getSpeed
      @fuelUnits/@@MAXFUEL
    end
    
    # Reduce la cantidad de combustible
    
    def move
      @fuelUnits -= getSpeed
    end
    
    # Comprueba que no haya daño pendiente o este no tenga efecto
    
    def validState
      cleanPendingDamage
      @pendingDamage == nil
    end
    
    # Elimina las armas y escudos a los que no les quedan usos restantes
    
    def cleanUpMountedItems
      @weapons.delete_if { |w| w.uses == 0 }
      @shieldBoosters.delete_if { |s| s.uses == 0 }
    end
    
    #Comprobaciones sobre los argumentos
    
    def fuelunits_correcto?(fuelunits)
      if not fuelunits.is_a? Numeric
        resultado = false
      elsif not fuelunits >= 0.0
        resultado = false
      elsif not fuelunits <= @@MAXFUEL
        resultado = false
      else
        resultado = true
      end
      resultado
    end
    
    def argumentos_correctos?(name, supplies)
      if not name.is_a? String
        resultado = false
      elsif not supplies.is_a? SuppliesPackage
        resultado = false
      else
        resultado = true
      end
      resultado
    end
    
    # Devuelve una interfaz de usuario
    
    def getUIversion
      SpaceStationToUI.new(self)
    end
    
    # Para depurar, devuelve un string con información sobre los atributos
    
    def to_s
      resultado = "name = #{@name}\t"
      resultado += "shieldBoosters = [#{@shieldBoosters.join(", ")}]\t"
      resultado += "weapons = [#{@weapons.join(", ")}]\t"
      resultado += "ammoPower = #{@ammoPower}\t"
      resultado += "fuelUnits = #{@fuelUnits}\t"
      resultado += "shieldPower = #{@shieldPower}\t"
      resultado += "nMedals = #{@nMedals}\t"
      resultado += "pendingDamage = [#{@pendingDamage}]\t"
      resultado += "Hangar = [#{@hangar}]"
      resultado
    end
    
    # Usa todas las armas montadas y devuelve
    # el producto de su potencia por la potencia
    # de la estación
    
    def fire
      factor = 1.0
      @weapons.each{ |w| factor *= w.useIt }
      factor * @ammoPower
    end
    
    # Usa todos los potenciadores de escudo
    # montados y devuelve
    # el producto de su potencia por la potencia
    # de la estación
    
    def protection
      factor = 1.0
      @shieldBoosters.each{ |s| factor *= s.useIt }
      factor * @shieldPower
    end
    
    # Recive un disparo y devuelve si la estación lo resiste
    # Si no lo resiste, la estación se queda sin potencia de escudo
    
    def receiveShot(shot)
      myProtection = protection
      if myProtection >= shot
        @shieldPower -= @@SHIELDLOSSPERUNITSHOT*shot
        return ShotResult::RESIST
      else
        @shieldPower = 0.0
        return ShotResult::DONOTRESIST
      end
    end
    
    # Toma el loot y lo inserta en la estación
    
    def setLoot(loot)
      dealer = CardDealer.instance
      loot.nHangars.times { receiveHangar dealer.nextHangar }
      loot.nSupplies.times { receiveSupplies dealer.nextSuppliesPackage }
      loot.nWeapons.times { receiveWeapon dealer.nextWeapon }
      loot.nShields.times { receiveShieldBooster dealer.nextShieldBooster }
      @nMedals += loot.nMedals
      if loot.efficient
        return Transformation::GETEFFICIENT
      elsif loot.spaceCity
        return Transformation::SPACECITY
      else
        return Transformation::NOTRANSFORM
      end
    end
    
    # La estación se descarta de el arma i-ésima
    
    def discardWeapon(i)
      if i >= 0 and i < @weapons.size
        weapon = @weapons.delete_at(i)
        if @pendingDamage != nil
          @pendingDamage.discardWeapon(weapon)
          cleanPendingDamage
        end
      end
      weapon
    end
    
    # La estación se descarta del escudo iésimo
    
    def discardShieldBooster(i)
      if i >= 0 and i < @shieldBoosters.size
        shield = @shieldBoosters.delete_at(i)
        if @pendingDamage != nil
          @pendingDamage.discardShieldBooster
          cleanPendingDamage
        end
      end
      shield
    end
    
    # Especificaciones sobre la visibilidad
    
    private :argumentos_correctos?, :fuelunits_correcto?
    
    # Consultores seguros
    
    def name
      @name.clone
    end
    
    def ammoPower
      @ammoPower.clone
    end
    
    def fuelUnits
      @fuelUnits.clone
    end
    
    def nMedals
      @nMedals.clone
    end
    
    def shieldPower
      @shieldPower.clone
    end
    
    def hangar
      @hangar.clone
    end
    
    def pendingDamage
      @pendingDamage.clone
    end
    
    def shieldBoosters
      @shieldBoosters.clone
    end
    
    def weapons
      @weapons.clone
    end
    
  end
 
=begin
  #pruebas
  S = SuppliesPackage.new(0.3, 30.0, 5.0)
  A = SpaceStation.new("A",S)
  H = Hangar.new(5)
  A.receiveHangar(H)
  A.receiveWeapon(Weapon.new("arma", WeaponType::LASER, 0))
  A.receiveShieldBooster(ShieldBooster.new("a", 3.4, 0))
  A.mountWeapon(0)
  A.mountShieldBooster(0)
  D = Damage.newNumericWeapons(2, 3)
  A.setPendingDamage(D)
  #A.discardWeaponInHangar(0)
  #A.discardShieldBoosterInHangar(0)
  A.assignFuelValue(30.4)
  puts A
  A.cleanUpMountedItems
  puts A
  
  E = SpaceStation.new("Enterprise", SuppliesPackage.new(6,7,8))
  nombre = E.name
  nombre = "Halcón Milenario"
  puts nombre
  puts E.name
=end
=begin
  E = SpaceStation.new("Enterprise", SuppliesPackage.new(6,7,8))
  E.receiveHangar(Hangar.new(3))
  E.receiveWeapon(Weapon.new("arma", WeaponType::LASER, 1))
  E.mountWeapon(0)
  puts E.fire
  puts E.fire
=end
=begin
  E = SpaceStation.new("Enterprise", SuppliesPackage.new(6,7,8))
  E.receiveHangar(Hangar.new(3))
  E.receiveShieldBooster(ShieldBooster.new("a", 3.4, 1))
  E.mountShieldBooster(0)
  puts E.protection
  puts E.protection
  
  puts E.shieldPower
  puts E.receiveShot(4)
  puts E.shieldPower
  puts E.receiveShot(E.shieldPower)
  puts E.shieldPower
  puts E.receiveShot(E.shieldPower+0.01)
  puts E.shieldPower
=end
=begin
  E = SpaceStation.new("Enterprise", SuppliesPackage.new(0,0,0))
  E.setLoot(Loot.new(1,2, 3, 4, 5))
  puts E
=end
=begin
  E = SpaceStation.new("Enterprise", SuppliesPackage.new(0,0,0))
  D = Damage.newNumericWeapons(2, 3)
  E.setPendingDamage(D)
  H = Hangar.new(5)
  E.receiveHangar(H)
  E.receiveWeapon(Weapon.new("arma", WeaponType::LASER, 0))
  E.receiveShieldBooster(ShieldBooster.new("a", 3.4, 0))
  E.mountWeapon(0)
  E.mountShieldBooster(0)
  puts E
  E.discardWeapon(0)
  E.discardShieldBooster(0)
  puts E
=end
  
  
end
