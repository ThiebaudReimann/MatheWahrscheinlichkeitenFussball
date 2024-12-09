import 'dart:math';
import 'package:mathsolve/calculator.dart';  // Berechnungslogik importieren
import 'package:mathsolve/data_types.dart';  // Datenstrukturen wie Manschaft importieren
import 'package:mathsolve/assets/names.dart'; // Namensdaten oder Ressourcen importieren

// Funktion zur Generierung der Mannschaftsliste basierend auf den Optionen
List<Manschaft> generiereManschaften(Options options) {
  return List.generate(
    options.manschaftsAnzahl, // Anzahl der Mannschaften basierend auf der Option
    (index) => Manschaft.fromOptions(options), // Für jede Mannschaft wird ein Objekt aus den Optionen erstellt
  );
}

// Hauptfunktion, um das Turnier auszuführen
void runSequence(Options options) {
  // Erstelle die Liste der Teilnehmer (Mannschaften) mit den angegebenen Optionen
  final List<Manschaft> teilnehmer = generiereManschaften(options);
  
  final Calculate calculator = Calculate(); // Instanziierung des Calculators für die Berechnungen
  
  // Berechnung, wie viele Runden (Stages) gespielt werden müssen
  final List<String> stageStrings = calculator.berechneStages(teilnehmer.length);
  
  // Gebe die Anzahl der Runden aus
  print("Es werden ${stageStrings.length} Runden gespielt:");

  // ANSI Escape Codes für verschiedene Formatierungen in der Konsole
  const String reset = '\x1B[0m';        // Rücksetzen der Formatierungen
  const String bold = '\x1B[1m';         // Fettgedruckt
  const String italic = '\x1B[3m';       // Kursiv
  const String underlined = '\x1B[4m';   // Unterstrichen
  const String redBackground = '\x1B[41m'; // Roter Hintergrund
  const String greenText = '\x1B[32m';   // Grüner Text
  
  // Schleife, die jede Runde des Turniers durchführt
  for (int i = 0; i < stageStrings.length; i++) {
    // Gebe die Runde aus, die gerade gespielt wird, mit Formatierungen
    print("\n${greenText + bold}Runde ${i + 1}:${reset}");
    
    final List<Manschaft> runde = []; // Liste für die Gewinner der Runde
    
    // Durchlaufe alle Teilnehmer und führe die Spiele durch
    for (int j = 0; j < teilnehmer.length; j += 2) {
      // Berechne den Gewinner der beiden Teams
      final Manschaft gewinner = calculator.calculateWinner(teilnehmer[j], teilnehmer[j + 1]);
      
      // Füge den Gewinner der Runde zur Liste hinzu
      runde.add(gewinner);
      
      // Gebe das Ergebnis des Spiels aus, mit den entsprechenden Formatierungen
      print("${(j / 2 + 1).toInt()}: ${italic + underlined}${teilnehmer[j].name}${reset} vs. ${italic + underlined}${teilnehmer[j + 1].name}${reset} => ${bold + underlined}${gewinner.name}${reset}");
    }
    
    // Leere die Liste der Teilnehmer und füge die Gewinner der Runde wieder hinzu
    teilnehmer.clear();
    teilnehmer.addAll(runde);
  }

  // Am Ende der Runden gibt der Code den endgültigen Gewinner des Turniers aus
  print("Der Gewinner ist ${teilnehmer[0].name} aus ${teilnehmer[0].location}!");
}
