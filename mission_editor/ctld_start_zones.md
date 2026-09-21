# CTLD-Startzonen – Operation Levant Reclamation

## 1. Zweck und Status

Stand: 2026-09-21

Dieses Dokument legt die Benennung und den minimalen Planungsumfang für den ersten CTLD-Integrationstest in der DEV-Mission fest.

Status: **Planung beschlossen; noch nicht im Mission Editor umgesetzt oder in DCS getestet.**

Die DEV-Mission ist weiterhin ein technischer Testträger. CTLD ist als Vendor-Framework geladen, aber noch nicht produktiv mit Theater Command verbunden.

Verbindlicher operativer Projektstand: `TASKS.md`.

## 2. Ergebnis der READ-ONLY-Bestandsaufnahme

Geprüfte Mission:

`C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz`

Bestätigter Stand der gespeicherten Mission:

- Keine Mission-Editor-Triggerzonen.
- Eine blaue F/A-18C-Client-Gruppe auf Akrotiri.
- Keine CTLD-fähige Transportgruppe.
- Keine CTLD-Template-Gruppen oder Logistikobjekte.
- CTLD-i18n und CTLD werden in der bestehenden Triggerkette geladen.
- Kein eigenes CTLD-Konfigurationsskript und keine aktive Theater-Command-CTLD-Brücke.

Quelltextbefund zur Zonenregistrierung: `ZoneFactory.allowedMissionEditorPrefixes` in `src/world/tc_zone_factory.lua` enthält nur `CAPTURE_` und `TC_ZONE_`. Die geplanten `CTLD_`-Zonen werden deshalb nicht zusätzlich als Theater-Command-Kampagnenzonen registriert. Dies ist ein reiner Quelltextbefund; ein Runtime-Test mit den neuen Zonen steht noch aus.

Die vorhandenen FOBs Ercan und Gecitkale existieren bislang als Kampagnen-State. Daraus folgt nicht, dass dort bereits eine physische, funktionierende CTLD-FOB-Infrastruktur existiert.

Diese Bestandsaufnahme hat weder die Mission verändert noch CTLD-Funktionalität in DCS getestet.

## 3. Verbindliche Namensentscheidung

Für neue Theater-Command-CTLD-Zonen gilt `NAMING_CONVENTIONS.md`, Abschnitt 15.

Es werden keine abweichenden Namen nur deshalb eingeführt, weil sie in den CTLD-Vendor-Defaults vorkommen.

### Geplante Pickup-Zone

`CTLD_PICKUP_BLUE_AKROTIRI_01`

Bedeutung: erster geplanter blauer Pickup-Punkt im Bereich Akrotiri, geplant als Pickup-Zone für CTLD-Truppen-/Fahrzeugoperationen.

Schema: `CTLD_PICKUP_SIDE_LOCATION_NUMBER`.

### Reservierter Dropoff-Name

`CTLD_DROPOFF_BLUE_ERCAN_FOB_01`

Bedeutung: Name für eine mögliche spätere KI-Transportoperation im Zusammenhang mit dem FOB-Projekt Ercan. Der Name ist reserviert. Ob und wann die Zone im Mission Editor angelegt wird, ist nicht entschieden.

Schema: `CTLD_DROPOFF_SIDE_LOCATION_ROLE_NUMBER`.

Die Rolle `FOB` beschreibt den vorgesehenen Kampagnenzweck. Sie bedeutet nicht, dass durch Anlegen dieser Zone bereits CTLD-Cargo, eine FOB-Erstellung oder ein Supply-Effekt implementiert wären.

Eine `ctld.dropOffZones`-Zone ist **keine** allgemeine Spieler-Crate-Abgabestelle. Sie wird in CTLD 1.6.1 im geprüften Codepfad zur automatischen Entladung von KI-Transportern genutzt (siehe Abschnitt 5). Die Ercan-Zone ist damit keine Voraussetzung für einen ersten Spieler-Crate-Test. Ihre spätere Anlage wird durch dieses Dokument nicht vorweggenommen.

Die genaue Position, der Radius und die Nutzbarkeit beider Zonen sind vor dem Anlegen anhand der tatsächlichen Mission zu prüfen. Insbesondere ist Ercan derzeit als `UNDER_CONSTRUCTION` im Theater-Command-State dokumentiert.

## 4. Verhältnis zu älteren Namensvorschlägen

`docs/05_logistics_system.md`, Abschnitt 18, enthält ältere, ausdrücklich nicht finale Beispielnamen, darunter:

- `CTLD_PICKUP_BLUE_AKROTIRI`
- `CTLD_DROPOFF_FOB_ERCAN`

Diese Beispiele sind kein verbindliches Schema für neue Zonen.

