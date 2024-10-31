import 'package:fl_chart/fl_chart.dart';
import "package:flutter/material.dart";
import 'package:random_color/random_color.dart';
import 'package:zekryptofolio/services/firestore.dart';
import 'package:zekryptofolio/services/api.dart';
import 'package:zekryptofolio/values/app_colors.dart';

import 'package:zekryptofolio/portfolio/transactions.dart';
import 'package:zekryptofolio/portfolio/summary_item.dart';
import 'package:zekryptofolio/shared/error.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: FirestoreService().getSummaries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: ErrorMessage(message: snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data!;

            if (data.isEmpty) {
              return Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: const Color.fromARGB(255, 33, 33, 33),
                    title: Row(
                      children: const [
                        Expanded(
                            child: Text('Portfolio',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                )))
                      ],
                    ),
                  ),
                  body: const Center(
                      child: Text(
                    "You do not have any transaction yet!",
                    textDirection: TextDirection.ltr,
                  )));
            }

            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: const Color.fromARGB(255, 33, 33, 33),
                title: Row(
                  children: const [
                    Expanded(
                        child: Text('Portfolios',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            )))
                  ],
                ),
              ),
              body: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/Background_base.jpg'),
                  fit: BoxFit.cover,
                )),
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView(
                    children: [
                      const SizedBox(height: 10),
                      PortfolioPieChart(
                          summary: data,
                          colors: List<Color>.generate(
                              data.length, (i) => RandomColor().randomColor())),
                      const SizedBox(height: 10),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TransactionsScreen()));
                            },
                            child: const Text("Transactions history",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _SummaryListWidget(summary: data),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Text("No market data found in the api",
                textDirection: TextDirection.ltr);
          }
        });
  }
}

class _SummaryListWidget extends StatefulWidget {
  final List<Map<String, dynamic>> summary;

  const _SummaryListWidget({Key? key, required this.summary}) : super(key: key);

  @override
  _SummaryListWidgetState createState() => _SummaryListWidgetState();
}

class _SummaryListWidgetState extends State<_SummaryListWidget> {
  @override
  Widget build(BuildContext context) {
    var coins = widget.summary.map((toElement) => toElement["coins"]).toList();

    return FutureBuilder<List>(
        future: Api().fetchMarketData(coins: coins),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: ErrorMessage(message: snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            var market = snapshot.data!;
            double totalValue = 0.0;

            for (var summary in widget.summary) {
              totalValue += summary["total"];
            }

            return ListView.builder(
                itemCount: widget.summary.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, index) {
                  if (index == 0) {
                    return Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: Text('TOTAL VALUE:',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text('\$${totalValue.toStringAsFixed(2)}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      const Title(),
                      SummaryItem(
                          coin: market[index],
                          id: index,
                          amount: widget.summary[index]["total"] + 0.0),
                    ]);
                  } else {
                    return SummaryItem(
                        coin: market[index],
                        id: index,
                        amount: widget.summary[index]["total"] + 0.0);
                  }
                });
          } else {
            return const Text("No market data found in the api",
                textDirection: TextDirection.ltr);
          }
        });
  }
}

class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Row(
        children: const [
          Expanded(
            flex: 5,
            child: Text(
              '#',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 45,
            child: Padding(
              padding: EdgeInsets.only(left: 50),
              child: Text(
                'Name',
                style: TextStyle(
                  color: Color.fromARGB(255, 184, 181, 181),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 20,
            child: Text(
              "24h",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 30,
            child: Text(
              'Price',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PortfolioPieChart extends StatefulWidget {
  final List<Map<String, dynamic>> summary;
  final List<Color> colors;
  const PortfolioPieChart({key, required this.summary, required this.colors})
      : super(key: key);

  @override
  PieChartState createState() => PieChartState();
}

class PieChartState extends State<PortfolioPieChart> {
  int touchedIndex = 0;

  var totalValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: showingSections(widget.summary, widget.colors),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      final List<Map<String, dynamic>> summary, List<Color> colors) {
    debugPrint(summary.toString());

    for (var summary in widget.summary) {
      totalValue += summary["total"];
    }

    List<PieChartSectionData> pieChartSection = [];

    for (int i = 0; i <= summary.length - 1; i++) {
      final isTouched = i == touchedIndex;

      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 130.0 : 120.0;
      final widgetSize = isTouched ? 65.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 5)];

      pieChartSection.add(
        PieChartSectionData(
          color: colors[i],
          value: summary[i]["total"] + 0.0,
          title: ((summary[i]["total"] / totalValue) * 100).toStringAsFixed(2) +
              "%",
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
            shadows: shadows,
          ),
          badgeWidget: _Badge(
            summary[i]["image"],
            size: widgetSize,
            borderColor: AppColors.contentColorBlack,
          ),
          badgePositionPercentageOffset: .98,
        ),
      );
    }

    return pieChartSection;
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.image, {
    required this.size,
    required this.borderColor,
  });
  final String image;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Image.network(image),
      ),
    );
  }
}
