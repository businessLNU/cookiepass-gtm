# Cookiepass CMP – Google Consent Mode v2 Template für Google Tag Manager

[English](README.md) · **Deutsch**

[Cookiepass](https://cookiepass.io/) ist eine Consent Management Platform (CMP)
für Cookie-Banner und die Verwaltung von Website-Einwilligungen. Dieses
Google-Tag-Manager-Template verbindet die Entscheidungen im Cookiepass-Banner
mit **Google Consent Mode v2**. Website-Betreiber, Agenturen und Entwickler
können damit den Einwilligungsstatus für kompatible Google-Analytics-4- und
Google-Ads-Tags an Google Tag Manager (GTM) übergeben.

Die Vorlage lädt das Cookiepass-CDN-Skript, setzt sichere Consent-Defaults
und verarbeitet vollständige Zustimmung, individuelle Auswahl und Widerruf.
Vorhandene Entscheidungen werden nach einem Seitenwechsel wiederhergestellt.
Die Consent-Mode-Funktion muss im jeweiligen Cookiepass-Tarif verfügbar sein.

**English summary:** Cookiepass CMP template for Google Tag Manager with
Google Consent Mode v2. Connect cookie banner choices to Google's consent
states, including analytics consent, advertising consent, saved preferences
and consent withdrawal.

- [Cookiepass CMP und Cookie-Banner](https://cookiepass.io/)
- [GTM-Vorlage herunterladen](template.tpl)
- [Fehler melden und Fragen stellen](https://github.com/businessLNU/cookiepass-gtm/issues)

## Funktionen der Cookiepass-GTM-Integration

- Native Consent-APIs `setDefaultConsentState` und `updateConsentState` für GTM.
- Vier Google-Consent-Zustände mit `denied` als Standard und 500 ms Wartezeit.
- Individuelle Freigabe von Statistik und Marketing sowie erneute Ablehnung.
- Data-Layer-Ereignis `cookiepass_consent_update` für benutzerdefinierte Trigger.
- Öffentliche Website-ID als einziges Konfigurationsfeld; kein API-Schlüssel.
- Eingebettetes Cookiepass-Symbol: PNG, 180 × 180 Pixel, kleiner als 50 kB.
- Einmalige Initialisierung, damit eine bestehende Entscheidung erhalten bleibt.

## Veröffentlichungsstand

Der kompatible Cookiepass-Core ist seit dem 06.10.2026 auf dem CDN verfügbar.
Die Browserprüfungen mit der öffentlichen CDN-Datei sind bestanden.
Am 06.10.2026 zeigte der GTM-Editor einen Fehler in allen fünf Testfällen:
Die Objekt-API `templateStorage` wurde mit `mock()` statt `mockObject()`
ersetzt. Die Testfälle und die lokale Testnachbildung sind korrigiert;
alle fünf Fälle bestehen lokal. Alle fünf Tests bestehen auch im echten GTM-Editor. Der finale Export enthält
die bestätigten Gallery-Bedingungen. Tag Assistant zeigte eine fehlende Leseberechtigung für den Callback. Diese
Vorlage erlaubt jetzt gezielt Lesen und Schreiben des Callbacks. Damit zeigt Tag
Assistant keine Berechtigungsfehler mehr, und die Cookiepass-Brücke läuft im GTM-Modus (geprüft am 06.10.2026). Dieses Repository enthält den zur Einreichung
vorbereiteten Code; eine Gallery-Aufnahme oder Google-CMP-Zertifizierung ist
damit nicht verbunden.

## Cookiepass im Google Tag Manager einrichten

1. Eine Website in Cookiepass einrichten und ihre öffentliche `cbid` bereithalten.
   Die kompatible Core-Version wird über `https://cdn.cookiepass.io/cp.js` geladen.
2. `template.tpl` unter **Vorlagen → Tag-Vorlagen → Neu → Importieren** laden.
3. Ein Tag mit dieser Vorlage anlegen. Das englische Feld **Cookiepass website ID (cbid)**
   verwendet `cookiepassId`, die öffentliche
   Website-ID aus `data-cbid` im Cookiepass-Einbaucode, kein API-Schlüssel.
4. Trigger **Consent Initialization – All Pages**, einmal pro Seite.
   Das CMP-Tag selbst darf nicht durch zusätzliche Einwilligungsanforderungen
   blockiert werden, weil es den Einwilligungsstatus erst bereitstellt.
5. Die bisherige direkte Cookiepass-Einbindung für diesen GTM-Einbau entfernen.
   Head-Snippet und GTM-Vorlage sind alternative Einbauwege.
6. Im Vorschau-Modus erstmals besuchen, ablehnen, teilweise und vollständig
   zustimmen, widerrufen und die Seite neu laden. Den Consent-Tab in Tag
   Assistant und das Ereignis `cookiepass_consent_update` prüfen.

Standardmäßig sind `ad_storage`, `analytics_storage`, `ad_user_data` und
`ad_personalization` abgelehnt; `wait_for_update` ist 500 Millisekunden.
Die Vorlage aktualisiert die Zustände mit den nativen Sandbox-Consent-APIs.
Gespeicherte Entscheidungen und neue Banner-Entscheidungen verwenden denselben
vor dem Laden registrierten Callback. Die vorhandenen Cookiepass-Tarifregeln
gelten weiterhin; bei deaktivierter Consent-Mode-Funktion bleibt der Default.

## So werden die Consent-Kategorien zugeordnet

| Cookiepass-Kategorie | Google Consent Mode v2 | Freigabe |
| --- | --- | --- |
| Statistik (`statistics`) | `analytics_storage` | Nur bei Zustimmung zu Statistik |
| Marketing (`marketing`) | `ad_storage` | Nur bei Zustimmung zu Marketing |
| Marketing (`marketing`) | `ad_user_data` | Nur bei Zustimmung zu Marketing |
| Marketing (`marketing`) | `ad_personalization` | Nur bei Zustimmung zu Marketing |

Bei Ablehnung oder Widerruf werden die entsprechenden Zustände wieder auf
`denied` gesetzt. Das CMP-Tag läuft bereits vor einer Einwilligungsentscheidung,
damit es diesen Ausgangszustand bereitstellen kann.

Die GTM-Einbindung lädt den Core asynchron im manuellen Blockierungsmodus.
Tags im Container müssen ihre eingebauten bzw. zusätzlichen Consent-Prüfungen
korrekt verwenden. Skripte außerhalb des Containers, die bereits ausgeführt
wurden, lassen sich durch diesen späteren GTM-Einbau nicht rückwirkend blockieren.

## Berechtigungen

| API/Bereich | Zugriff |
| --- | --- |
| Consent | Schreiben der vier oben genannten Zustände |
| Skript laden | Nur `https://cdn.cookiepass.io/cp.js?*` |
| `cookiepassGtmConsentUpdate` | Lesen und Schreiben des Callbacks |
| `Cookiepass.googleConsentMode` | Ausführen der Modusprüfung |
| `dataLayer` | Lesen und Schreiben für `createQueue` |
| Template-Speicher | Status der einmaligen Initialisierung |

## In der GTM Community Template Gallery veröffentlichen

1. Im GTM-Editor importieren, die enthaltenen Tests ausführen und mit Tag
   Assistant prüfen. Die Gallery-Nutzungsbedingungen lesen und als Betreiber
   selbst unter **Info** bestätigen. Anschließend erneut als `template.tpl`
   exportieren; Kategorie `UTILITY` beibehalten.
2. Ein öffentliches GitHub-Repository anlegen. Genau eine `template.tpl`, diese
   `README.md`, `README.de.md`, `LICENSE` (Apache 2.0) und `metadata.yaml` liegen im Stammverzeichnis
   des Branches `main`. GitHub Issues und Benachrichtigungen aktivieren.
3. Die Template-Datei committen. Den vollständigen 40-stelligen Commit-SHA
   ermitteln, beispielsweise mit `git rev-parse HEAD`.
4. In `metadata.yaml` die Dokumentations-URL und den Versions-SHA einsetzen und
   diese Änderung separat committen. Der SHA muss auf den Commit mit der
   freizugebenden Template-Datei zeigen, nicht auf einen erfundenen Beispielwert.
5. Das Repository pushen. Unter https://tagmanager.google.com/gallery über das
   Menü **Submit Template** die Repository-URL einreichen.
6. Für Updates neue Versions-SHAs mit Änderungsnotizen oben in `versions`
   ergänzen; veröffentlichte ältere Versionen behalten.

Die aktuelle Einreichung erfolgt über das Gallery-Formular mit einem GitHub-
Repository. Ein Pull Request in ein Google-Cloud-Repository gehört nicht zu
diesem dokumentierten Ablauf. Die Dokumentations-URL in `metadata.yaml` zeigt
auf dieses Repository. Der Versions-SHA in der beiliegenden metadata.yaml verweist auf den geprüften
finalen Template-Commit. Dieser Wert muss auch in der öffentlichen metadata.yaml
stehen. Ein reiner Metadata-Commit ändert den Template-Versions-SHA nicht.

## Häufige Fragen

### Muss die bisherige Cookiepass-Einbindung geändert werden?

Für einen Wechsel zum GTM-Template wird die direkte Einbindung durch den
GTM-Tag ersetzt. Websites, die den bisherigen Head-Einbau weiterverwenden,
können ihn beibehalten. Die CMP darf nicht über beide Wege zugleich geladen
werden.

### Kann ich eigene GTM-Trigger für Consent-Änderungen verwenden?

Ja. Verwende einen Trigger für das benutzerdefinierte Ereignis
`cookiepass_consent_update`. Die Consent-Prüfungen der ausgelösten Tags müssen
weiter passend zu ihrem Zweck eingerichtet sein.

### Ist das gesamte Cookiepass-System öffentlich?

Dieses Repository stellt die GTM-Integration unter [Apache 2.0](LICENSE)
bereit. Das Template lädt den CMP-Core vom Cookiepass-CDN; der Quelltext des
Cookiepass-Backends ist kein Bestandteil dieses Repositorys.

## Support und Fehlerberichte

Für technische Fehler an diesem Template ein
[GitHub Issue im Cookiepass-GTM-Repository](https://github.com/businessLNU/cookiepass-gtm/issues)
erstellen. Nenne die Template-Version, den Browser und die betroffenen
Einwilligungsschritte. Informationen zum Produkt findest du auf der
[Cookiepass-Website](https://cookiepass.io/).

## Offizielle Dokumentation

- [Consent-APIs und Reihenfolge](https://developers.google.com/tag-platform/tag-manager/templates/consent-apis)
- [Sandbox-APIs](https://developers.google.com/tag-platform/tag-manager/templates/api)
- [Berechtigungen](https://developers.google.com/tag-platform/tag-manager/templates/permissions)
- [Gallery-Einreichung](https://developers.google.com/tag-platform/tag-manager/templates/gallery)
