#encoding:utf-8

require_relative 'FaultySpaceCity'
require_relative 'CardDealer'

module Deepspace

  
  dealer = CardDealer.instance
  
  B = SpaceStation.new("Bespin, la ciudad de las nubes", SuppliesPackage.new(3,4,5))
  E = SpaceStation.new("Enterprise", SuppliesPackage.new(4,4,4))
  N = SpaceStation.new("Nostromo", SuppliesPackage.new(3,7,3))
  manager = StationsManager.instance
  manager.add(B)
  manager.add(E)
  manager.add(N)
  manager.setFirstStation(0)
  
  B = FaultySpaceCity.new(B, manager)
  
  
  arr = [B,N,E]
  
  arr.each do |x|
    while x.hangar == nil
      x.receiveHangar(dealer.nextHangar)
    end
  end
  
  2.times do
    arr.each do |x|
      x.receiveWeapon(dealer.nextWeapon)
      x.mountWeapon(0)
    end
  end
  
  puts B
  puts B.fire
  puts B
  
end