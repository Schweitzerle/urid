import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:urid/feature/models/taskAssigningService.dart';
import 'package:urid/feature/widgets/customWillPopScope.dart';
import '../../models/strings.dart';
import '../../models/subject.dart';
import '../../widgets/consentForm.dart';

//Introduction-Screen um den Probanden alle wichtigen Informationen für die Studie zu liefern
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final TaskAssigningService taskAssigningService =
  GetIt.instance<TaskAssigningService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einführung'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: introSliderPages(context),
    );
  }

  Widget introSliderPages(BuildContext context) {
    return CustomWillPopScopeWidget(
      child: IntroductionScreen(
        pages: [
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
                        Strings.welcomeTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 40),
                      Text(
                        Strings.welcomeBody,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            decoration: const PageDecoration(
                titlePadding: EdgeInsets.zero
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
                        Strings.studyProcessTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 40),
                      Text(
                        Strings.studyProcessBody,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            decoration: const PageDecoration(
                titlePadding: EdgeInsets.zero
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
                        Strings.taskTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 40),
                      Text(
                        Strings.taskBody,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            decoration: const PageDecoration(
                titlePadding: EdgeInsets.zero
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
                        Strings.interactionMethodsTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 40),
                      Text(
                        Strings.interactionMethodsBody,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            decoration: const PageDecoration(
                titlePadding: EdgeInsets.zero
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
                        Strings.questionnaireTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 40),
                      Text(
                        Strings.questionnaireBody,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            decoration: const PageDecoration(
                titlePadding: EdgeInsets.zero
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
                        Strings.interviewTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 40),
                      Text(
                        Strings.interviewBody,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            decoration: const PageDecoration(
                titlePadding: EdgeInsets.zero
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
                        Strings.confidentialityTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 40),
                      Text(
                        Strings.confidentialityBody,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            decoration: const PageDecoration(
                titlePadding: EdgeInsets.zero
            ),
          ),
        ],
        showNextButton: true,
        next: const Icon(Icons.arrow_forward),
        done: const Text(Strings.next),
        onDone: () async {
          await taskAssigningService.incrementCounter();
          registerCurrentSubject();
          print(taskAssigningService.task);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return ConsentForm();
            }),
          );
        },
        dotsDecorator: DotsDecorator(
          activeColor: Theme.of(context).primaryColor,
          size: const Size.square(10.0),
          activeSize: const Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        globalBackgroundColor: Colors.white,
      ),
    );
  }

  void registerCurrentSubject() {
    var uuid = const Uuid();
    GetIt.I.registerSingleton<Subject>(Subject(
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      uuid: uuid.v4(),
      taskAssigningService: taskAssigningService,
    ));
  }
}

