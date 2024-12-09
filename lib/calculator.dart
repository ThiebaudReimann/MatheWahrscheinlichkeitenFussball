import 'dart:math';

import 'package:mathsolve/data_types.dart';

class Calculate {
  Manschaft calculateWinner(Manschaft team1, Manschaft team2) {
    Random random = Random();

    // Berechnung der Teamstärken mit Zufallsfaktor und Abweichungen
    double calculateTeamPower(Manschaft team) {
      final basePower = team.spieler.fold(
        0.0,
        (previousValue, element) =>
            previousValue + element.power.getDurchschnitt(element.position),
      );

      // Zufallsabweichung: ±10 % der Gesamtstärke
      final randomFactor = 1 + (random.nextDouble() * 0.2 - 0.1);

      // Chemie der Mannschaft als Bonusfaktor (zwischen 0.5 und 1.5)
      final chemistryFactor = 1 + ((team.chemistry - 50) / 100);

      return basePower * randomFactor * chemistryFactor;
    }

    // Stärken berechnen
    final double team1Power = calculateTeamPower(team1);
    final double team2Power = calculateTeamPower(team2);

    // Gewinner bestimmen
    return team1Power > team2Power ? team1 : team2;
  }

  List<String> berechneStages(int teilnehmer) {
    // Berechne die Anzahl der Runden
    int runden = (log(teilnehmer) / log(2)).ceil();

    // Initialisiere eine Liste der Phasen
    List<String> stages = [];

    // Phasen anhand der Anzahl der Runden zuordnen
    for (int i = 0; i < runden; i++) {
      stages.add(i.toString());
    }

    return stages.reversed
        .toList(); // Phasen in umgekehrter Reihenfolge, weil Finale zuletzt kommt
  }

  int calculateNumTeamsFromStages(int stages) {
    return pow(2, stages).toInt();
  }
}
