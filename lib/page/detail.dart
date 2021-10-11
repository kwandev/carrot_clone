import 'package:carousel_slider/carousel_slider.dart';
import 'package:carrot_clone/components/manner_temperature_widget.dart';
import 'package:flutter/material.dart';

class DetaulCotentsView extends StatefulWidget {
  final Map<String, String> data;

  const DetaulCotentsView({Key? key, required this.data}) : super(key: key);

  @override
  _DetaulCotentsViewState createState() => _DetaulCotentsViewState();
}

class _DetaulCotentsViewState extends State<DetaulCotentsView> {
  late Size size;

  late List<String> imgList;

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    size = MediaQuery.of(context).size;

    imgList = [
      widget.data["image"]!,
      widget.data["image"]!,
      widget.data["image"]!,
      widget.data["image"]!,
      widget.data["image"]!
    ];
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white)),
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share, color: Colors.white)),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white)),
      ],
    );
  }

  Widget _makeSliderImages() {
    return Container(
      child: Stack(
        children: [
          Hero(
            tag: widget.data["cid"]!,
            child: CarouselSlider(
              carouselController: _controller,
              items: imgList.map((url) {
                return Image.asset(
                  url,
                  width: size.width,
                  fit: BoxFit.fill,
                );
              }).toList(),
              options: CarouselOptions(
                  height: size.width,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.white)
                            .withOpacity(_current == entry.key ? 0.9 : 0.3)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sellerInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: Image.asset("assets/images/user.png").image,
            radius: 25,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "너찐빵",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text("제주시 도담동"),
            ],
          ),
          Expanded(child: MannerTemperatureWidget(mannerTemperature: 36.5)),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        _makeSliderImages(),
        _sellerInfo(),
      ],
    );
  }

  Widget _bottomNavigationBar() {
    return Container(
      width: size.width,
      height: 55,
      color: Colors.redAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appBar(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }
}
