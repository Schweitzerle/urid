import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:urid/feature/widgets/customWillPopScope.dart';
import '../../models/strings.dart';
import '../../models/subject.dart';
import '../../screens/DataSendingScreen/dataSendingScreen.dart';
import 'demograficQuestionnaire.dart';

class DemographicQuestionnaireWidget extends StatefulWidget {
  const DemographicQuestionnaireWidget({super.key});

  @override
  _DemographicQuestionnaireWidgetState createState() => _DemographicQuestionnaireWidgetState();
}

class _DemographicQuestionnaireWidgetState extends State<DemographicQuestionnaireWidget> {
  late DemographicQuestionnaire demographicQuestionnaire;
  final GetIt getIt = GetIt.instance;

  final TextEditingController ageController = TextEditingController();
  final TextEditingController walletUsageController = TextEditingController();
  final TextEditingController walletUsageExtendController = TextEditingController();
  final TextEditingController digitalPassUsageController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController smartphoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    demographicQuestionnaire = DemographicQuestionnaire();
  }

  void _updateQuestionValue(String key, String value) {
    setState(() {
      switch (key) {
        case 'age':
          demographicQuestionnaire.age = value;
          break;
        case 'walletUsage':
          demographicQuestionnaire.walletUsage = value;
          break;
          case 'walletUsageExtend':
            demographicQuestionnaire.walletUsageExtend = value;
            break;
        case 'digitalPassUsage':
          demographicQuestionnaire.digitalPassUsage = value;
          break;
        case 'status':
          demographicQuestionnaire.status = value;
          break;
        case 'smartphone':
          demographicQuestionnaire.smartphone = value;
          break;
      }
    });
  }

  bool _areAllFieldsFilled() {
    return ageController.text.isNotEmpty &&
        walletUsageController.text.isNotEmpty && walletUsageExtendController.text.isNotEmpty &&
        digitalPassUsageController.text.isNotEmpty &&
        statusController.text.isNotEmpty &&
        smartphoneController.text.isNotEmpty;
  }

  void _onDonePressed() {
    if (_areAllFieldsFilled()) {
      final subject = getIt<Subject>();
      subject.demographicQuestionnaire = demographicQuestionnaire;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DataSendingScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bitte füllen Sie alle Felder aus, bevor Sie fortfahren.')),
      );
    }
  }

  Widget _buildTextInputField(String label, String hint, String key, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 120,
          child: AutoSizeText(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        const SizedBox(height: 40),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 100.0,
          ),
          child: TextField(
            controller: controller,
            onChanged: (value) => _updateQuestionValue(key, value),
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: hint,
            ),
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomWillPopScopeWidget(
      child: IntroductionScreen(
        pages: _getPages(),
        onDone: _onDonePressed,
        showSkipButton: false,
        showNextButton: true,
        showBackButton: false,
        next: const Icon(Icons.arrow_forward),
        done: const Text(
          Strings.next,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  List<PageViewModel> _getPages() {
    return [
      PageViewModel(
        titleWidget: Container(),
        bodyWidget: const IntrinsicHeight(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.introductionTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    Strings.introductionBody,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
        decoration: const PageDecoration(
          titlePadding: EdgeInsets.zero,
        ),
      ),
      PageViewModel(
        titleWidget: Container(),
        bodyWidget: _buildTextInputField(
            Strings.ageLabel,
            'Alter...',
            'age',
            ageController
        ),
        decoration: const PageDecoration(
          titlePadding: EdgeInsets.zero,
        ),
      ),
      PageViewModel(
        titleWidget: Container(),
        bodyWidget: _buildTextInputField(
            Strings.statusLabel,
            'Beschäftigung...',
            'status',
            statusController
        ),
        decoration: const PageDecoration(
          titlePadding: EdgeInsets.zero,
        ),
      ),
      PageViewModel(
        titleWidget: Container(),
        bodyWidget: _buildTextInputField(
            Strings.smartphoneLabel,
            'Smartphonemodell...',
            'smartphone',
            smartphoneController
        ),
        decoration: const PageDecoration(
          titlePadding: EdgeInsets.zero,
        ),
      ),
      PageViewModel(
        titleWidget: Container(),
        bodyWidget: _buildTextInputField(
            Strings.walletUsageLabel,
            'Walletnutzung...',
            'walletUsage',
            walletUsageController
        ),
        decoration: const PageDecoration(
          titlePadding: EdgeInsets.zero,
        ),
      ),
      PageViewModel(
        titleWidget: Container(),
        bodyWidget: _buildTextInputField(
            Strings.walletUsageExtendLabel,
            'Walletnutzung...',
            'walletUsageExtend',
            walletUsageExtendController
        ),
        decoration: const PageDecoration(
          titlePadding: EdgeInsets.zero,
        ),
      ),
      PageViewModel(
        titleWidget: Container(),
        bodyWidget: _buildTextInputField(
            Strings.digitalPassUsageLabel,
            'Nutzung digitaler Pässe...',
            'digitalPassUsage',
            digitalPassUsageController
        ),
        decoration: const PageDecoration(
          titlePadding: EdgeInsets.zero,
        ),
      ),
      PageViewModel(
        titleWidget: Container(),
        bodyWidget: const IntrinsicHeight(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.conclusionTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    Strings.conclusionBody,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
        decoration: const PageDecoration(
          titlePadding: EdgeInsets.zero,
        ),
      ),
    ];
  }
}
