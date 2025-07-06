import 'package:flutter/material.dart';
import 'package:iseey/AfterLoginFlow/Table/view/widgets/table_list_item.dart';
import 'package:iseey/Models/TableListModel.dart';

class TableListContent extends StatelessWidget {
  final List<CheckIns> tableListResult;
  final List<CheckIns> searchResult;
  final TextEditingController searchTextController;
  final Restaurant? restaurant;
  final Future<void> Function() onRefresh;
  final Function(CheckIns) onItemTap;

  const TableListContent({
    Key? key,
    required this.tableListResult,
    required this.searchResult,
    required this.searchTextController,
    required this.restaurant,
    required this.onRefresh,
    required this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Container(
        height: double.infinity,
        child: tableListResult.isEmpty
            ? Center(
                child: Text(
                  "No tables are currently checked in.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                itemCount: searchTextController.text.isEmpty
                    ? tableListResult.length
                    : searchResult.isEmpty
                        ? 0
                        : searchResult.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final result = searchTextController.text.isEmpty
                      ? tableListResult[index]
                      : searchResult.isEmpty
                          ? tableListResult[index]
                          : searchResult[index];
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      onItemTap(result);
                    },
                    child: TableListItem(
                      result: result,
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
              ),
      ),
    );
  }
}