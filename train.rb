# frozen_string_literal: true

require './modules/validation'
require './modules/instance_counter'
require './modules/manufacturer'
require './modules/constants'
require './modules/accessors'

class Train
  include Validation
  include InstanceCounter
  include Manufacturer
  include Constants
  include Acсessors


  attr_reader :number, :wagons, :route, :wagon_number
  attr_accessor :speed

  @trains = []

  validate :number, :presence
  validate :number, :type, String
  validate :number, :format, NUMBER_TRAIN_FORMAT

  def self.find(number)
    @trains.each { |train| train.number == number } 
  end

  def initialize(number, options = {})
    @number = number
    @wagons = options[:wagons] || []
    @speed = options[:speed] || 0
    validate!
    @@trains << self
    register_instance
  end

  def stop
    self.speed = 0
  end

  def route(route)
    self.route = route
    self.route.stations[0].take_train(self)
    @current_station_index = 0
  end

  def add_wagon(wagon)
    wagons << wagon if speed.zero?
  end

  def remove_wagon(wagon)
    wagons.delete(wagon) if speed.zero? # && type == wagon.type
  end

  def current_route
    route.stations[@current_station_index]
  end

  def next_station
    route.stations[@current_station_index + 1]
  end

  def prev_station
    route.stations[@current_station_index - 1] if @current_station_index.positive?
  end

  def move_forward
    return unless next_station

    current_route.send_train(self)
    next_station.take_train(self)
    @current_station_index += 1
  end

  def move_back
    return unless prev_station

    current_route.send_train(self)
    prev_station.take_train(self)
    @current_station_index -= 1
  end

  def each_wagons(&block)
    wagons.each(&block)
  end

  protected

  attr_writer :route
end
