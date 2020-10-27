#encoding:utf-8

require_relative 'Dice'
require_relative 'GameStateController'
require_relative 'StationsManager'
require_relative 'SpaceCity'
require_relative 'BetaPowerEfficientSpaceStation'
require_relative 'EnemyStarShip'
require_relative 'GameUniverseToUI'
require_relative 'CombatResult'

module Deepspace
  
  # Clase que implementa ciertos mecanismos relativos al funcionamiento del 
  # juego
  
  class GameUniverse
    
    # Constante con el valor mínimo para la victoria
    
    @@WIN = 10
    
    # Constructor sin parámetros
    
    def initialize
      @turns = 0
      @gameState = GameStateController.new
      @dice = Dice.new
      @currentEnemy = nil
      @transform = Transformation::NOTRANSFORM
      @currentSpaceStation = nil
      @haveSpaceCity = false
      @spaceStations = StationsManager.instance
    end
    
    # Realiza un combate entre station y enemy
    
    def combatGo(station, enemy)
      character = @dice.firstShot
      if character == GameCharacter::ENEMYSTARSHIP
        result = station.receiveShot enemy.fire
        if result == ShotResult::RESIST
          result = enemy.receiveShot station.fire
          enemyWins = (result == ShotResult::RESIST)
        else
          enemyWins = true
        end
      else
        result = enemy.receiveShot station.fire
        enemyWins = (result == ShotResult::RESIST)
      end
      if enemyWins
        moves = @dice.spaceStationMoves(station.getSpeed)
        if not moves
          station.setPendingDamage(enemy.damage)
          combatResult = CombatResult::ENEMYWINS
        else
          station.move
          combatResult = CombatResult::STATIONESCAPES
        end
      else
        @transform = station.setLoot(enemy.loot)
        if @transform == Transformation::GETEFFICIENT
          makeStationEfficient
          combatResult = CombatResult::STATIONWINSANDCONVERTS
        elsif @transform == Transformation::SPACECITY and not @haveSpaceCity
          createSpaceCity
          combatResult = CombatResult::STATIONWINSANDCONVERTS
        else
          @transform = Transformation::NOTRANSFORM
          combatResult = CombatResult::STATIONWINS
        end 
      end
      @gameState.next(@turns, @spaceStations.size)
      combatResult
    end
    
    # Hacemos combatir la nave actual con el enemigo actual
    
    def combat
      if state == GameState::BEFORECOMBAT or state == GameState::INIT
        combatResult = combatGo(@currentSpaceStation, @currentEnemy)
      else
        combatResult = CombatResult::NOCOMBAT
      end
      combatResult
    end
    
    # Creamos una ciudad espacial
    
    def createSpaceCity
      if not @haveSpaceCity
        @currentSpaceStation = SpaceCity.new(@currentSpaceStation, @spaceStations)
        @spaceStations.transformCurrentStation(@currentSpaceStation)
        @haveSpaceCity = true
      else
        @transform = Transformation::NOTRANSFORM
      end
    end
    
    # Le pedimos a la estación espacial actual que descarte su hangar
    
    def discardHangar
      if state == GameState::INIT or state == GameState::AFTERCOMBAT
        @currentSpaceStation.discardHangar
      end
    end
    
    # Le pedimos a la estación espacial actual que descarte su potenciador de 
    # escudo
    
    def discardShieldBooster i
      if state == GameState::INIT or state == GameState::AFTERCOMBAT
        @currentSpaceStation.discardShieldBooster i
      end
    end
    
    # Le pedimos a la estación espacial actual que descarte su potenciador de 
    # escudo que tenga en el hangar
    
    def discardShieldBoosterInHangar i
      if state == GameState::INIT or state == GameState::AFTERCOMBAT
        @currentSpaceStation.discardShieldBoosterInHangar i
      end
    end
    
    # Le pedimos a la estación espacial actual que descarte su arma
    
    def discardWeapon i
      if state == GameState::INIT or state == GameState::AFTERCOMBAT
        @currentSpaceStation.discardWeapon i
      end
    end
    
    # Le pedimos a la estación espacial actual que descarte el arma que tenga en
    # el hangar
    
    def discardWeaponInHangar i
      if state == GameState::INIT or state == GameState::AFTERCOMBAT
        @currentSpaceStation.discardWeaponInHangar i
      end
    end
    
    # Comprobamos si la estación espacial actual ha ganado
    
    def haveAWinner
      @currentSpaceStation.nMedals >= @@WIN
    end
    
    # Inicia el juego
    
    def init(names)
      dealer = CardDealer.instance
      if state == GameState::CANNOTPLAY
        names.each do |name|
          supplies = dealer.nextSuppliesPackage
          station = SpaceStation.new(name, supplies)
          loot = Loot.new(0, @dice.initWithNWeapons, @dice.initWithNShields, @dice.initWithNHangars, 0)
          station.setLoot(loot)
          @spaceStations.add(station)
        end
      end
      @spaceStations.setFirstStation((@dice.whoStarts(names.size)+names.size-1)%names.size)
      @currentEnemy = dealer.nextEnemy
      @gameState.next(@turns, @spaceStations.size)
      @currentSpaceStation = @spaceStations.nextStation
    end
    
    # Hacemos una estación eficiente
    
    def makeStationEfficient
      if @dice.extraEfficiency
        @currentSpaceStation = BetaPowerEfficientSpaceStation.new(@currentSpaceStation)
      else
        @currentSpaceStation = PowerEfficientSpaceStation.new(@currentSpaceStation)        
      end
      @spaceStations.transformCurrentStation(@currentSpaceStation)
    end
    
    # Montamos el i-ésimo potenciador de escudo
    
    def mountShieldBooster(i)
      if state == GameState::INIT or state == GameState::AFTERCOMBAT
        @currentSpaceStation.mountShieldBooster(i)
      end
    end
    
    # Montamos la i-ésima arma
    
    def mountWeapon(i)
      if state == GameState::INIT or state == GameState::AFTERCOMBAT
        @currentSpaceStation.mountWeapon(i)
      end
    end
    
    def nextTurn
      result = false
      if state == GameState::AFTERCOMBAT and @currentSpaceStation.validState
        @turns += 1
        @transform = Transformation::NOTRANSFORM
        @currentSpaceStation = @spaceStations.nextStation
        @currentSpaceStation.cleanUpMountedItems
        dealer = CardDealer.instance
        @currentEnemy = dealer.nextEnemy
        @gameState.next(@turns, @spaceStations.size)
        result = true
      end
      result
    end
    
    # Devuelve una interfaz de usuario
    
    def getUIversion
      GameUniverseToUI.new(@currentSpaceStation, @currentEnemy)
    end
    
    # Extrae el estado del juego
    def state
      @gameState.state
    end
    
    
    # Hacemos accesible para la lectura el estado del juego
    
    attr_reader :gameState, :transform
  end
end