Für die weitere Planung gilt der Pickup-Name aus Abschnitt 3. Der dort genannte Ercan-Dropoff-Name ist lediglich für eine mögliche spätere KI-Transportoperation reserviert und keine Voraussetzung für den ersten praktischen Minimaltest. Die ältere Logistikdokumentation wird bei der späteren Dokumentationssynchronisierung entsprechend eingeordnet.

## 5. CTLD-Konfigurationsstrategie

Die unveränderte Vendor-Datei `vendor/ctld/CTLD.lua` enthält eigene Pickup- und Dropoff-Zonenlisten mit Default-Namen wie `pickzone1` und `dropzone1`.

Die gewählten Theater-Command-Namen werden dadurch nicht automatisch erkannt.

**Grundsatzentscheidung:** Die Anpassung erfolgt später durch eigene Theater-Command-Logik unter `src/`. `vendor/ctld/CTLD.lua` und `vendor/ctld/CTLD-i18n.lua` bleiben unverändert.

### Belegte technische Entscheidung (Quelltext-Audit CTLD 1.6.1)

Grundlage ist ein READ-ONLY-Audit von `vendor/ctld/CTLD.lua` v1.6.1. Alle folgenden Aussagen beruhen auf dem Quelltext und sind **noch nicht runtime-getestet**.

**Initialisierung**

- `CTLD.lua` setzt `ctld.dontInitialize` beim Laden selbst auf `false` (Zeile 52) und ruft am Dateiende `ctld.initialize()` auf, sofern `ctld.dontInitialize` nicht `true` ist (Zeilen 8708–8714). Die Initialisierung läuft damit automatisch beim Laden von `CTLD.lua`.
- `ctld.pickupZones` (Zeile 526) und `ctld.dropOffZones` (Zeile 553) werden von `CTLD.lua` selbst zugewiesen.
- `ctld.initialize()` (Zeilen 8194–8512) normalisiert die Zonenlisten einmalig an Ort und Stelle: Pickup-Zonen in den Zeilen 8285–8315, Dropoff-Zonen in den Zeilen 8318–8337.
- Außerdem setzt `ctld.initialize()` `ctld.callbacks` zurück (Zeile 8245) und registriert den Event-Handler (Zeile 8510).

**Lesen der Zonentabellen**

- Es wurde kein Cache der Pickup-/Dropoff-Zonenlisten gefunden. `ctld.inPickupZone()` (Zeilen 5502–5552) und `ctld.inDropoffZone()` (Zeilen 5569–5591) lesen `ctld.pickupZones` beziehungsweise `ctld.dropOffZones` bei jedem Aufruf direkt.
- `ctld.inPickupZone()` wird von `ctld.loadTroopsFromZone()` (Zeile 3216), `ctld.unloadTroops()` (Zeile 3291) und `ctld.checkAIStatus()` (Zeile 5835) aufgerufen.
- `ctld.inDropoffZone()` wird im geprüften Codepfad ausschließlich in `ctld.checkAIStatus()` (Zeilen 5825–5872, Aufrufe in den Zeilen 5853 und 5861) aufgerufen, und zwar nur für KI-Transporter ohne Spielernamen (Zeile 5834). Eine Dropoff-Zone dient damit in CTLD 1.6.1 der automatischen Entladung von KI-Transportern und der Smoke-Markierung (`ctld.refreshSmoke()`, Zeilen 5668–5720), nicht einer allgemeinen Spieler-Abgabestelle.
- `ctld.activatePickupZone()` (Zeilen 1633–1676) und `ctld.deactivatePickupZone()` (Zeilen 1684–1708) schalten nur den Aktivierungswert bereits vorhandener Pickup-Einträge. Sie registrieren keine Zonen. Eine öffentliche CTLD-Funktion zum Hinzufügen oder Entfernen von Pickup- oder Dropoff-Zonen wurde nicht gefunden.

**Konfigurationsstrategie (vorgesehen, noch NICHT runtime-getestet)**

Ein TC-eigenes Skript, das nach dem bestehenden CTLD-Ladetrigger läuft, kann dem Quelltext nach bereits normalisierte Einträge in `ctld.pickupZones` beziehungsweise `ctld.dropOffZones` ergänzen, ohne Vendor-Dateien zu ändern. Da CTLD die Tabellen nach der Initialisierung direkt liest, werden solche Einträge im Quelltext berücksichtigt. Das ist die vorgesehene Konfigurationsstrategie. Sie ist **noch nicht runtime-getestet** und **noch keine freigegebene Implementierung**.

Eintragsformate (nach der CTLD-Normalisierung; Seite 0 = beide, 1 = Rot, 2 = Blau):

