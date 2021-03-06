import 'package:flutter/material.dart';
import 'package:flutter_bmi/businessObject/BMI.dart';
import 'package:flutter_bmi/database/database_handler.dart';
import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:share_plus/share_plus.dart';

import '../businessObject/Rating.dart';
import '../generated/l10n.dart';
import '../widget/appbar_widget.dart';
import 'bmi_history_screen.dart';

class ScoreScreen extends StatelessWidget {
  final double bmiScore;
  final int age;

  ScoreScreen({Key? key, required this.bmiScore, required this.age})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Rating rating = Rating.getRatingFromBMI(bmiScore, context);

    return Scaffold(
      appBar: buildAppBar(context, S.of(context).bmi_score),
      body: Container(
          padding: const EdgeInsets.all(12),
          child: Card(
              elevation: 12,
              shape: const RoundedRectangleBorder(),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      //"Your Score",
                      S.of(context).your_score,
                      style: TextStyle(fontSize: 30, color: Colors.blue),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PrettyGauge(
                      gaugeSize: 300,
                      minValue: 0,
                      maxValue: 40,
                      segments: [
                        GaugeSegment('UnderWeight', 18.5, Colors.red),
                        GaugeSegment('Normal', 6.4, Colors.green),
                        GaugeSegment('OverWeight', 5, Colors.orange),
                        GaugeSegment('Obese', 10.1, Colors.pink),
                      ],
                      valueWidget: Text(
                        bmiScore.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 40),
                      ),
                      currentValue: bmiScore.toDouble(),
                      needleColor: Colors.blue,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      rating.status,
                      style: TextStyle(fontSize: 20, color: rating.bmiStatusColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      rating.message,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            //child: const Text("Re-calculate")),
                        child: Text(S.of(context).recalculate)),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Share.share(
                                  "Your BMI is ${bmiScore.toStringAsFixed(1)} at age $age");
                            },

                          child: Text(S.of(context).share),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            BMI bmi = BMI(id: null, user_id: 1, bmiScore: bmiScore);
                            DatabaseHandler.instance.createBMI(bmi);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BMIHistoryScreen()));
                          },

                          child: Text("Save"),
                        )
                      ],
                    )
                  ]))),
    );
  }
}
