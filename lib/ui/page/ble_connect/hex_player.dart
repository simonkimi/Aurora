import 'package:aurora/ui/components/app_bar.dart';
import 'package:flutter/material.dart';

class HexPlayer extends StatelessWidget {
  HexPlayer({
    Key? key,
    required this.data,
  })  : chr = data
            .map((e) => e >= 32 && e <= 126 ? String.fromCharCode(e) : '.')
            .toList(),
        super(key: key);

  final List<int> data;
  final List<String> chr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: 'Hex'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(8, (index) => index).map((index) {
                  return buildColumn(index, 8);
                }).toList(),
              ),
            ),
            const SizedBox(
              width: 0.5,
              height: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(8, (index) => index).map((index) {
                return buildTextColumn(index, 8);
              }).toList(),
            )),
          ],
        ),
      ),
    );
  }

  Widget buildColumn(int start, int step) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            start.toString(),
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 5),
          ...List.generate((data.length - start - 1) ~/ step + 1,
                  (index) => step * index + start)
              .map((e) => data[e].toRadixString(16))
              .map((e) => e.length == 1 ? '0$e' : e)
              .map((e) => Text(e.toString()))
        ],
      ),
    );
  }

  Widget buildTextColumn(int start, int step) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            start.toString(),
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 5),
          ...List.generate((data.length - start - 1) ~/ step + 1,
                  (index) => step * index + start)
              .map((e) => chr[e])
              .map((e) => Text(e.toString()))
        ],
      ),
    );
  }
}
