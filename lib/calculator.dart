// calculator.dart
import 'dart:math';
import 'package:mathsolve/data_types.dart';

class Calculate {
  Manschaft calculateWinner(Manschaft team1, Manschaft team2) {
    Random random = Random();
    
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
     
    final double team1Power = calculateTeamPower(team1);
    final double team2Power = calculateTeamPower(team2);
    

    return team1Power > team2Power ? team1 : team2;
  }
    // Torsimulation mit einer gewissen Wahrscheinlichkeit, basierend auf der Teamstärke
  (int, int) simulateMatch(Manschaft team1, Manschaft team2) {
    Random random = Random();
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

    final double team1Power = calculateTeamPower(team1);
    final double team2Power = calculateTeamPower(team2);

    double team1ScoreChance = team1Power / (team1Power + team2Power);
    double team2ScoreChance = 1 - team1ScoreChance;


    int tore1 = 0;
    int tore2 = 0;
    for (int i = 0; i < 5; i++) { // Simuliere max 5 Ereignisse
      if (random.nextDouble() < team1ScoreChance) {
        tore1++;
      }
      if (random.nextDouble() < team2ScoreChance) {
        tore2++;
      }
    }
    return (tore1, tore2);
  }

   List<Manschaft> getQualifikationsTeams(Map<Manschaft, Map<String, int>> statistik) {
  // Sortiere die Teams nach Punkten (absteigend), Tordifferenz (absteigend) und dann nach erzielten Toren (absteigend)
  final List<MapEntry<Manschaft, Map<String, int>>> sortedEntries = statistik.entries.toList()
    ..sort((a, b) {
      int cmp = b.value['punkte']!.compareTo(a.value['punkte']!);
      if (cmp != 0) return cmp;
      cmp = (b.value['toreErzielt']! - b.value['toreErhalten']!).compareTo(a.value['toreErzielt']! - a.value['toreErhalten']!);
      if(cmp != 0) return cmp;
       return b.value['toreErzielt']!.compareTo(a.value['toreErzielt']!);
    });
    
      return sortedEntries.take(2).map((e) => e.key).toList();
  }
    
  List<String> berechneStages(int teilnehmer) {
    int runden = (log(teilnehmer) / log(2)).ceil();
    List<String> stages = [];
    for (int i = 0; i < runden; i++) {
      stages.add(i.toString());
    }
    return stages.reversed.toList();
  }

  int calculateNumTeamsFromStages(int stages) {
    return pow(2, stages).toInt();
  }
}