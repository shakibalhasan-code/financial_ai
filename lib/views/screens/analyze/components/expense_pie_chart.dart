import 'package:financial_ai_mobile/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartSample2 extends StatefulWidget {
  final List<dynamic> expenseCategories;

  const PieChartSample2({super.key, required this.expenseCategories});

  @override
  State<StatefulWidget> createState() => PieChartSample2State();
}

class PieChartSample2State extends State<PieChartSample2> {
  final List<Color> _categoryColors = [
    AppStyles.orangeColor,
    AppStyles.redColor,
    AppStyles.blueColor,
    AppStyles.purpleColor,
    AppStyles.simpleBlueColor,
    Colors.green,
    Colors.teal,
    Colors.brown,
    Colors.amber,
    Colors.indigo,
  ];

  Color _getColorForIndex(int index) {
    return _categoryColors[index % _categoryColors.length];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.expenseCategories.isEmpty) {
      return Center(
        child: Text(
          "No expense data to display in chart.",
          style: AppStyles.smallText.copyWith(color: AppStyles.greyColor),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SfCircularChart(
            series: <CircularSeries>[
              PieSeries<dynamic, String>(
                dataSource: widget.expenseCategories,
                xValueMapper: (dynamic data, _) => data.category as String,
                yValueMapper:
                    (dynamic data, _) => (data.percent as int).toDouble(),
                pointColorMapper:
                    (dynamic data, int index) => _getColorForIndex(index),
                dataLabelMapper:
                    (dynamic data, _) => '${(data.percent as int).toDouble()}%',
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        _buildLegend(),
      ],
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 4.h,
      alignment: WrapAlignment.center,
      children:
          widget.expenseCategories.asMap().entries.map((entry) {
            int index = entry.key;
            String categoryName = entry.value.category;
            return _buildLegendItem(_getColorForIndex(index), categoryName);
          }).toList(),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.w,
          height: 10.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.r),
            color: color,
          ),
        ),
        SizedBox(width: 5.w),
        Text(
          text,
          style: AppStyles.smallText.copyWith(
            fontSize: 12.sp,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
