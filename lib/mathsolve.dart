// main.dart
import 'dart:math';
import 'package:mathsolve/calculator.dart';
import 'package:mathsolve/data_types.dart';
import 'package:mathsolve/assets/names.dart';
import 'package:mathsolve/statistik.dart';

// Funktion zur Generierung der Mannschaftsliste basierend auf den Optionen
List<Manschaft> generiereManschaften(Options options) {
  return List.generate(
    options.manschaftsAnzahl,
    (index) => Manschaft.fromOptions(options),
  );
}

// Hauptfunktion, um das Turnier auszuführen
void runSequence(Options options) {
  // Erstelle die Liste der Teilnehmer (Mannschaften) mit den angegebenen Optionen
  final List<Manschaft> teilnehmer = generiereManschaften(options);
  final Calculate calculator = Calculate();

  // ANSI Escape Codes
  const String reset = '\x1B[0m';
  const String bold = '\x1B[1m';
  const String italic = '\x1B[3m';
  const String underlined = '\x1B[4m';
  const String greenText = '\x1B[32m';

  // === Gruppenphase ===
  print("\n${greenText + bold}Gruppenphase:${reset}");

  // Aufteilung in Gruppen (Annahme: 4 Teams pro Gruppe für einfache Handhabung)
  final int teamsPerGroup = 4;
  final int groupCount = teilnehmer.length ~/ teamsPerGroup;
  final List<List<Manschaft>> groups = [];

  // Teams in Gruppen aufteilen
  for (int i = 0; i < groupCount; i++) {
    final int startIndex = i * teamsPerGroup;
    final int endIndex = startIndex + teamsPerGroup;
    groups.add(teilnehmer.sublist(startIndex, endIndex));
  }

  // Ergebnisse der Gruppenphase
  final List<Manschaft> gruppenGewinner = [];
  final List<Map<Manschaft, Map<String, dynamic>>> statistiken = [];

  for (int i = 0; i < groups.length; i++) {
    print("\n${bold}Gruppe ${String.fromCharCode(65 + i)}:${reset}");
    final List<Manschaft> gruppe = groups[i];
    final Map<Manschaft, Map<String, int>> statistik = {};
    // Statistik Initialisieren
    for (Manschaft team in gruppe) {
      statistik[team] = {
        'punkte': 0,
        'toreErzielt': 0,
        'toreErhalten': 0,
      };
    }

    // Gruppenphase simulieren
    for (int j = 0; j < gruppe.length; j++) {
      for (int k = j + 1; k < gruppe.length; k++) {
        final (int tore1, int tore2) =
            calculator.simulateMatch(gruppe[j], gruppe[k]);

        // Statistik anpassen
        statistik[gruppe[j]]!['toreErzielt'] =
            statistik[gruppe[j]]!['toreErzielt']! + tore1;
        statistik[gruppe[j]]!['toreErhalten'] =
            statistik[gruppe[j]]!['toreErhalten']! + tore2;
        statistik[gruppe[k]]!['toreErzielt'] =
            statistik[gruppe[k]]!['toreErzielt']! + tore2;
        statistik[gruppe[k]]!['toreErhalten'] =
            statistik[gruppe[k]]!['toreErhalten']! + tore1;

        if (tore1 > tore2) {
          statistik[gruppe[j]]!['punkte'] =
              statistik[gruppe[j]]!['punkte']! + 3;
        } else if (tore2 > tore1) {
          statistik[gruppe[k]]!['punkte'] =
              statistik[gruppe[k]]!['punkte']! + 3;
        } else {
          statistik[gruppe[j]]!['punkte'] =
              statistik[gruppe[j]]!['punkte']! + 1;
          statistik[gruppe[k]]!['punkte'] =
              statistik[gruppe[k]]!['punkte']! + 1;
        }

        // Ausgabe
        print(
            "${(j + 1).toInt()}-${k + 1}: ${italic + underlined}${gruppe[j].name}${reset} ${tore1} vs. ${tore2} ${italic + underlined}${gruppe[k].name}${reset}");
      }
    }

    // Tabellen ausgabe für punkte in der gruppe
    statistik.forEach((team, stats) => print(
        "${team.name} hat ${stats['punkte']} punkte, toreErzielt: ${stats['toreErzielt']}, toreErhalten ${stats['toreErhalten']}"));
    statistiken.add(statistik);
    // Gruppensieger und zweitplazierte bestimmen
    final List<Manschaft> qualifizierte =
        calculator.getQualifikationsTeams(statistik);
    gruppenGewinner.addAll(
        qualifizierte); // Füge die beiden weiterkommenden Teams zur KO-Runde hinzu
    print(
        "${greenText}Die Gewinner sind ${qualifizierte[0].name} und ${qualifizierte[1].name} aus Gruppe ${String.fromCharCode(65 + i)}!${reset}");
  }

  // === KO-Phase ===
  print("\n${greenText + bold}KO-Phase:${reset}");

  List<Manschaft> koTeilnehmer = [...gruppenGewinner]; // Kopie für die KO-Phase
  // Berechne die benötigten Runden
  final List<String> stageStrings =
      calculator.berechneStages(koTeilnehmer.length);

  // Runden ausgeben
  print("Es werden ${stageStrings.length} Runden gespielt:");

  // Schleife, die jede Runde des Turniers durchführt
  for (int i = 0; i < stageStrings.length; i++) {
    // Gebe die Runde aus, die gerade gespielt wird, mit Formatierungen
    print("\n${greenText + bold}Runde ${i + 1}:${reset}");

    final List<Manschaft> runde = [];

    // Durchlaufe alle Teilnehmer und führe die Spiele durch
    for (int j = 0; j < koTeilnehmer.length; j += 2) {
      final Manschaft gewinner =
          calculator.calculateWinner(koTeilnehmer[j], koTeilnehmer[j + 1]);
      runde.add(gewinner);
      print(
          "${(j / 2 + 1).toInt()}: ${italic + underlined}${koTeilnehmer[j].name}${reset} vs. ${italic + underlined}${koTeilnehmer[j + 1].name}${reset} => ${bold + underlined}${gewinner.name}${reset}");
    }
    // Leere die Liste der Teilnehmer und füge die Gewinner der Runde wieder hinzu
    koTeilnehmer.clear();
    koTeilnehmer.addAll(runde);
  }

  // Gewinner des Turniers ausgeben
  print(
      "Der Gewinner ist ${koTeilnehmer[0].name} aus ${koTeilnehmer[0].location}!");

  /* speichereTurnierDaten(
      teilnehmer, groups, gruppenGewinner, koTeilnehmer, statistiken); */
}

