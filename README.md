# Gruppuppgift: Design och implementation av databasen "EventFlow"

## Affärsscenario: "EventFlow Solutions"

### Bakgrund
EventFlow Solutions är en snabbväxande startup som fokuserar på att digitalisera lokala idrottsföreningar och kulturhus. Idag hanterar kunderna sina biljettförsäljningar via manuella listor och Excel, vilket leder till överbokningar och svårigheter att spåra intäkter.

### Affärsmål
Företaget behöver en robust och skalbar databasmodul som ska ligga till grund för deras nya bokningsplattform. Systemet måste säkerställa att inga event blir överbokade, att varje biljett kan spåras till en unik order, och att ledningen i realtid kan se ekonomiska rapporter för varje genomfört arrangemang. Det är kritiskt att personuppgifter (e-post) hanteras korrekt och att systemet automatiskt kan rensa bort ofullständiga transaktioner för att frigöra databaskapacitet.

## Tech Leads tolkning
Här är min tekniska tolkning av kundens krav.

### Dataintegritet och schema
Vi bygger en klassisk relationsmodell enligt följande logik:

- `Users`: Vi måste ha en `UNIQUE`-constraint på e-post. Inga dubbletter i kundregistret.
- `Event`: Pris och kapacitet (`max_tickets`) måste vara positiva värden. Använd `CHECK` constraints direkt i tabellen så att vi aldrig får in felaktig data.
- `EventOrder`: Vi måste ha en `FOREIGN KEY` på `event_id` och `user_id`. En kund ska kunna ha flera ordrar över tid.
- `Tickets`: Vi måste ha en `FOREIGN KEY` på `order_id` för att varje unik order ska kunna innehålla en eller flera biljetter.

**TL;DR:** En `User` kan ha flera `EventOrders`, och varje `EventOrder` kan innehålla flera `Tickets`.

## 1. Skapa ER-modell
Skapa en ER-modell över den uttänkta databasen. Ni får välja antingen ett digitalt ritverktyg eller papper och penna. Det räcker med att ni visar kopplingarna mellan tabellerna och dess viktigaste fält (PK, FK och attribut).

## 2. Implementering i PostgreSQL
- Skapa en ny databas med namnet `eventflow`.
- Skapa tabellerna baserat på er ER-modell.
- Implementera nödvändiga constraints:
  - E-postadressen ska vara unik.
  - Max antal biljetter per event ska vara större än 0.
  - Pris per biljett ska vara större än 0.
- Seeda data: Lägg in testdata för användare, event, ordrar och biljetter så att ni kan testa era frågor. Se till att ha med minst ett event som saknar sålda biljetter.

## 3. SQL-frågor
Skriv frågor som löser följande krav från kunden:

- Orderdetaljer: Hämta alla ordrar för ett specifikt event. Inkludera användarens detaljer, orderdatum och eventets namn.
- Deltagarstatistik: Hämta antalet deltagare (`tickets`) för alla event, sorterat efter antal deltagare (flest först).
- Bokningskontroll: Gör en kontroll om det finns biljetter kvar till ett specifikt event. Använd `CASE WHEN` för att skriva ut ett felmeddelande (t.ex. "Eventet är fullbokat") om antalet sålda biljetter har nått `max_tickets`, annars skriv ut "Platser finns".
- Ekonomisk rapport: Beräkna den totala intäkten för ett specifikt event baserat på sålda biljetter.
- Styrelsevy: Skapa en vy (`VIEW`) som visar alla events med följande kolumner:
  - `event_id`, `event_title`, `event_date`, `max_tickets`
  - Antal sålda biljetter (`sold_tickets`)
  - Total intäkt (`total_revenue`)
- Krav: Även event som inte har sålt någon biljett ska visas i vyn (med `0` som värde).

## 4. Utökning: host_fee
Utöka tabellen `event` med kolumnen `host_fee`. Skapa sedan en sökning som listar de event där de totala biljettintäkterna överstiger denna avgift.

## Examinationskriterier för Godkänt (G)
- Databasdesign: En ER-modell som visar korrekt struktur och relationer.
- Implementering: Tabeller är korrekt skapade med rätt datatyper, `PRIMARY KEY` och `FOREIGN KEY`.
- SQL-frågor: Frågorna fungerar tekniskt och returnerar de resultat kunden efterfrågar.
- Datavalidering: Constraints för unika e-postadresser och positiva värden är på plats.
- Aggregerad data: Beräkningar i frågorna och vyn är matematiskt korrekta.

## Leverabler
- ER-modell (diagram och kort beskrivning).
- SQL-kod (en databasbackup-fil eller samlade SQL-frågor).
