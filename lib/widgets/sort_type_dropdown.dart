import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hotels_controller.dart';

class SortTypeDropdown extends StatefulWidget {
  const SortTypeDropdown({Key? key}) : super(key: key);

  @override
  _SortTypeDropdownState createState() => _SortTypeDropdownState();
}

class _SortTypeDropdownState extends State<SortTypeDropdown>
    with SingleTickerProviderStateMixin {
  final hotelsController = Get.find<HotelsController>();
  AnimationController? animationController;
  Animation<double>? animation;
  String title = 'Sort';
  bool isExpand = false;
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation =
        CurvedAnimation(parent: animationController!, curve: Curves.easeIn);
  }

  void animate() {
    animationController!.forward();
    animationController!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: isExpand ? 200 : 50,
        width: MediaQuery.of(context).size.width / 2,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                !isExpand
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      )
                    : SizedBox(),
                IconButton(
                  icon: Icon(
                    isExpand ? Icons.arrow_upward : Icons.arrow_downward,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    animate();
                    setState(() {
                      isExpand = !isExpand;
                    });
                  },
                ),
              ],
            ),
            if (isExpand)
              Expanded(
                child: ListView(
                  children: sortType.values
                      .map(
                        (e) => TextButton(
                          onPressed: () {
                            setState(() {
                              title = describeEnum(e);
                              isExpand = false;
                            });
                            hotelsController.sortHotels(e);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              describeEnum(e),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
