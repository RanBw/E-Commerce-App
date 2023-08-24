import 'package:flutter/material.dart';
import 'package:gaming_gears_app/models/items-class.dart';
import 'package:gaming_gears_app/shared/appbar.dart';
import 'package:gaming_gears_app/shared/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailsScreen extends StatefulWidget {
  final int index;
  const DetailsScreen({super.key, required this.index});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isShowMore = false;
  bool dontShowMore = false;

  late final Text text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [AppBarAction()],
        backgroundColor: mainColor,
        title: const Text(
          "Details screen",
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 380,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(87, 0, 0, 0),
                  image: DecorationImage(
                      image: AssetImage(items[widget.index].path),
                      fit: BoxFit.cover)),
            ),
            Text("${items[widget.index].name} ${items[widget.index].price}SR"),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 9),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 0),
                        height: 20,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: const Color.fromARGB(255, 225, 129, 129),
                        ),
                        child: const Text(
                          "new",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    RatingBar.builder(
                      initialRating: 5,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 22,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.edit_location,
                      color: mainColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        items[widget.index].location,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            const SizedBox(
              width: double.infinity,
              child: Text(
                "Details: ",
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(
              height: 11,
            ),
            Text(
              items[widget.index].description,
              style: const TextStyle(fontSize: 18),
              maxLines: isShowMore ? null : 3,
              overflow: TextOverflow.fade,
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    isShowMore = !isShowMore;
                  });
                },
                child: isShowMore
                    ? const Text("Show less")
                    : const Text("Show more"))
          ],
        ),
      ),
    );
  }
}
