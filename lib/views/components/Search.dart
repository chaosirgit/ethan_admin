import 'package:ethan_admin/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final TextEditingController searchEditController = TextEditingController();
}

class Search extends StatelessWidget {
  final SearchController sc = Get.put(SearchController());
  Function onTap;

  Search({Key? key, required this.onTap(context, controller)})
      : super(key: key);
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            flex: 2,
            child: TextField(
              controller: sc.searchEditController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: "Search",
                fillColor: secondaryColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onSubmitted: (d) {
                focusNode.unfocus();
                onTap(d, sc.searchEditController);
              },
            )),
        Flexible(
            child: ElevatedButton(
          onPressed: () {
            focusNode.unfocus();
            onTap(sc.searchEditController.text, sc.searchEditController);
          },
          style: ElevatedButton.styleFrom(minimumSize: Size(60, 60)),
          child: Icon(Icons.search),
        ))
      ],
    );
  }
}
