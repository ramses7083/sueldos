# frozen_string_literal: true
require 'byebug'
require 'json-schema'

class SalaryController < ApplicationController

  def index
    json_value = params[:json_value]
    return @salaries = 'No paso' if validate_schema(json_value) == false

    data = JSON.parse(json_value || '[]')
    players = data.map { |p| Player.new.from_json(p.to_json) }

    @salaries = CalculateFullSalaryService.new(players, minimum_goals).execute
  end

  def valid_json?(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
  end

  def validate_schema(json)
    schema = {
        "required" => ["nombre", "nivel", "goles", "sueldo", "bono", "sueldo_completo", "equipo"],
        "properties" => {
            "goles" => { "type" => "integer"},
            "sueldo" => { "type" => "number"},
            "bono" => { "type" => "number"}
        }
    }

    JSON::Validator.validate!(schema, json.as_json, :list => true)
  rescue => exception
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