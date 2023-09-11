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

  double? titleTopPadding;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset <=
            MediaQuery.of(context).size.height * 0.35) {
          setState(() {
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

    String name = "Milky Sound";
    String location = "Dujong, Cheonan";

    final double appHeight = MediaQuery.of(context).size.height;
    final double appWidth = MediaQuery.of(context).size.width;

    titleTopPadding ??= appHeight * 0.35;

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
        backgroundColor: Colors.white,
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
              backgroundColor: const Color(0xFF373737),
              pinned: true,
              stretch: true,
              collapsedHeight: appHeight * 0.1,
              expandedHeight: appHeight * 0.4,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: appHeight * 0.05,
                    ),
                    CircleAvatar(
                      backgroundImage: const AssetImage('Images/main.jpg'),
                      radius: appWidth * 0.15,
                    ),
                    SizedBox(height: appHeight * 0.02),
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: appWidth * 0.07,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: appHeight * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.locationDot,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: appWidth * 0.01,
                        ),
                        Text(
                          location,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: appWidth * 0.04,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: appHeight * 0.05),
                  ],
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: appWidth * 0.15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$imagesNum",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: appHeight * 0.015,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: appHeight * 0.01),
                          Text(
                            "Images",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: appHeight * 0.012,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: appWidth * 0.15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            displayfollwers,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: appHeight * 0.015,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: appHeight * 0.01),
                          Text(
                            "Followers",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: appHeight * 0.012,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: appWidth * 0.15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            displayfollwings,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: appHeight * 0.015,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: appHeight * 0.01),
                          Text(
                            "Following",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: appHeight * 0.012,
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
                      SizedBox(
                        height: appHeight * 0.05,
                      ),
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
