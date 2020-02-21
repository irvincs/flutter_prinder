import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_prinder/entities/entities.dart';
import 'package:flutter_prinder/presentation/current_image_indicator.dart';
import 'package:flutter_prinder/utils/formatters.dart';
import 'package:flutter_prinder/presentation/rounded_button_icon.dart';
import 'package:flutter_prinder/containers/detailed_info.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';


class SwipeCard extends StatefulWidget {
  SwipeCard({
    Key key,
    @required this.profile,
    this.initialImageIndex: 0,
    this.onNextImage,
    this.onPreviousImage,
    this.onSeeDetails,
    this.currentImageIndex,
  }) : assert(initialImageIndex >= 0),
        assert(initialImageIndex < profile.length || initialImageIndex == 0),
        super(key: key);

  final List<PrinterEntity> profile;
  final int initialImageIndex;
  final ValueChanged<int> onNextImage;
  final ValueChanged<int> onPreviousImage;
  final ValueChanged<int> currentImageIndex;
  final VoidCallback onSeeDetails;

  @override
  _SwipeCardState createState() => new _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  int currentImageIndex;

  @override
  void initState() {
    super.initState();
    currentImageIndex = widget.initialImageIndex;
    widget.currentImageIndex(currentImageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
        boxShadow: <BoxShadow>[
          new BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4.0,
              spreadRadius: 2.0,
              offset: new Offset(0.5, 2.0)
          )
        ],
        image: new DecorationImage(
            fit: BoxFit.scaleDown,
            image: widget.profile.length > 0
                ? new NetworkImage(widget.profile[currentImageIndex].image, scale: 1.0)
                : new AssetImage('images/empty.jpg')
        ),
      ),
      child: new Column(
        children: <Widget>[
          new Expanded(
            child: new GestureDetector(
              onTapUp: onChangeImage,
              child: new Container(
                alignment: Alignment.topCenter,
                color: Colors.transparent,
                padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: new CurrentImageIndicator(
                  size: widget.profile.length,
                  activeIndex: currentImageIndex,
                ),
              ),
            ),
          ),
          new GestureDetector(
              onTap: onSeeDetails,
              child: _buildDescription()
          )
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return new Container(
      height: 100.0,
      padding: new EdgeInsets.all(20.0),
      decoration: new BoxDecoration(
          borderRadius: new BorderRadius.only(
            bottomLeft: new Radius.circular(10.0),
            bottomRight: new Radius.circular(10.0),
          ),
          gradient: new LinearGradient(
              begin: new Alignment(0.5, 0.0),
              end: new Alignment(0.5, 1.0),
              colors: <Color>[
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ]
          )
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                  child: new Text(
                    makePrinterPresentationName(widget.profile[currentImageIndex]),
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.black
                    ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                  )
              ),

            ],
          ),
          new RoundedButtonIcon(
              color: Colors.redAccent,
              iconColor: Colors.white70,
              icon: Icons.map,
              padding: 5.0,
              onPressed: () {
                launcher(widget.profile[currentImageIndex].id,
                    widget.profile[currentImageIndex].latitude,
                    widget.profile[currentImageIndex].longitude);
              }
          ),
          new RoundedButtonIcon(
              color: Colors.redAccent,
              iconColor: Colors.white70,
              icon: Icons.info,
              padding: 5.0,
              onPressed: () {
                detailedInfo(context);
              }
          ),

        ],
      ),
    );
  }
  void detailedInfo(BuildContext context) {

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailedInfo(profile: widget.profile[currentImageIndex],

            )
        ));
  }

  Future launcher(String url, double lat, double long) async {
    if (await MapLauncher.isMapAvailable(MapType.google)) {
      await MapLauncher.launchMap(
        mapType: MapType.google,
        coords: Coords(lat, long),
        title: url,
        description: url,
      );
    }
  }
  void onChangeImage(TapUpDetails details) {
    if (details.globalPosition.dx < context.size.width / 2) {
      if (currentImageIndex > 0) {
        setState(() => currentImageIndex--);
        if (widget.onPreviousImage != null) {
          widget.onPreviousImage(currentImageIndex);
          widget.currentImageIndex(currentImageIndex);
        }
      }
    } else {
      if (currentImageIndex < widget.profile.length - 1) {
        setState(() => currentImageIndex++);
        if (widget.onNextImage != null) {
          widget.onNextImage(currentImageIndex);
          widget.currentImageIndex(currentImageIndex);
        }
      }
    }
  }

  void onSeeDetails() {
    if (widget.onSeeDetails != null)
      widget.onSeeDetails();
  }

}