- Pickup-Eintrag: `{ name, smokeEnum oder -1, numerisches Limit, aktiv als 1/0, Seite 0/1/2, optionales Flag }`. Unbegrenzt entspricht nach der CTLD-Normalisierung `10000`.
- Dropoff-Eintrag: `{ name, smokeEnum oder -1, Seite 0/1/2, 1 }`.

Regeln:

- Einträge eindeutig halten: Vor dem Ergänzen prüfen, ob der Zonenname bereits vorhanden ist. Bei erneutem Aufruf dürfen keine Duplikate entstehen.
- Die Werte müssen bereits normalisiert sein. Die Normalisierung findet nur in `ctld.initialize()` statt; nachträglich ergänzte Einträge wandelt CTLD nicht mehr um.
- Keine erneute Ausführung von `ctld.initialize()` zur Konfigurationsänderung: Der Aufruf normalisiert vorhandene numerische Werte erneut, setzt Callbacks zurück (Zeile 8245) und registriert den Event-Handler erneut (Zeile 8510).
- Eine Konfiguration vor der Initialisierung ist mit der bisherigen unveränderten Trigger- und Vendor-Ladekette nicht vorgesehen: `CTLD.lua` setzt `ctld.dontInitialize` und seine Konfigurationstabellen beim Laden selbst neu. Undokumentierte Metatable-Tricks werden nicht als Lösung geführt.

**Trennung: Pickup-Zone und Crate-Spawn**

- Eine Pickup-Zone allein erlaubt noch keinen Crate-Spawn.
- Die geprüfte Crate-Spawn-Funktion `ctld.spawnCrate()` (ab Zeile 2552, Prüfung in Zeile 2580) verlangt `ctld.inLogisticsZone()` (Zeilen 5614–5639). Diese Funktion prüft, ob der Transporter am Boden innerhalb der CTLD-Distanzgrenze (`ctld.maximumDistanceLogistic`, Zeile 425, Standardwert 200 m) einer passenden freundlichen Einheit beziehungsweise eines Statics aus `ctld.logisticUnits` steht.
- Ein Logistikobjekt am Startpunkt ist deshalb eine gesonderte Voraussetzung für einen späteren Crate-Spawn-Test.
- Nicht behauptet wird, dass am Zielpunkt zwingend ein Logistikobjekt nötig ist, um eine Crate dort abzusetzen. Zielerkennung und eine spätere Theater-Command-Supply-Wirkung sind getrennte, noch nicht implementierte Fragen.

## 6. Bewusst noch nicht festgelegt

Für den ersten Integrationstest sind noch offen:

- **Offene Entscheidung:** Der erste praktische Minimaltest wird erst separat auf „Truppen-Pickup" oder „Crate-Spawn/Transport" festgelegt.
- Konkreter CTLD-fähiger Transportflugzeug- oder Helikoptertyp und verfügbarer Client-Slot.
- Reale Objekte in der Mission und ihre Positionen und Radien (Zonen, Transporter, gegebenenfalls ein Logistikobjekt am Startpunkt).
- CTLD-Cargo- beziehungsweise Crate-Typen.
- Zuordnung einer CTLD-Lieferung zu Theater-Command-Supply oder FOB-Baufortschritt.
- Benötigte Template-Gruppen und Logistikobjekte.
- Runtime-Nachweis der nachträglichen Zonenregistrierung. Der Quelltext belegt die vorgesehene Strategie (Abschnitt 5), getestet ist sie noch nicht.

Diese Punkte werden hier nicht entschieden. Es wird keine neue Implementierung beschlossen.

Der reservierte Dropoff-Name bei Ercan ist keine bereits funktionierende FOB-Versorgung und keine Voraussetzung für einen ersten Spieler-Crate-Test.

## 7. Abgrenzung und nächster Prüfpunkt

Mit dieser Datei werden noch keine Zonen im Mission Editor angelegt und keine Lua-Dateien, Trigger oder Vendor-Frameworks verändert.

Der nächste **separat freizugebende Einzelschritt** ist die isolierte technische Erprobung der nachträglichen CTLD-Zonenregistrierung (Abschnitt 5) für die vereinbarten Zonennamen, ohne Vendor-Änderung. Er beginnt erst nach gesonderter Freigabe.

Die Konfigurationsentscheidung ist quelltextbelegt, aber noch nicht runtime-getestet. Danach folgen, jeweils separat freizugeben, eine einzelne Umsetzung, eine Einbettungsprüfung und ein isolierter Runtime-Test.

`productiveRestore=false` bleibt unverändert. Bereits bestandene Read-Neutrality-Regressionen werden dafür nicht wiederholt.
