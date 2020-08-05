require "test_helper"

class PlayerTest < ActiveSupport::TestCase
  setup do
    @player = Player.new.from_json(players.first.to_json)
  end

  test "init a player object" do
    assert_equal Player, @player.class
  end

  test "player results" do
    assert_equal player_params.keys, @player.results.as_json.keys.map(&:to_sym)
  end

  def player_params
    {
        "nombre": "Juan Perez",
        "goles_minimos": "15",
        "goles": 10,
        "sueldo": 50000,
        "bono": 25000,
        "sueldo_completo": nil,
        "equipo": "rojo"
    }
  end
end
