# frozen_string_literal: true

require './modules/instance_counter'
require './modules/manufacturer'
require './modules/validation'
require './modules/constants'
require './require/accessors'

class Wagon
  include InstanceCounter
  include Manufacturer
  include Validation
  include Constants
  include Acсessors

  attr_reader :type, :wagon_number, :volume, :occupied_volume

  validate :wagon_number, :presence
  validate :wagon_number, :format, NUMBER_WAGON_FORMAT
  validate :volume, :presence
  validate :volume, :positive
  validate :volume, :type, Integer

  def initialize(wagon_number, options = {})
    @wagon_number = wagon_number
    @volume = options[:volume] || 0
    @occupied_volume = options[:occupied_volume] || 0
    validate!
    register_instance
  end

  def free_volume
    volume - occupied_volume
  end

  protected

  attr_writer :occupied_volume
end
