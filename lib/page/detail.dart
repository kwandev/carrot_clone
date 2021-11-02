import 'package:carousel_slider/carousel_slider.dart';
import 'package:carrot_clone/components/manner_temperature_widget.dart';
import 'package:carrot_clone/repository/contents_repository.dart';
import 'package:carrot_clone/utils/data_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class DetailCotentsView extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailCotentsView({Key? key, required this.data}) : super(key: key);

  @override
  _DetailCotentsViewState createState() => _DetailCotentsViewState();
}

class _DetailCotentsViewState extends State<DetailCotentsView>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Size size;

  late List<String> imgList;

  int _current = 0;
  final CarouselController _controller = CarouselController();

  final ScrollController _scrollController = ScrollController();
  double scrollOffset = 0;

  late AnimationController _animationController;
  late Animation _colorTween;

  bool favoriteContent = false;

  late ContentsRepository _contentsRepository;

  @override
  void initState() {
    super.initState();

    _contentsRepository = ContentsRepository();

    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);

    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset > 255) {
          scrollOffset = 255;
        } else {
          scrollOffset = _scrollController.offset;
        }

        _animationController.value = scrollOffset / 255;
      });
    });

    _loadMyFavoriteContentState();
  }

  _loadMyFavoriteContentState() async {
    bool ck =
        await _contentsRepository.isMyFavoriteContent(widget.data["cid"]!);

    setState(() {
      favoriteContent = ck;
    });
  }

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

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => Icon(icon, color: _colorTween.value),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white.withAlpha(scrollOffset.toInt()),
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: _makeIcon(Icons.arrow_back)),
      actions: [
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.share)),
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.more_vert)),
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

  Widget _line() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text(
            widget.data["title"]!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const Text(
            "디지털/가전 ・ 22시간전",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(height: 15),
          const Text(
            "가나다라 마\n바사 아자차카 타파하가나다라 \n마바사 아자차카 타파하가나다라 마바사 \n아자차카 타파하가나다라 마바사 아자차카 타파하가나다라 마\n바사 아자차카 타파하가나다라 \n마바사 아자차카 타파하가나다라 마바사 \n아자차카 타파하가나다라 마바사 아자차카 타파하",
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          SizedBox(height: 15),
          const Text(
            "채팅 3 ・ 괌심 17 ・ 조회 299",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _otherCellContents() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "판매자님의 판매 상품",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            "모두보기",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            _makeSliderImages(),
            _sellerInfo(),
            _line(),
            _contentDetail(),
            _line(),
            _otherCellContents(),
          ]),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            delegate: SliverChildListDelegate(List.generate(10, (index) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(height: 120, color: Colors.grey)),
                    const Text("상품제목", style: TextStyle(fontSize: 14)),
                    const Text(
                      "금액",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList()),
          ),
        ),
      ],
    );
  }

  Widget _bottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: size.width,
      height: 55,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              if (favoriteContent) {
                await _contentsRepository
                    .deleteMyFavoriteContent(widget.data["cid"]!);
              } else {
                await _contentsRepository.addMyFavoriteContent(widget.data);
              }

              setState(() {
                favoriteContent = !favoriteContent;
              });

              // ignore: deprecated_member_use
              scaffoldKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text(favoriteContent ? "관심목록에 추가" : "관심목록에서 삭제"),
                  duration: const Duration(
                    milliseconds: 1000,
                  ),
                ),
              );
            },
            child: SvgPicture.asset(
              favoriteContent
                  ? "assets/svg/heart_on.svg"
                  : "assets/svg/heart_off.svg",
              width: 25,
              height: 25,
              color: Color(0xfff08f4f),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 15,
              right: 10,
            ),
            width: 1,
            height: 30,
            color: Colors.grey.withOpacity(0.3),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DataUtils.calcStrongToWon(widget.data["price"]!),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "가격제안불가",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 15,
                  ),
                  child: const Text(
                    "채팅으로 거래하기",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xfff08f4f),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: _appBar(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }
}
