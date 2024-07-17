import 'package:flutter/material.dart';
import 'package:urid/feature/widgets/customWillPopScope.dart';
import 'package:urid/feature/widgets/demograficQuestionnaire/demographicQuestionnaireWidget.dart';

class DemographicSurveyScreen extends StatefulWidget {
  @override
  _DemographicSurveyScreenState createState() => _DemographicSurveyScreenState();
}

class _DemographicSurveyScreenState extends State<DemographicSurveyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demografische Umfrage'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        automaticallyImplyLeading: false,
      ),
      body: CustomWillPopScopeWidget(child: DemographicQuestionnaireWidget()),
    );
  }
}
