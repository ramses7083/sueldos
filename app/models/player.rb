class Player
  include ActiveModel::Serializers::JSON

  attr_accessor :nombre, :nivel, :goles, :sueldo, :bono, :sueldo_completo, :equipo, :goles_minimos, :porcentaje_ind

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def attributes
    instance_values
  end

  def results
    {
      nombre: nombre,
      goles_minimos: goles_minimos,
      goles: goles,
      sueldo: sueldo,
      bono: bono,
      sueldo_completo: sueldo_completo,
      equipo: equipo
    }
  end
end
