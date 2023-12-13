# frozen_string_literal: true

class PassengerWagon < Wagon
  def initialize(wagon_number, volume)
    super
    @type = :passenger
  end

  def take_place
    raise 'No place' if free_volume.zero?

    self.occupied_volume += 1 if free_volume.positive?
  end
end
