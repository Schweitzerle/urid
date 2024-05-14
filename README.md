# urid

Das Projekt ist noch sehr chaotisch. Das ist aber irgwie die Weise, welche für mich persönlich am
Effektivsten ist. Ich habe den groben AppFlow wie ich ihn dir damals geschickt habe so implementiert
mit vielen Platzhalter Texten und Screens, einfach nur um mir einen besseres Gespür für die App zu
geben.
In dem IntroScreen kannst du einfach durchswipen und dann auf done klicken. Dann gelangst du in den
TaskOverview Screen, welchen ich ja damals so gedacht habe, aber wir ja in dem überarbeitetn AppFlow
geändert haben. Für Testzwecke ist dieser Screen trotzdem super.
Dort kannst du dann die verschiedenen Gesten auswählen. Es folgen dann wieder Platzhalter für die
jeweilige Task-Introduction.
Dann folgen die jeweiligen Ansichten des Passes mit den Gesten. Ich habe alle schon mal grob
implementiert aber es ist bis jetzt nur die Button gedrückt halten und Bildschirm abdecken Geste
fertig. Fertig heißt aber auch nur die Geste selst mit der Pass-Interaktion. Weiferführende Logik
wie den Zähler der Versuche usw. ist noch nicht implementiert.
Durch einen Doppelklick auf den Pass (bei allen verschiedenen Gesten) lässt einen
FloatingActionButton unten rechts erscheinen. Wenn man darauf Klickt gelangt man zu dem
Questionnaire.
Dabei habe ich verschieden Designoptionen für die Slider ausgetestet, kannst mir gerne mal deine Meinung sagen,
welche Designoption du am besten fändest. Dann kann man weiterklicken und man gelangt wieder zum
TaskOverview Screen.
Bei dem Fingerprint wird der, nach doppelklick auf den Pass erscheinende, FloatingActionButton als
FingerprintSensor Auslöser benutzt. Bei diesem Widget kann man auch nicht weiter zum Quiestionnaire.
Durch den SystemBackButton kommt auch immer ein Dialog, welcher einen den momentanen Screen zum
vorherigen verlassen lässt.
Ist alles sehr chatotisch, aber wie gesagt, so arbeite ich komischerweise am besten :D
Ich hoffe du findest dich einigermaßen zurecht.