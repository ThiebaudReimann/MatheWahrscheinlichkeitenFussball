import 'dart:math';

import 'package:mathsolve/assets/names.dart';

enum Position { IV, RV, LV, ZDM, ZOM, ZM, LM, RM, TW, ST, RS, LS }

class Options {
  final int manschaftsAnzahl;
  final int minSpieler;
  final int maxSpieler;

  Options({
    required this.manschaftsAnzahl,
    required this.minSpieler,
    required this.maxSpieler,
  });
}

class Manschaft {
  final String name;
  final List<Spieler> spieler;
  final String location;
  final int chemistry;

  Manschaft({
    required this.name,
    required this.spieler,
    required this.location,
    required this.chemistry,
  });

  factory Manschaft.fromOptions(Options options) {
    Random random = Random();
    final int spielerAnzahl =
        random.nextInt(options.maxSpieler - options.minSpieler + 1) +
            options.minSpieler;
    final int nameIndex = random.nextInt(teamNames.length);
    final List<Spieler> spieler = List.generate(
      spielerAnzahl,
      (index) => Spieler.fromRandom(),
    );
    return Manschaft(
      name: teamNames[nameIndex],
      location: locations[nameIndex],
      chemistry: random.nextInt(50) + 50, // Chemie zwischen 50 und 99
      spieler: spieler,
    );
  }
}

class Spieler {
  final String name;
  final int alter;
  final Power power;
  final Position position;

  Spieler({
    required this.name,
    required this.alter,
    required this.power,
    required this.position,
  });

  factory Spieler.fromRandom() {
    Random random = Random();
    int positionIndex = random.nextInt(Position.values.length);
    return Spieler(
      name: playerNames[random.nextInt(playerNames.length)],
      alter: random.nextInt(19) + 18, // Alter zwischen 18 und 36
      position: Position.values[positionIndex],
      power: Power.fromPosition(Position.values[positionIndex]),
    );
  }
}

class Power {
  final int angriffsStaerke;
  final int abwaehrStaerke;
  final int passSicherheit;
  final int parrierSicherheit;
  final int pace;

  Power({
    required this.angriffsStaerke,
    required this.abwaehrStaerke,
    required this.passSicherheit,
    required this.parrierSicherheit,
    required this.pace,
  });

  factory Power.fromPosition(Position position) {
    final random = Random();
    return Power(
      angriffsStaerke: random.nextInt(36) + 60, // Stärke zwischen 60 und 95
      abwaehrStaerke: random.nextInt(36) + 50,
      passSicherheit: random.nextInt(36) + 55,
      parrierSicherheit: position == Position.TW ? random.nextInt(91) : 0,
      pace: random.nextInt(36) + 60,
    );
  }

  // Methode zur Ausgabe der Power im Durchschnitt
  double getDurchschnitt(Position position) {
    Gewichtung g = Gewichtung(position: position);
    int gesamtGewichtung = g.angriffsStaerke +
        g.abwaehrStaerke +
        g.passSicherheit +
        g.parrierSicherheit +
        g.pace;

    if (gesamtGewichtung == 0) {
      throw ArgumentError('Die Gewichtung darf nicht 0 sein.');
    }

    return (angriffsStaerke * g.angriffsStaerke +
            abwaehrStaerke * g.abwaehrStaerke +
            passSicherheit * g.passSicherheit +
            parrierSicherheit * g.parrierSicherheit +
            pace * g.pace) /
        gesamtGewichtung;
  }
}

class Gewichtung {
  final Position position;

  late final int angriffsStaerke;
  late final int abwaehrStaerke;
  late final int passSicherheit;
  late final int parrierSicherheit;
  late final int pace;

  Gewichtung({required this.position}) {
    // Gewichtung je nach Position
    switch (position) {
      case Position.TW:
        angriffsStaerke = 1;
        abwaehrStaerke = 4;
        passSicherheit = 3;
        parrierSicherheit = 5;
        pace = 2;
        break;
      case Position.IV:
        angriffsStaerke = 2;
        abwaehrStaerke = 5;
        passSicherheit = 3;
        parrierSicherheit = 4;
        pace = 3;
        break;
      case Position.RV:
      case Position.LV:
        angriffsStaerke = 3;
        abwaehrStaerke = 4;
        passSicherheit = 4;
        parrierSicherheit = 3;
        pace = 5;
        break;
      case Position.ZDM:
        angriffsStaerke = 2;
        abwaehrStaerke = 4;
        passSicherheit = 5;
        parrierSicherheit = 4;
        pace = 3;
        break;
      case Position.ZM:
        angriffsStaerke = 3;
        abwaehrStaerke = 3;
        passSicherheit = 5;
        parrierSicherheit = 3;
        pace = 3;
        break;
      case Position.ZOM:
        angriffsStaerke = 4;
        abwaehrStaerke = 2;
        passSicherheit = 5;
        parrierSicherheit = 2;
        pace = 4;
        break;
      case Position.LM:
      case Position.RM:
        angriffsStaerke = 4;
        abwaehrStaerke = 2;
        passSicherheit = 4;
        parrierSicherheit = 2;
        pace = 5;
        break;
      case Position.ST:
      case Position.RS:
      case Position.LS:
        angriffsStaerke = 5;
        abwaehrStaerke = 1;
        passSicherheit = 3;
        parrierSicherheit = 2;
        pace = 5;
        break;
    }
  }

  // Methode zur Ausgabe der Gewichtung
  void printGewichtung() {
    print('Position: $position');
    print('AngriffsStärke: $angriffsStaerke');
    print('AbwehrStärke: $abwaehrStaerke');
    print('PassSicherheit: $passSicherheit');
    print('ParrierSicherheit: $parrierSicherheit');
    print('Pace: $pace');
  }
}
