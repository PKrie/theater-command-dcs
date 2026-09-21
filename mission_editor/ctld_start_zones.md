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

Bedeutung: erster geplanter blauer Pickup-Punkt im Bereich Akrotiri.

Schema: `CTLD_PICKUP_SIDE_LOCATION_NUMBER`.

### Geplante Dropoff-Zone

`CTLD_DROPOFF_BLUE_ERCAN_FOB_01`

Bedeutung: erster geplanter blauer Dropoff-Punkt zur späteren Unterstützung des FOB-Projekts Ercan.

Schema: `CTLD_DROPOFF_SIDE_LOCATION_ROLE_NUMBER`.

Die Rolle `FOB` beschreibt den vorgesehenen Kampagnenzweck. Sie bedeutet nicht, dass durch Anlegen dieser Zone bereits CTLD-Cargo, eine FOB-Erstellung oder ein Supply-Effekt implementiert wären.

Die genaue Position, der Radius und die Nutzbarkeit beider Zonen sind vor dem Anlegen anhand der tatsächlichen Mission zu prüfen. Insbesondere ist Ercan derzeit als `UNDER_CONSTRUCTION` im Theater-Command-State dokumentiert.

## 4. Verhältnis zu älteren Namensvorschlägen

`docs/05_logistics_system.md`, Abschnitt 18, enthält ältere, ausdrücklich nicht finale Beispielnamen, darunter:

- `CTLD_PICKUP_BLUE_AKROTIRI`
- `CTLD_DROPOFF_FOB_ERCAN`

Diese Beispiele sind kein verbindliches Schema für neue Zonen.

Für den hier geplanten Minimaltest gelten die beiden Namen aus Abschnitt 3 dieses Dokuments. Die ältere Logistikdokumentation wird bei der späteren Dokumentationssynchronisierung entsprechend eingeordnet.

## 5. CTLD-Konfigurationsstrategie

Die unveränderte Vendor-Datei `vendor/ctld/CTLD.lua` enthält eigene Pickup- und Dropoff-Zonenlisten mit Default-Namen wie `pickzone1` und `dropzone1`.

Die gewählten Theater-Command-Namen werden dadurch nicht automatisch erkannt.

**Grundsatzentscheidung:** Die Anpassung erfolgt später durch eigene Theater-Command-Logik unter `src/`. `vendor/ctld/CTLD.lua` und `vendor/ctld/CTLD-i18n.lua` bleiben unverändert.

Eine mögliche Lösung ist ein separates eigenes Konfigurationsmodul, das nach dem CTLD-Vendor geladen wird. Ob und wie bereits initialisierte CTLD-Zonenlisten dabei sicher aktualisiert werden können, ist noch nicht nachgewiesen.

Vor der Implementierung ist deshalb gezielt zu klären:

- Welche CTLD-Datenstrukturen bei der Initialisierung aus den Zonenlisten entstehen.
- Ob eine unterstützte nachträgliche Registrierung oder Aktualisierung der Zonen existiert.
- Ob eine andere Lade- beziehungsweise Initialisierungsstrategie erforderlich ist.

Bestätigter Quelltextbefund (CTLD 1.6.1): `CTLD.lua` ruft am Dateiende `ctld.initialize()` auf, sofern `ctld.dontInitialize` nicht `true` ist. `CTLD.lua` setzt `ctld.dontInitialize` beim Laden selbst auf `false`. Die Initialisierung läuft damit beim Laden von `CTLD.lua`. Ein bloßes Setzen von `ctld.dontInitialize` vor dem Laden ist daher keine nachgewiesene Lösung.

Ein direktes Überschreiben von `ctld.pickupZones` oder `ctld.dropOffZones` nach der Initialisierung ist **noch keine freigegebene Implementierung**. Die korrekte Einbindung muss zunächst am tatsächlichen CTLD-Code geprüft und anschließend isoliert getestet werden.

## 6. Bewusst noch nicht festgelegt

Für den ersten Integrationstest sind noch offen:

- Konkreter CTLD-fähiger Transportflugzeug- oder Helikoptertyp und verfügbarer Client-Slot.
- Tatsächliche Positionen und Radien der geplanten Zonen.
- CTLD-Cargo- beziehungsweise Crate-Typen.
- Zuordnung einer CTLD-Lieferung zu Theater-Command-Supply oder FOB-Baufortschritt.
- Benötigte Template-Gruppen und Logistikobjekte.
- Technisch verifizierter Initialisierungs- und Konfigurationspfad.

Der geplante Dropoff bei Ercan ist zunächst ein Testziel, keine bereits funktionierende FOB-Versorgung.

## 7. Abgrenzung und nächster Prüfpunkt

Mit dieser Datei werden noch keine Zonen im Mission Editor angelegt und keine Lua-Dateien, Trigger oder Vendor-Frameworks verändert.

Der nächste **separat freizugebende Einzelschritt** ist eine gezielte READ-ONLY-Prüfung der CTLD-Zoneninitialisierung und der Möglichkeiten, die beiden vereinbarten Zonennamen ohne Vendor-Änderung zu registrieren.

Erst nach einer technisch belegten Konfigurationsentscheidung folgen eine einzelne Umsetzung, Einbettungsprüfung und ein isolierter Runtime-Test.

`productiveRestore=false` bleibt unverändert. Bereits bestandene Read-Neutrality-Regressionen werden dafür nicht wiederholt.
