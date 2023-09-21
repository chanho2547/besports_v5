import 'package:besports_v5/constants/custom_colors.dart';
import 'package:besports_v5/constants/rGaps.dart';
import 'package:besports_v5/constants/rSizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/profile';
  static const routeURL = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ScrollController _scrollController;
  late RSizes s;
  late RGaps g;

  double? titleTopPadding;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        final maxScroll = MediaQuery.of(context).size.height;
        final currentScroll = _scrollController.offset;
        final percentageScrolled = (currentScroll / maxScroll).clamp(0.0, 1.0);

        if (_scrollController.offset <=
            MediaQuery.of(context).size.height * 0.35) {
          setState(() {
            _opacity =
                (1 - percentageScrolled).clamp(0.0, 1.0); // <-- opacity를 업데이트
            titleTopPadding = MediaQuery.of(context).size.height * 0.35 -
                _scrollController.offset;
          });
        } else {
          setState(() {
            titleTopPadding = 0;
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    int imagesNum = 489;
    int followers = 92399;
    int followings = 763;
    String displayfollwers = followers >= 1000
        ? "${(((followers / 1000) * 10).toInt() / 10).toStringAsFixed(1)}k"
        : followers.toString();
    String displayfollwings = followings >= 1000
        ? "${(((followings / 1000) * 10).toInt() / 10).toStringAsFixed(1)}k"
        : followings.toString();

    String name = "USER";
    String location = "Dujong, Cheonan";

    s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    g = RGaps(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    titleTopPadding ??= s.hrSize35();

    final List<String> images = [
      'Images/1.jpg',
      'Images/2.jpg',
      'Images/3.jpg',
      'Images/4.jpg',
      'Images/5.jpg',
      'Images/6.jpg',
      'Images/7.jpg',
      'Images/8.jpg',
      'Images/9.jpg',
      'Images/10.jpg',
      'Images/11.jpg',
      'Images/12.jpg',
      'Images/13.jpg',
      'Images/14.jpg',
      'Images/15.jpg',
      'Images/16.jpg',
      'Images/17.jpg',
      'Images/18.jpg',
      'Images/19.jpg',
      'Images/20.jpg',
      'Images/21.jpg',
      // ... 추가적인 이미지들 ...
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: custom_colors.white,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              elevation: 5.0,
              backgroundColor: custom_colors.backgroundLightBlack,
              pinned: true,
              stretch: true,
              collapsedHeight: s.hrSize10(),
              expandedHeight: s.hrSize40(),
              flexibleSpace: FlexibleSpaceBar(
                background: Opacity(
                  opacity: _opacity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      g.vr05(),
                      CircleAvatar(
                        backgroundImage: const AssetImage('Images/main.jpg'),
                        radius: s.wrSize15(),
                      ),
                      g.vr02(),
                      Text(
                        name,
                        style: TextStyle(
                          color: custom_colors.white,
                          fontSize: s.wrSize07(),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      g.vr015(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.locationDot,
                            color: custom_colors.white,
                            size: s.hrSize02(),
                          ),
                          SizedBox(
                            width: s.wrSize01(),
                          ),
                          Text(
                            location,
                            style: TextStyle(
                              color: custom_colors.white,
                              fontSize: s.wrSize04(),
                            ),
                          ),
                        ],
                      ),
                      g.vr05(),
                    ],
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: s.wrSize15(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$imagesNum",
                            style: TextStyle(
                              color: custom_colors.white,
                              fontSize: s.hrSize015(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          g.vr01(),
                          Text(
                            "Images",
                            style: TextStyle(
                              color: custom_colors.white,
                              fontSize: s.hrSize012(),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: s.wrSize15(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            displayfollwers,
                            style: TextStyle(
                              color: custom_colors.white,
                              fontSize: s.hrSize015(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          g.vr01(),
                          Text(
                            "Followers",
                            style: TextStyle(
                              color: custom_colors.white,
                              fontSize: s.hrSize012(),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: s.wrSize15(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            displayfollwings,
                            style: TextStyle(
                              color: custom_colors.white,
                              fontSize: s.hrSize015(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          g.vr01(),
                          Text(
                            "Following",
                            style: TextStyle(
                              color: custom_colors.white,
                              fontSize: s.hrSize012(),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                titlePadding:
                    EdgeInsetsDirectional.only(top: titleTopPadding ?? 0.0),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: [
                      g.vr05(),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: AssetImage(images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
