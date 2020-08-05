require "test_helper"

class CalculatePlayersSalariesServiceTest < ActiveSupport::TestCase
  test "calculate the full salary of players" do
    @players = players.map { |p| Player.new.from_json(p.to_json) }
    response = CalculateFullSalaryService.new(@players, minimum_goals).execute

    assert_equal player_with_his_full_calculated_salary, JSON.parse(response).first
  end

  def player_with_his_full_calculated_salary
    {
        "nombre" => "Juan Perez",
        "goles_minimos" => 15,
        "goles" => 10,
        "sueldo" => 50000,
        "bono" => 25000,
        "sueldo_completo" => 67750.0,
        "equipo" => "rojo"
    }
  end
end