// Beispielaufruf (hier für eine kleinere Zahl von Mannschaften):
void second(Options options) {
  List<Manschaft> alleManschaften = List.generate(
      options.manschaftsAnzahl, (index) => Manschaft.fromOptions(options));

  // Gruppenphase simulieren
  List<List<Manschaft>> gruppen = [];
  final Calculate calculator = Calculate();

  final int teamsPerGroup = 4;
  final int groupCount = alleManschaften.length ~/ teamsPerGroup;

  for (int i = 0; i < groupCount; i++) {
    final int startIndex = i * teamsPerGroup;
    final int endIndex = startIndex + teamsPerGroup;
    gruppen.add(alleManschaften.sublist(startIndex, endIndex));
  }

  // Statistiken für die Gruppenphase
  Map<Manschaft, Map<String, int>> statistik = {};
  for (var gruppe in gruppen) {
    for (Manschaft team in gruppe) {
      statistik[team] = {'punkte': 0, 'toreErzielt': 0, 'toreErhalten': 0};
    }
  }

  // Simuliere die Spiele in der Gruppenphase
  for (int i = 0; i < gruppen.length; i++) {
    final List<Manschaft> gruppe = gruppen[i];
    for (int j = 0; j < gruppe.length; j++) {
      for (int k = j + 1; k < gruppe.length; k++) {
        final (int tore1, int tore2) =
            calculator.simulateMatch(gruppe[j], gruppe[k]);

        // Verwende null-sicheren Zugriff und Null-Coalescing-Operator
        statistik[gruppe[j]]?['toreErzielt'] =
            (statistik[gruppe[j]]?['toreErzielt'] ?? 0) + tore1;
        statistik[gruppe[j]]?['toreErhalten'] =
            (statistik[gruppe[j]]?['toreErhalten'] ?? 0) + tore2;
        statistik[gruppe[k]]?['toreErzielt'] =
            (statistik[gruppe[k]]?['toreErzielt'] ?? 0) + tore2;
        statistik[gruppe[k]]?['toreErhalten'] =
            (statistik[gruppe[k]]?['toreErhalten'] ?? 0) + tore1;

        // Punktevergabe
        if (tore1 > tore2) {
          statistik[gruppe[j]]?['punkte'] =
              (statistik[gruppe[j]]?['punkte'] ?? 0) + 3;
        } else if (tore2 > tore1) {
          statistik[gruppe[k]]?['punkte'] =
              (statistik[gruppe[k]]?['punkte'] ?? 0) + 3;
        } else {
          statistik[gruppe[j]]?['punkte'] =
              (statistik[gruppe[j]]?['punkte'] ?? 0) + 1;
          statistik[gruppe[k]]?['punkte'] =
              (statistik[gruppe[k]]?['punkte'] ?? 0) + 1;
        }
      }
    }
  }

  // Gruppensieger ermitteln
  List<Manschaft> gruppenGewinner = [];
  for (var gruppe in gruppen) {
    final List<Manschaft> qualifizierte =
        calculator.getQualifikationsTeams(statistik);
    gruppenGewinner.addAll(qualifizierte);
  }

  // KO-Phase
  List<Manschaft> koTeilnehmer = List.from(gruppenGewinner);

  // Speichere die Daten
  
}
