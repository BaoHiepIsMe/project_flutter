import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});
  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  late Box box;
  final titleCtrl = TextEditingController();
  final amountCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    box = await Hive.openBox('expenses');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen('expenses')) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final entries = List<Map<String, dynamic>>.from(
      (box.get('items', defaultValue: <Map<String, dynamic>>[]) as List).map((e) => Map<String, dynamic>.from(e))
    );

    final bars = <BarChartGroupData>[];
    for (var i = 0; i < entries.length; i++) {
      final v = double.tryParse(entries[i]['amount'].toString()) ?? 0;
      bars.add(BarChartGroupData(x: i, barRods: [BarChartRodData(toY: v)]));
    }

    void save() {
      final list = [...entries, {'title': titleCtrl.text, 'amount': amountCtrl.text}];
      box.put('items', list);
      setState(() {});
      titleCtrl.clear();
      amountCtrl.clear();
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker (Hive)')),
      body: Column(
        children: [
          SizedBox(height: 200, child: Padding(
            padding: const EdgeInsets.all(12),
            child: BarChart(BarChartData(barGroups: bars)),
          )),
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(entries[i]['title']),
                subtitle: Text('₫${entries[i]['amount']}'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(
          title: const Text('Add expense'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
          ]),
          actions: [TextButton(onPressed: save, child: const Text('Save'))],
        )),
        child: const Icon(Icons.add),
      ),
    );
  }
}
