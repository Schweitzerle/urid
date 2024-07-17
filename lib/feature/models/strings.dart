class Strings {
  // General strings used in multiple classes
  static const String yes = "Ja";
  static const String no = "Nein";
  static const String ok = 'OK';
  static const String cancel = "Abbrechen";
  static const String next = "Weiter";
  static const String start = "Start";
  static const String repetitionsLeft = "Noch 3 Wiederholungen!";
  static const String twoRepetitionsLeft = "Noch 2 Wiederholungen!";
  static const String oneRepetitionLeft = "Noch 1 Wiederholung!";
  static const String questionnaireTitle = "Fragebogen";
  static const String publicView = "Öffentliche Ansicht";
  static const String privateView = "Private Ansicht";
  static const String nextStepAutoBody =
      "Nach dem Testen der Interaktionsformen werden Sie automatisch "
      "zum nächsten Schritt der Studie weitergeleitet.";
  static const String questionnaireTaskBody =
      "Füllen Sie nach Abschluss bitte den folgenden Fragebogen aus. Alle Fragen beziehen sich dabei auf die zuletzt verwendete Interaktionsform. \n\n"
      "Wenn Sie auf \"Weiter\" klicken gelangen Sie zur Task.";
  static const String finished = "Weiter";
  static const String nextTask = "Nächste Task";
  static const String tutorial = "Tutorial";
  static const String taskOverviewPrefix = "Führen Sie die Interaktion";
  static const String taskOverviewPostfix = " erneut aus. \n\n"
  "Klicken Sie auf \"Weiter\" um die Task erneut auszuführen.";

  // Strings for EndScreen
  static const String endScreenThankYouTitle =
      "Vielen Dank für Ihre Teilnahme an der Studie!";
  static const String endScreenThankYouBody =
      "Sie können das Smartphone nun dem Studienleiter zurückgeben. \n\n"
      "Ich wünschen Ihnen noch einen schönen Tag!";

  // Strings for ErrorScreen
  static const String errorScreenTitle = "Ups, etwas ist schiefgelaufen!";
  static const String errorScreenBody =
      "Bitte wenden Sie sich an die Studienleitung für Unterstützung.";

  // Strings for IntroScreen
  static const String welcomeTitle = "Hallo";
  static const String welcomeBody =
      "Vielen Dank, dass Sie an dieser Studie teilnehmen. "
      "Wir führen Sie Schritt für Schritt durch das Experiment.";
  static const String studyProcessTitle = "Überblick";
  static const String studyProcessBody =
      "Diese Studie findet im Rahmen der Bachelorarbeit von Julian Schweizer "
      "am Lehrstuhl für Medieninformatik statt. \n\n"
      "Wir untersuchen das Sicherheits- und Kontrollgefühl bei der Interaktion mit digitalen Ausweisen. "
      "Sie können bei diesem Experiment keine Fehler machen: "
      "Wir testen nicht Sie, sondern ausschließlich die vorgeschlagenen Interaktionsformen.";
  static const String taskTitle = "Ihre Aufgabe";
  static const String taskBody =
      "Im Rahmen der Studie werden Sie einen digitalen Ausweis sehen. "
      "Stellen Sie sich vor, dieser Ausweis würde Ihnen gehören. \n\n"
      "Sie müssen sich im Kontext einer Sichtkontrolle mit diesem Ausweis gegenüber einer anderen Person identifizieren. "
      "Der Ausweis beinhaltet neben öffentlichen Informationen auch private Inhalte, "
      "die Sie dabei nicht mit der anderen Person teilen möchten. \n\n"
      "Die verschiedenen Interaktionsformen dienen der bewussten Freigabe des öffentlichen Teils des Ausweises.";
  static const String confidentialityTitle = "Vertraulichkeit";
  static const String confidentialityBody =
      "Auf den nächsten Seiten informieren wir Sie über alle Daten, die wir während des Experiments aufzeichnen. \n\n"
      "Alle diese Daten werden anonymisiert gespeichert und ausschließlich zu Forschungszwecken verwendet. \n\n"
      "Zur späteren Auswertung wird eine zufällige ID generiert und mit den gespeicherten Daten verknüpft. \n\n"
      "Sie können sich jederzeit mit Fragen an den Versuchsleiter wenden. \n\n"
      "Klicken Sie auf \"Weiter\" um zur Einverständniserklärung zu gelangen.";
  static const String interactionMethodsTitle = "Ablauf";
  static const String interactionMethodsBody =
      "Während des Experiments haben Sie Gelegenheit, vier verschiedene Möglichkeiten zur Freigabe des digitalen Ausweises zu testen. \n\n"
      "Wir beschreiben Ihnen jedes Mal die jeweilige Interaktionsform und Sie nutzen diese anschließend insgesamt dreimal.";
  static const String questionnaireBody =
      "Im Anschluss an jeden Durchlauf füllen Sie direkt am Smartphone einen kurzen Fragebogen durch. \n\n"
      "Mit diesem Fragebogen messen wir Ihr Kontroll- und Sicherheitsgefühl gegenüber der jeweiligen Interaktionsform.";
  static const String interviewTitle = "Interview";
  static const String interviewBody =
      "Am Ende des Experiments befragen wir Sie kurz zu Ihren Meinungen und Erfahrungen in Bezug auf die getesteten Interaktionsformen. \n\n"
      "Haben Sie noch Fragen zum Studienablauf?";
  static const String readyTitle = "Bereit?";
  static const String readyBody =
      "Wenn Sie bereit sind, beginnen wir mit der ersten Aufgabe. \n\n"
      "Denken Sie daran, auf Ihr Sicherheitsgefühl und Ihre Kontrolle während der Nutzung des Mitarbeiterausweises zu achten. \n\n"
      "Viel Erfolg!";
  static const String doneIntro = "Start";
  static const String nextIntro = "Nächster";

  // Strings for AudioRecorderScreen
  static const String recordingInProgress = "Aufnahme läuft...";
  static const String noRecordingAvailable = "Keine Aufnahme vorhanden...";
  static const String recordedAudioFile = "Aufgenommene Audiodatei";
  static const String csvFileResults = "CSV-Datei Studienergebnisse";
  static const String consentFormPdf = "Einverständniserklärung PDF";
  static const String deleteRecording = "Aufnahme löschen";
  static const String sendData = "Daten versenden";
  static const String confirmation = "Bestätigung";
  static const String navigateToNextScreenConfirmation =
      "Möchten Sie wirklich zum nächsten Bildschirm wechseln? "
      "Nicht versendete Daten gehen verloren!";
  static const String sendingData = "Daten werden gesendet...";
  static const String sentData = "Daten gesendet";
  static const String errorSendingData = "Fehler beim Senden der Daten";

  // Strings for ButtonTaskIDIntro
  static const String buttonTaskTitle = "Drücken und Halten";
  static const String buttonTaskBody =
      "Auf den folgenden Bildschirmen sehen Sie einen digitalen Ausweis, "
      "der öffentliche und private Informationen enthält. \n\n"
      "Weisen Sie sich gegenüber dem Versuchsleiter mit diesem Ausweis aus.";
  static const String buttonTaskBodyBold =
      " Drücken und Halten Sie dabei den Ausweis an einer beliebige Stelle, um die privaten Informationen im Ausweis auszublenden.";
  static const String buttonTaskOverview = " Drücken und Halten";

  // Strings for CoverTaskIDIntro
  static const String coverTaskTitle = "Verstecken von privaten Inhalten";
  static const String coverTaskBody =
      "Auf den folgenden Bildschirmen sehen Sie einen digitalen Ausweis, "
      "der öffentliche und private Informationen enthält. \n\n"
      "Weisen Sie sich gegenüber dem Versuchsleiter mit diesem Ausweis aus.";
  static const String coverTaskBodyBold =
      " Verdecken Sie dabei mit Ihrer Hand die privaten Informationen des Ausweises.";
  static const String coverTaskOverview = " Bildschirm Abdecken";
  static const String nextStepTitle = "Nächster Schritt";
  static const String nextStepBody =
      "Klicken Sie nach Abschluss der Interaktion doppelt auf den Ausweis, "
      "um den Button anzuzeigen, mit dem Sie zum nächsten Schritt des Experiments gelangen.";

  // Strings for FlipTaskIDIntro
  static const String flipTaskTitle = "Flippen/Neigen";
  static const String flipTaskBody =
      "Auf den folgenden Bildschirmen sehen Sie einen digitalen Ausweis, "
      "der öffentliche und private Informationen enthält. \n\n"
      "Weisen Sie sich gegenüber dem Versuchsleiter mit diesem Ausweis aus.";
  static const String flipTaskBodyBold =
      " Kippen Sie das Smartphone nach vorne, um die privaten Informationen im Ausweis auszublenden.";
  static const String flipTaskBodyPostfix =
      " Wenn Sie das Smartphone wieder zurückkippen, werden die privaten Informationen wieder sichtbar.";
  static const String flipTaskOverview = " Flippen/Neigen";

  // Strings for VolumeButtonTaskIDIntro
  static const String volumeTaskTitle = "Schalter betätigen";
  static const String volumeTaskBody =
      "Auf den folgenden Bildschirmen sehen Sie einen digitalen Ausweis, "
      "der öffentliche und private Informationen enthält. \n\n"
      "Weisen Sie sich gegenüber dem Versuchsleiter mit diesem Ausweis aus.";
  static const String volumeTaskBodyBold =
      " Halten Sie die Taste zum Erhöhen der Lautstärke für eine gewisse Zeit gedrückt, "
      "um die privaten Informationen im Ausweis auszublenden.";
  static const String volumeTaskBodyPostfix =
      " Wenn Sie die Taste zum Verringern der Lautstärke für eine gewisse Zeit gedrückt halten, "
      "werden die privaten Informationen wieder sichtbar.";
  static const String volumeTaskOverview = " Schalter betätigen";

  // Strings for CountdownDialog
  static const String pauseTitle = "Pause";
  static const String nextTaskIn = "Nächste Aufgabe in";
  static const String seconds = "Sekunden...";

  // Strings for CustomWillPopScopeWidget
  static const String exitConfirmationTitle = "Bitte bestätigen!";
  static const String exitConfirmationContent =
      "Wollen Sie den Vorgang wirklich beenden? "
      "Bitte konsultieren Sie zuerst den Versuchsleiter!";

  // Strings for ConsentForm
  // PageView 1
  static const String consentInfo1Title = 'Aufzeichnung der Interaktionsaktivität';
  static const String consentInfo1Description =
      'Wir zeichnen Zeitpunkt, Dauer und Art aller Interaktionen auf, die Sie während des Experiments am Smartphone durchführen. \n\n'
      'Dazu gehören die Verwendung des Touch-Screens, die Betätigung von Hardware-Buttons, sowie die Position- und Lageveränderungen des Geräts. \n\n'
      'Zugriff auf die Rohdaten haben ausschließlich der Versuchsleiter sowie die Betreuer und Gutachter der Arbeit. \n\n'
      'Die Auswertung erfolgt durch den Versuchsleiter. Die Ergebnisse werden in aggregierter Form gespeichert.';

  // PageView 2
  static const String consentInfo2Title = 'Fragebögen';
  static const String consentInfo2Description =
      'Ihre Angaben aus dem Fragebogen werden anonymisiert gespeichert. \n\n'
      'Zugriff auf die Rohdaten haben ausschließlich der Versuchsleiter sowie die Betreuer und Gutachter der Arbeit. \n\n'
      'Die Auswertung erfolgt durch den Versuchsleiter. Die Ergebnisse werden in aggregierter Form gespeichert.';

  // PageView 3
  static const String consentInfo3Title = 'Interviews';
  static const String consentInfo3Description =
      'Wir zeichnen das Interview als Audio-Mitschnitt auf. \n\n'
      'Der Mitschnitt dient der späteren Transkription und Auswertung der Interviews. \n\n'
      'Zugriff auf die Aufzeichnungen hat ausschließlich der Versuchsleiter. \n\n'
      'Die Aufzeichnungen werden nach der Transkription und Auswertung gelöscht. \n\n'
      'Die Auswertung der im Interview gesammelten Erkenntnisse erfolgt anonymisiert.';

  // PageView 4
  static const String consentTitle = "Einverständniserklärung";
  static const String consentDescription =
      "Ich erkläre mich damit einverstanden, an der Studie teilzunehmen. \n\n"
      "Ich willige dazu in die mir beschriebene Speicherung und Auswertung der genannten Daten ein. \n\n"
      "Ich kann mein Einverständnis jederzeit durch eine formlose E-Mail an den Versuchsleiter widerrufen.";
  static const String signatureHint = "Bitte unterschreiben Sie, bevor Sie fortfahren.";

  static const String dateLabel = "Datum: ";
  static const String signatureLabel = "Unterschrift:";
  static const String tapToSign = "Zum Unterschreiben tippen";
  static const String drawYourSignature = "Zeichnen Sie Ihre Unterschrift";
  static const String clear = "Löschen";
  static const String save = "Speichern";
  static const String confirmationTitle = "Bestätigung";
  static const String confirmationContent =
      "Möchten Sie wirklich zum nächsten Bildschirm wechseln? \n\n"
      "Stellen Sie sicher, dass Sie die Einverständniserklärung unterzeichnet haben!";

  // Strings for AgencyQuestionnaireWidget
  static const String movementControlQuestion =
      "1. Es fühlte sich so an, als hätte ich die Gesteninteraktion während der Aufgabe unter Kontrolle gehabt.";
  static const String controlFeelingQuestion =
      "3. Ich hatte das Gefühl, während der ganzen Aufgabe die Kontrolle zu haben.";
  static const String viewChangeQuestion =
      "2. Es fühlte sich so an, als würde ich mit der gerade durchgeführten Interaktionsform den Wechsel zwischen den beiden Ansichten verursachen.";
  static const String taskAwarenessQuestion =
      "4. Ich war mir während der gesamten Aufgabe meiner Handlungen bewusst.";
  static const String interactionFeedbackQuestion =
      "5. Die Rückmeldungen auf meine Interaktionen fühlten sich direkt und natürlich an.";
  static const String dataPrivacyQuestion =
      "6. Ich hatte das Gefühl, dass meine persönlichen Daten während der Aufgabe sicher sind.";
  static const String controlOverSharedContentQuestion =
      "7. Es fühlte sich so an, als hätte ich die Kontrolle darüber gehabt, wann und welche Informationen geteilt werden.";


  static const String cantJudgeLabel = "Kann ich nicht bewerten";
  static const String stronglyDisagree = "Stimme überhaupt nicht zu";
  static const String disagree = "Stimme nicht zu";
  static const String somewhatDisagree = "Stimme eher nicht zu";
  static const String neutral = "Weder noch";
  static const String somewhatAgree = "Stimme eher zu";
  static const String agree = "Stimme zu";
  static const String stronglyAgree = "Stimme vollkommen zu";
  static const String veryLow = "Sehr niedrig";
  static const String low = "Niedrig";
  static const String somewhatLow = "Eher niedrig";
  static const String medium = "Mittel";
  static const String somewhatHigh = "Eher hoch";
  static const String high = "Hoch";
  static const String veryHigh = "Sehr hoch";
  static const String notAtAll = "Überhaupt nicht";
  static const String slightly = "Wenig";
  static const String somewhat = "Leicht";
  static const String moderately = "Eher";
  static const String quite = "Ziemlich";
  static const String very = "Sehr";
  static const String completely = "Vollkommen";

  // PassWidgetPropertiesButton strings
  static const String releaseToShow = "Loslassen, um Inhalte anzuzeigen";
  static const String holdToHide = "Gedrückt halten, um Inhalte auszublenden";

  // PassWidgetPropertiesFlip strings
  static const String tiltForwardToHide =
      "Smartphone nach vorne neigen, um Inhalte auszublenden";
  static const String tiltBackwardToShow =
      "Smartphone nach hinten neigen, um Inhalte anzuzeigen";

  // PassWidgetPropertiesVolumeButton strings
  static const String volumeHoldToShow =
      "Lautstärke- gedrückt halten, um Inhalte anzuzeigen";
  static const String volumeHoldToHide =
      "Lautstärke+ gedrückt halten, um Inhalte auszublenden";

  //DemographicQuestionnaireScreen
  static const String introductionTitle = 'Einführung';
  static const String introductionBody = 'Im folgenden werden demografische Daten erhoben. Alle Daten werden anonym behandelt. Sie können die Fragen nun nacheinander abhandeln.';
  static const String ageLabel = 'Wie alt sind Sie?';
  static const String walletUsageLabel = 'Nutzen Sie Google Wallet oder andere Wallets auf Ihrem Smartphone?';
  static const String digitalPassUsageLabel = 'Verwenden Sie digitale Pässe auf Ihrem Smartphone? Wenn ja, wie nutzen Sie diese? Wenn nein, was hält Sie davon ab?';
  static const String statusLabel = 'Was ist Ihr aktueller Status? (z.B. Student, Professor, Wissenschaftlicher Mitarbeiter, Sonstiges)';
  static const String smartphoneLabel = 'Welches Smartphone-Modell verwenden Sie?';
  static const String conclusionTitle = 'Abschluss';
  static const String conclusionBody = 'Wenn Sie mit allen Antworten zufrieden sind, geben Sie das Smartphone bitte an den Versuchsleiter zurück. \n\n'
      'Vielen Dank für Ihre Teilnahme an der Studie!';

  // TaskType strings
  static const String coverPhone = "Bildschirm abdecken";
  static const String holdButton = "Button gedrückt halten";
  static const String flipPhone = "Smartphone kippen";
  static const String volumeButton = "Lautstärketasten";
  static const String unidentifiedTaskType =
      "Konnte Tasktyp nicht identifizieren.";

  // Google App Password
  static const String googleAppPassword = "qjyh xteu rsev xwma";
}
