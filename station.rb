# frozen_string_literal: true

require './modules/validation'
require './modules/instance_counter'
require './modules/accessors'

class Station
  include Validation
  include InstanceCounter
  include Acсessors

  attr_reader :trains_on_station, :name 

  validate :name, :presence
  validate :name, :length, 3
  validate :name, :type, Symbol

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains_on_station = []
    @validate
    @@stations << self
    register_instance
  end

  def take_train(train)
    @trains_on_station << train
  end

  def send_train(train)
    @trains_on_station.delete(train)
  end

  def each_train(&block)
    @trains_on_station.each(&block)
  end
end
