import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/live_stream.dart';
import '../../services/user_services.dart';
import '../../config/utils.dart';
import '../../screens/Going%20Live/video_player.dart';
import '../../screens/profile.dart';
import '../../translations/locale_keys.g.dart';
import '../../models/user.dart';
import '../../services/firebase_auth_services.dart';
import '../../services/firebase_storage_services.dart';
import '../../config/app_style.dart';
import '../../services/livestream_services.dart';
import '../providers/auth_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  FirebaseStorageServices storage = FirebaseStorageServices();

  String _dropdownValue = "Date ↑";

  String field = "date";
  bool isDescending=true;

  bool isVideo=true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //SEARCH FOR USERS STREAM BUILDER
  Widget searchUsersStream(){
    return StreamBuilder<List<UserModel>>(
        stream: UserServices().getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  '${LocaleKeys.somethingWentWrong.tr()} ${snapshot.error}',
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
            );
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            users.removeWhere((element) => element.email==
                Provider.of<AuthProvider>(context).user!.email
                //context.read<FirebaseAuthServices>().user.email
            );
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                if (_searchController.text.isNotEmpty && users[index].username.toLowerCase().contains(_searchController.text.toLowerCase())) {
                  return ListTile(
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: FutureBuilder(
                        future: storage.downloadURL(
                            "profile pictures",
                            users[index].email),
                        builder: (BuildContext context,
                            AsyncSnapshot<String>
                            snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                                decoration:
                                const BoxDecoration(
                                    color: MyThemes
                                        .primaryLight,
                                    shape:
                                    BoxShape.circle,
                                    image:
                                    DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          "assets/icons/avatar.png"),
                                    )));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done &&
                              snapshot.hasData) {
                            return Container(
                                decoration: BoxDecoration(
                                    color:
                                    MyThemes.primaryLight,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          snapshot.data!),
                                    )));
                          }

                          return const Center(
                            child:
                            CircularProgressIndicator(
                              color: MyThemes.primaryLight,
                            ),
                          );
                        },
                      ),
                    ),
                    title: Text(users[index].username),
                    subtitle: Text(
                      users[index].bio,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Scaffold(
                            body: ProfileScreen(
                                // id: users[index].email,
                                // nickname: users[index].nickname
                            ),)
                      ));
                    },
                  );
                }

                return Container();
              },
            );
          }
          return const Center(
              child: CircularProgressIndicator(
                color: MyThemes.primaryLight,
              ));
        });
  }

  //SEARCH FOR VIDEOS PER TITLE STREAM BUILDER
  Widget searchVideosPerTitleStream(){
    return StreamBuilder<List<LiveStream>>(
        stream: LiveStreamServices().getAllVideos(field, isDescending),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  '${LocaleKeys.somethingWentWrong.tr()} ${snapshot.error}',
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
            );
          }else if (snapshot.hasData) {
            final videos = snapshot.data!;
            if(videos.isEmpty){
              return Center(
              child: Text(
                  LocaleKeys.makeSearch.tr(),
                  style: GoogleFonts.ptSans(fontWeight: FontWeight.w800, fontSize: 20)),
              );
            }
            return ListView.builder(
              itemCount: videos.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                    if (_searchController.text.isNotEmpty && (videos[index].title.toLowerCase().contains(_searchController.text.toLowerCase()))) {

                      return ListTile(
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: FutureBuilder(
                        future: storage.downloadURL("video thumbnail", videos[index].thumbnailLink),
                        builder: (BuildContext context, AsyncSnapshot<String>snapshot) {
                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                            return Container(
                                decoration: BoxDecoration(
                                    color: MyThemes.primaryLight,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(snapshot.data!),)));
                          }

                          return const Center(
                            child:
                            CircularProgressIndicator(
                              color: MyThemes.primaryLight,
                            ),
                          );
                        },
                      ),
                    ),
                    title: Text(videos[index].title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: FirebaseFirestore.instance.collection("users").doc(videos[index].user).get(),
                            builder: (context, snapshot){
                            if(snapshot.hasData){
                              return Text(snapshot.data!['nickname'], overflow: TextOverflow.ellipsis,);
                            }
                            return Container();
                            }),
                        Text(tagsList(videos[index].tags)),
                      ],
                    ),
                    onTap: (){
                      LiveStream video = videos[index];

                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(video: video,)
                      ));
                    },
                  );
                }

                return Container();
              },
            );
          }
          return const Center(
              child: CircularProgressIndicator(
                color: MyThemes.primaryLight,
              ));
        });
  }

  //SEARCH FOR VIDEOS PER TAG STREAM BUILDER
  Widget searchVideosPerTagStream(){
    return StreamBuilder<List<LiveStream>>(
        stream: LiveStreamServices().getAllVideos(field, isDescending),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  '${LocaleKeys.somethingWentWrong.tr()} ${snapshot.error}',
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
            );
          }else if (snapshot.hasData) {
            final videos = snapshot.data!;
            if(videos.isEmpty){
              return Center(
                child: Text(
                    LocaleKeys.makeSearch.tr(),
                    style: GoogleFonts.ptSans(fontWeight: FontWeight.w800, fontSize: 20)),
              );
            }
            return ListView.builder(
              itemCount: videos.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                if (_searchController.text.isNotEmpty && videos[index].tags.any((String value) => value.toLowerCase().contains(_searchController.text.toLowerCase()))) {

                  return ListTile(
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: FutureBuilder(
                        future: storage.downloadURL("video thumbnail", videos[index].thumbnailLink),
                        builder: (BuildContext context, AsyncSnapshot<String>snapshot) {
                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                            return Container(
                                decoration: BoxDecoration(
                                    color: MyThemes.primaryLight,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(snapshot.data!),)));
                          }

                          return const Center(
                            child:
                            CircularProgressIndicator(
                              color: MyThemes.primaryLight,
                            ),
                          );
                        },
                      ),
                    ),
                    title: Text(videos[index].title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                            future: FirebaseFirestore.instance.collection("users").doc(videos[index].user).get(),
                            builder: (context, snapshot){
                              if(snapshot.hasData){
                                return Text(snapshot.data!['nickname'], overflow: TextOverflow.ellipsis,);
                              }
                              return Container();
                            }),
                        Text(tagsList(videos[index].tags)),
                      ],
                    ),
                    onTap: (){
                      LiveStream video = videos[index];

                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(video: video,)
                      ));
                    },
                  );
                }

                return Container();
              },
            );
          }
          return const Center(
              child: CircularProgressIndicator(
                color: MyThemes.primaryLight,
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            //THE SEARCH FIELD
            title: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Theme(
                  data: ThemeData.light(),
                  child: TextFormField(
                    key: _formKey,
                    controller: _searchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                  });
                                },
                              ),
                        hintText: LocaleKeys.search.tr(),
                        border: InputBorder.none),
                    validator: (keyword) {
                      if (keyword!.isEmpty) {
                        return LocaleKeys.enterKeywordFirst.tr();
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ),
            )),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: DefaultTabController(
              length: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    //TAB BAR
                    Container(
                      height: 45,
                      constraints: const BoxConstraints(maxWidth: 400),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        border: Border.all(color: const Color(0xFFD5D5D5)),
                      ),
                      child: TabBar(
                        onTap: (index){
                          setState(() {
                            index == 0 || index == 2 ? isVideo = true : isVideo = false;
                          });
                        },
                        labelColor: Colors.white,
                        indicator: BoxDecoration(
                            color: MyThemes.primaryLight,
                            borderRadius: BorderRadius.circular(25.0)),
                        tabs:  [
                          Tab(
                            text: LocaleKeys.videosSearch.tr(),
                          ),
                          Tab(
                            text: LocaleKeys.users.tr(),
                          ),
                          Tab(
                            text: LocaleKeys.tags.tr(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15,),

                    Visibility(
                      visible: isVideo,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DropdownButton<String>(
                              value: _dropdownValue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              borderRadius: BorderRadius.circular(12),
                              underline: Container(),
                              items: <String>['Date ↑','Date ↓', 'Title ↑', 'Title ↓', 'Views ↑', 'Views ↓', 'Likes ↑', 'Likes ↓']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: GoogleFonts.ptSans(),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) async {
                                setState(() {
                                  _dropdownValue = newValue!;
                                });

                                switch (newValue){
                                    case 'Date ↑':
                                      setState(() {
                                        field="date";
                                        isDescending=false;
                                      });
                                    break;
                                    case 'Date ↓':
                                      setState(() {
                                        field="date";
                                        isDescending=true;
                                      });
                                    break;
                                    case 'Title ↑':
                                      setState(() {
                                        field="title";
                                        isDescending=false;
                                      });
                                    break;
                                    case 'Title ↓':
                                      setState(() {
                                        field="title";
                                        isDescending=true;
                                      });
                                    break;
                                    case 'Views ↑':
                                      setState(() {
                                        field="views";
                                        isDescending=false;
                                      });
                                    break;
                                    case 'Views ↓':
                                      setState(() {
                                        field="views";
                                        isDescending=true;
                                      });
                                    break;
                                    case 'Likes ↑':
                                      setState(() {
                                        field="likes";
                                        isDescending=false;
                                      });
                                    break;
                                    case 'Likes ↓':
                                      setState(() {
                                        field="likes";
                                        isDescending=true;
                                      });
                                    break;
                                }
                              }),
                        ],
                      ),
                    ),

                    //TAB BAR CONTENT
                    Container(
                      height: MediaQuery.of(context).size.height *0.6,
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: TabBarView(
                        children: [

                          searchVideosPerTitleStream(),

                          searchUsersStream(),

                          searchVideosPerTagStream(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
