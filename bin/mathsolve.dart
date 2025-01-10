// Importieren der notwendigen Pakete für die Berechnungen und Datenstrukturen
import 'package:mathsolve/calculator.dart'; // Berechnungslogik
import 'package:mathsolve/data_types.dart';  // Datenstrukturen wie Options und Manschaft
import 'package:mathsolve/mathsolve.dart';   // Hauptlogik und Funktionen

// Hauptfunktion, die beim Starten des Programms ausgeführt wird und Argumente entgegennimmt
void main(List<String> arguments) {
  // Geben der übergebenen Argumente in der Konsole aus
  print(arguments);

  // Erstellen der Options-Instanz. Wenn keine Argumente übergeben werden, werden Standardwerte verwendet:
  // manschaftsAnzahl: 16, minSpieler: 18, maxSpieler: 23
  // Falls Argumente übergeben werden, werden diese genutzt, um die Optionen zu setzen.
  final Options options = Options(
    manschaftsAnzahl: arguments.isEmpty ? 16 : int.parse(arguments[0]), // Anzahl der Mannschaften (Standard: 16)
    minSpieler: arguments.isEmpty ? 18 : int.parse(arguments[1]),        // Mindestanzahl an Spielern pro Mannschaft (Standard: 18)
    maxSpieler: arguments.isEmpty ? 23 : int.parse(arguments[2]),        // Höchstanzahl an Spielern pro Mannschaft (Standard: 23)
  );

  // Aufrufen der Funktion `runSequence` mit den erstellten Optionen.
  // Diese Funktion führt die Hauptlogik des Spiels aus.
  runSequence(options);
  //second(options);
}
