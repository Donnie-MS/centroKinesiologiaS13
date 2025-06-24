class Paciente {
  var property edad
  var property fortalezaMuscular
  var property nivelDeDolor
  const rutina = #{}
  method usarAparato(unAparato) {
    unAparato.usarPor(self)
  }
  method puedeUsar(unAparato) = unAparato.puedeSerUsadoPor(self)
  method puedeRealizarRutina() = rutina.all({aparato => self.puedeUsar(aparato)})
  method realizarRutina() {
    if (not self.puedeRealizarRutina() ) {
      self.error("No puede realizar rutina")
    }
    rutina.forEach({aparato => self.usarAparato(aparato)})
  }
}
class Aparato {
  var property color = blanco
  method usarPor(unPaciente)
  method puedeSerUsadoPor(unPaciente)
}
class Magneto inherits Aparato {
  override method usarPor(unPaciente) {
    unPaciente.nivelDeDolor(unPaciente.nivelDeDolor() * 0.90)
  }
  override method puedeSerUsadoPor(unPaciente) = true
}
class Bicicleta inherits Aparato {
  override method usarPor(unPaciente) {
    if (not self.puedeSerUsadoPor(unPaciente)) {
      self.error("Debes tenes más de 8 anios")
    }
    unPaciente.nivelDeDolor((unPaciente.nivelDeDolor() - 4).max(0))
    unPaciente.fortalezaMuscular(unPaciente.fortalezaMuscular() + 3)
  }
  override method puedeSerUsadoPor(unPaciente) = unPaciente.edad() > 8
}
class Minitramp inherits Aparato {
  override method usarPor(unPaciente) {
    if (not self.puedeSerUsadoPor(unPaciente)) {
      self.error("Solo puede ser usado por personas cuyo nivel de dolor es inferior a 20")
    }
    unPaciente.fortalezaMuscular(unPaciente.fortalezaMuscular() * 1.10)
  }
  override method puedeSerUsadoPor(unPaciente) = unPaciente.nivelDeDolor() < 20
}
object centroDeKinesiologia {
  const property aparatos = []
  method incorporarNuevo(unAparato) {
    aparatos.add(unAparato)
  }
}
class PacienteResistente inherits Paciente {
  override realizarRutina() {
    var contador = rutina.count({aparato => aparato.puedeSerUsadoPor(self)})
    self.fortalezaMuscular(self.fortalezaMuscular() + contador)
    super()
  }
}
class PacienteCaprichoso inherits Paciente {
  override puedeRealizarRutina() = super() and self.hayAparatoDe(rojo)
  override realizarRutina() {
    super()
    super()
  }
  method hayAparatoDe(unColor) = rutina.any({aparato => aparato.color() == unColor})
}
class PacienteDeRapidaRecuperacion inherits Paciente {
  override realizarRutina() {
    super()
    self.nivelDeDolor(self.nivelDeDolor() - disminucionDolor.valor())
  }
}

object disminucionDolor {
  var property valor = 3
}
