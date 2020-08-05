class CalculateFullSalaryService
  attr_reader :players

  def initialize(players, minimum_goals)
    @players = players
    @minimum_goals = minimum_goals
    @teams = []
  end

  def execute
    set_player_goals
    @teams = calculate_teams_percentage
    calculate_salary
  end

  private

  def calculate_salary
    results = @players.map { |p|
      p.sueldo_completo = calculate_full_salary(p)
      p.results
    }
    results
  end

  def set_player_goals
    @players.each do |p|
      p.porcentaje_ind = calculate_indiv_percentage(p)
      p.goles_minimos = @minimum_goals[p.nivel.downcase.to_sym].to_i
    end
  end

  def calculate_teams_percentage
    @players.as_json.group_by { |t| t["equipo"] }
  end

  def calculate_indiv_percentage(player)
    porcentaje_ind = player.goles * 100 / @minimum_goals[player.nivel.downcase.to_sym].to_i
    player.porcentaje_ind = porcentaje_ind < 100 ? porcentaje_ind : 100
  end

  def get_team_percentage(player)
    scored_goals = @teams[player.equipo].map { |t| t["goles"] }.sum
    expected_goals = @teams[player.equipo].map { |t| t["goles_minimos"] }.sum
    percentage = scored_goals * 100 / expected_goals
    team_percentage = percentage < 100 ? percentage : 100
    team_percentage
  end

  def calculate_full_salary(p)
    final_percentage = (p.porcentaje_ind + get_team_percentage(p)) / 2
    p.sueldo_completo = p.sueldo + (final_percentage * p.bono / 100)
  end
end
