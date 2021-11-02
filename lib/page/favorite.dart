import 'package:carrot_clone/repository/contents_repository.dart';
import 'package:carrot_clone/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'detail.dart';

class MyFavorite extends StatefulWidget {
  const MyFavorite({Key? key}) : super(key: key);

  @override
  _MyFavoriteState createState() => _MyFavoriteState();
}

class _MyFavoriteState extends State<MyFavorite> {
  late ContentsRepository _contentsRepository;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contentsRepository = ContentsRepository();
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "관심목록",
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
    );
  }

  Widget _bodyWidget() {
    return FutureBuilder(
      future: _loadMyFavoriteContents(),
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
      },
    );
  }

  Future<List<dynamic>> _loadMyFavoriteContents() async {
    return await _contentsRepository.loadFavoriteContents();
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
                  return DetailCotentsView(
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
                        Text(DataUtils.calcStrongToWon(datas[index]["price"]!),
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
      itemCount: datas.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _bodyWidget(),
    );
  }
}
