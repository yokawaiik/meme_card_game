import 'package:flutter/material.dart';

class GameSpaceBoardView extends StatelessWidget {
  const GameSpaceBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                InkWell(
                  onTap: () => _lookAtSituation(context),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Situation id: 2131241242355-fghjc",
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: textTheme.headlineMedium,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Description: bla bla bla bla bla bla bla bla  bl bla bla bla bla  bl bla bla bla bla  bl bla bla bla bla  bl bla bla bla bla  bl bla bla bla bla  blbla bla bla bla  bla bla bla bla  bla bla bla bla bla bla bla bla bla bla bla bla blabla blablablabla blabla bla blablablabla blablablabla blablablabla blablablabla blablablabla",
                          softWrap: true,
                          textAlign: TextAlign.justify,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 12,
                ),
              ],
            ),
          ),
        ];
      },
      body: GridView.builder(
        itemCount: 10,
        padding: EdgeInsets.symmetric(horizontal: 4),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => _openCard(context),
            child: Stack(
              children: [
                Container(
                  decoration:
                      BoxDecoration(color: colorScheme.secondaryContainer),
                  child: Center(
                    child: Icon(
                      Icons.image,
                      color: colorScheme.onSecondaryContainer,
                      size: 50,
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: ActionChip(
                    onPressed: () => _voteForTheCard(context),
                    backgroundColor: colorScheme.primaryContainer,
                    // side: BorderSide.none,
                    label: Text("5"),
                    avatar: CircleAvatar(
                      child: Icon(
                        Icons.favorite,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _lookAtSituation(BuildContext context) {
    // todo: _lookAtSituation
  }

  _voteForTheCard(BuildContext context) {
    // todo: _voteForTheCard
  }

  _openCard(BuildContext context) {
    // todo: _voteForTheCard
  }
}
