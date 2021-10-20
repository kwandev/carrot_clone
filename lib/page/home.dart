import 'package:carrot_clone/page/detail.dart';
import 'package:carrot_clone/repository/contents_repository.dart';
import 'package:carrot_clone/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String _currentLocation;
  final Map<String, String> _locationToString = {
    "ara": "아라동",
    "ora": "오라동",
    "donam": "돈암동"
  };

  late ContentsRepository _contentsRepository;

  @override
  void initState() {
    super.initState();

    _currentLocation = "ara";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contentsRepository = ContentsRepository();
  }

  _loadContents() {
    return _contentsRepository.loadContentsFromLocation(_currentLocation);
  }

  AppBar _appBar() {
    return AppBar(
      title: GestureDetector(
        child: PopupMenuButton<String>(
          offset: const Offset(0, 30),
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              1),
          onSelected: (String value) {
            setState(() {
              _currentLocation = value;
            });
          },
          itemBuilder: (BuildContext contenxt) {
            return [
              const PopupMenuItem(value: "ara", child: Text("아라동")),
              const PopupMenuItem(value: "ora", child: Text("오라동")),
              const PopupMenuItem(value: "donam", child: Text("돈암동"))
            ];
          },
          child: Row(
            children: [
              Text(_locationToString[_currentLocation]!,
                  style: const TextStyle(color: Colors.black)),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.black)),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune, color: Colors.black)),
        IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/svg/bell.svg",
              width: 22,
            )),
      ],
      elevation: 1,
    );
  }

  ListView _makeDataList(data) {
    dynamic datas = data;

    return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (BuildContext _context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return DetaulCotentsView(
                      data: data[index],
                    );
                  },
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  ClipRRect(
                    child: Hero(
                      tag: datas[index]["cid"],
                      child: Image.asset(datas[index]["image"]!,
                          width: 100, height: 100),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(datas[index]["title"]!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 15)),
                          const SizedBox(height: 5),
                          Text(datas[index]["location"]!,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.3))),
                          const SizedBox(height: 5),
                          Text(
                              DataUtils.calcStrongToWon(datas[index]["price"]!),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            child: Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SvgPicture.asset('assets/svg/heart_off.svg',
                                        width: 14, height: 14),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(datas[index]["likes"]!)
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(height: 1, color: Colors.black.withOpacity(0.2));
        },
        itemCount: 10);
  }

  Widget _bodyWidget() {
    return FutureBuilder(
        future: _loadContents(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("데이터 오류"));
          }

          if (snapshot.hasData) {
            return _makeDataList(snapshot.data);
          }

          return const Center(child: Text('해당 지역에 데이터가 없습니다'));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _bodyWidget());
  }
}
