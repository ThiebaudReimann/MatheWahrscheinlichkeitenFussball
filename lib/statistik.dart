import 'dart:convert';
import 'dart:io';

import 'package:mathsolve/data_types.dart';

void speichereTurnierDaten(List<Manschaft> alleManschaften, List<List<Manschaft>> gruppen, List<Manschaft> gruppenGewinner, List<Manschaft> koTeilnehmer, List<Map<Manschaft, Map<String, dynamic>>> statistiken) {
  // Erstelle eine Map, um die Daten zu speichern
  Map<String, dynamic> daten = {};
  
  // Alle Mannschaften speichern
  daten['manschaften'] = alleManschaften.map((Manschaft team) {
    return {
      'id': team.name.toString() + ";" + team.chemistry.toString(),
      'name': team.name,
      'location': team.location,
      'chemistry': team.chemistry,
      'spieler': team.spieler.map((spieler) {
        return {
          'name': spieler.name,
          'alter': spieler.alter,
          'position': spieler.position.toString().split('.').last,
          'power': {
            'angriffsStaerke': spieler.power.angriffsStaerke,
            'abwaehrStaerke': spieler.power.abwaehrStaerke,
            'passSicherheit': spieler.power.passSicherheit,
            'parrierSicherheit': spieler.power.parrierSicherheit,
            'pace': spieler.power.pace,
          }
        };
      }).toList()
    };
  }).toList();
  
  // Gruppenphase speichern
  daten['gruppenphase'] = [];
  for (int i = 0; i < gruppen.length; i++) {
    Map<String, dynamic> gruppeData = {
      'gruppe': String.fromCharCode(65 + i),
      'mannschaften': []
    };
    final List<Manschaft> gruppe = gruppen[i];
    for (Manschaft team in gruppe) {
      Map<String, dynamic> teamData = {
        'name': team.name,
        'location': team.location,
        'chemistry': team.chemistry,
        'statistiken': statistiken,
        'spieler': []
      };
      for (Spieler spieler in team.spieler) {
        Map<String, dynamic> spielerData = {
          'name': spieler.name,
          'alter': spieler.alter,
          'position': spieler.position.toString().split('.').last,
          'power': {
            'angriffsStaerke': spieler.power.angriffsStaerke,
            'abwaehrStaerke': spieler.power.abwaehrStaerke,
            'passSicherheit': spieler.power.passSicherheit,
            'parrierSicherheit': spieler.power.parrierSicherheit,
            'pace': spieler.power.pace,
          }
        };
        teamData['spieler'].add(spielerData);
      }
      gruppeData['mannschaften'].add(teamData);
    }
    daten['gruppenphase'].add(gruppeData);
  }

  // Gruppenspiele speichern
  daten['gruppenspiele'] = [];
  for (Manschaft team in gruppenGewinner) {
    daten['gruppenspiele'].add({'name': team.name});
  }

  // K.O.-Phase Daten speichern
  daten['koPhase'] = [];
  for (Manschaft team in koTeilnehmer) {
    daten['koPhase'].add({'name': team.name});
  }

  // Speichern der Daten in einer JSON-Datei
  final File file = File('turnier_daten.json');
  file.writeAsString(jsonEncode(daten)).then((_) {
    print("Daten wurden erfolgreich gespeichert!");
  }).catchError((e) {
    print("Fehler beim Speichern der Daten: $e");
  });
}