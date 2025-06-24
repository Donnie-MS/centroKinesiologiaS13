
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
  method necesitaMantenimiento() = false
  method hacerleMantenimiento() {}
}

class Magneto inherits Aparato {
  var property imantacion = 800
  override method necesitaMantenimiento() = imantacion < 100
  override method hacerleMantenimiento() {
    self.imantacion(self.imantacion() + 500)
  }
  override method usarPor(unPaciente) {
    unPaciente.nivelDeDolor(unPaciente.nivelDeDolor() * 0.90)
    self.imantacion(self.imantacion() - 1)
  }
  override method puedeSerUsadoPor(unPaciente) = true
}
class Bicicleta inherits Aparato {
  var cantVecesQueSeDesajustanTornillos = 0
  var cantVecesQuePierdeAceite = 0

  override method usarPor(unPaciente) {
    if (not self.puedeSerUsadoPor(unPaciente)) {
      self.error("Debes tenes más de 8 anios")
    }
    self.consecuenciasDeUso(unPaciente)
    unPaciente.nivelDeDolor((unPaciente.nivelDeDolor() - 4).max(0))
    unPaciente.fortalezaMuscular(unPaciente.fortalezaMuscular() + 3)
  }
  method consecuenciasDeUso(unPaciente) {
    if(unPaciente.nivelDeDolor > 30) {
      cantVecesQueSeDesajustanTornillos += 1
      if (unPaciente.edad() >= 30 and unPaciente.edad() <= 50) {
        cantVecesQuePierdeAceite += 1
      }
    }
  }
  override hacerleMantenimiento() {
    cantVecesQuePierdeAceite = 0
    cantVecesQuePierdeAceite = 0
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

object centroDeKinesiologia {
  const property aparatos = []
  const property pacientes = #{}
  method incorporarNuevo(unAparato) {
    aparatos.add(unAparato)
  }
  method coloresDeAparatos = aparatos.map({aparato => aparato.color()}).asSet()
  method pacientesMenoresDe8Años = pacientes.filter({paciente => paciente.edad() < 8})
  method pacientesQueNoPuedenCumplirSesion = pacientes.filter({paciente => not paciente.puedeRealizarRutina()})
  method estaEnOptimasCondiciones() = aparatos.all({aparato => not aparato.necesitaMantenimiento()})
  method aparatosQueNecesitanMantenimiento() = aparatos.filter({aparato => aparato.necesitaMantenimiento})
  method cantAparatosQueNecesitanMantenimiento() = self.aparatosQueNecesitanMantenimiento.size()
  method estaComplicado() {
    var mitadDeAparatos = aparatos.size().div(2)
    return mitadDeAparatos > self.cantAparatosQueNecesitanMantenimiento()
  }
  method realizarMantenimiento() {
    self.aparatosQueNecesitanMantenimiento().forEach({aparato =>aparato.hacerleMantenimiento()})
  }
}
