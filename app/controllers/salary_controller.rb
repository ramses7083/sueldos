# frozen_string_literal: true

require 'json-schema'

class SalaryController < ApplicationController
  def index
    json_value = params[:json_value]
    @json_sent = json_value
    return @salaries = '' if json_value.nil?
    return @salaries = 'No se envió un valor correcto' if validate_schema(json_value) == false

    data = JSON.parse(json_value || '[]')
    players = data.map { |p| Player.new.from_json(p.to_json) }

    @salaries = CalculateFullSalaryService.new(players, minimum_goals).execute
  end

  def valid_json?(json)
    JSON.parse(json)
    true
  rescue JSON::ParserError
    false
  end

  def validate_schema(json)
    structure = { 'required' => %w[nombre nivel goles sueldo bono sueldo_completo equipo],
                  'properties' => {
                    'goles' => { 'type' => 'integer' },
                    'sueldo' => { 'type' => 'number' },
                    'bono' => { 'type' => 'number' }
                  } }

    JSON::Validator.validate!(structure, json.as_json, list: true)
  rescue StandardError
    false
  end

  def minimum_goals
    {
      a: params[:level_a],
      b: params[:level_b],
      c: params[:level_c],
      cuauh: params[:level_cuauh]
    }
  end
end
