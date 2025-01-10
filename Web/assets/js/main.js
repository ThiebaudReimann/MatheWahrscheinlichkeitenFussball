// Funktion zum Laden der Turnierdaten
function loadTurnierData() {
    fetch('/turnier_daten.json')
      .then(response => response.json())
      .then(data => {
        displayGruppenphase(data.gruppenphase);
        displayKOPhase(data.koPhase);
      })
      .catch(error => console.error('Fehler beim Laden der Daten:', error));
  }
  
  // Funktion zur Anzeige der Gruppenphase
  function displayGruppenphase(gruppenphase) {
    const gruppenphaseDiv = document.getElementById('gruppenphase');
    gruppenphase.forEach(gruppe => {
      const gruppeDiv = document.createElement('div');
      gruppeDiv.classList.add('card', 'mb-3');
      gruppeDiv.innerHTML = `
        <div class="card-header">Gruppe ${gruppe.gruppe}</div>
        <div class="card-body">
          <h5 class="card-title">Mannschaften:</h5>
          <ul class="list-group">
            ${gruppe.mannschaften.map(mannschaft => `
              <li class="list-group-item">
                <a href="#" onclick="displayTeamDetails('${mannschaft.name}')">${mannschaft.name}</a>
              </li>
            `).join('')}
          </ul>
        </div>
      `;
      gruppenphaseDiv.appendChild(gruppeDiv);
    });
  }
  
  // Funktion zur Anzeige der K.O.-Phase
  function displayKOPhase(koPhase) {
    const koPhaseDiv = document.getElementById('ko-phase');
    const koPhaseCard = document.createElement('div');
    koPhaseCard.classList.add('card');
    koPhaseCard.innerHTML = `
      <div class="card-header">K.O.-Phase</div>
      <div class="card-body">
        <ul class="list-group">
          ${koPhase.map(team => `<li class="list-group-item">${team}</li>`).join('')}
        </ul>
      </div>
    `;
    koPhaseDiv.appendChild(koPhaseCard);
  }
  
  // Funktion zur Anzeige der Team-Details
  function displayTeamDetails(teamName) {
    fetch('/turnier_daten.json')
      .then(response => response.json())
      .then(data => {
        const team = data.alleManschaften.find(m => m.name === teamName);
        const detailsDiv = document.getElementById('team-details');
        detailsDiv.innerHTML = `
          <h4>${team.name}</h4>
          <p><strong>Standort:</strong> ${team.location}</p>
          <p><strong>Chemie:</strong> ${team.chemistry}</p>
          <h5>Spieler:</h5>
          <ul class="list-group">
            ${team.spieler.map(spieler => `
              <li class="list-group-item">
                <strong>${spieler.name}</strong> (${spieler.position}) - Alter: ${spieler.alter}<br>
                <strong>Power:</strong> Angriffs: ${spieler.power.angriffsStaerke}, Abwehr: ${spieler.power.abwaehrStaerke}, Pass: ${spieler.power.passSicherheit}, Pace: ${spieler.power.pace}
              </li>
            `).join('')}
          </ul>
        `;
        const modal = new bootstrap.Modal(document.getElementById('teamModal'));
        modal.show();
      })
      .catch(error => console.error('Fehler beim Laden der Teamdetails:', error));
  }
  
  // Wenn die Seite geladen wird, die Daten anzeigen
  window.onload = loadTurnierData;
  