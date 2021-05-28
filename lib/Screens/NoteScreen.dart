import 'package:desktop_note/Helpers/AdHelper.dart';
import 'package:desktop_note/Providers/CreditProvider.dart';
import 'package:desktop_note/Providers/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';

import '../PrivacyPolicyScreen.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode todoFocusNode = FocusNode();
  late RewardedAd _rewardedAd;

  @override
  void initState() {
    super.initState();
    _loadData();
    _rewardedAd = RewardedAd(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          _rewardedAd.show();
          Navigator.pop(context);
        },
        onAdFailedToLoad: (ad, err) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ad Loading Failed. Try Again Later'), duration: Duration(seconds: 1)));
          setState(() {});
          ad.dispose();
        },
        onRewardedAdUserEarnedReward: (_, __) {
          Provider.of<CreditProvider>(context, listen: false).resetCredit();
          setState(() {});
        },
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  _sendData() async {
    try {
      String data = _textController.text;
      if (data.length == 0) data = '1. Create a Note !';
      return Future.wait([HomeWidget.saveWidgetData<String>('note', data)]);
    } on PlatformException catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }

  _updateWidget() async {
    try {
      HomeWidget.updateWidget(name: 'LightWidget');
      HomeWidget.updateWidget(name: 'DarkWidget');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

  _loadData() async {
    try {
      return Future.wait([
        HomeWidget.getWidgetData<String>('note', defaultValue: '1. Create a Note !').then((value) {
          if (value != null) {
            _textController.text = value;
            _textController.selection = TextSelection.fromPosition(TextPosition(offset: _textController.text.length));
          }
        }),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Getting Data. $exception');
    }
  }

  _sendAndUpdate() async {
    await _sendData();
    await _updateWidget();
  }

  watchAdAdDialog() {
    return AlertDialog(
      title: Text('No Credit Score'),
      content: Text('You need to watch an Ad to get 30 credit scores.\n\n Watch ad now ?'),
      actions: [
        TextButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('Desktop Note'),
          actions: [
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Text(
                Provider.of<CreditProvider>(context, listen: false).credit.toString(),
                style: TextStyle(color: Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Colors.white : Colors.black),
              ),
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Credit Score'),
                    content: Text(
                      'This is the number of time you can edit the note before you have to watch an Ad. \n\nAds keeps us running.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Ok'),
                      ),
                    ],
                  ),
                );
              },
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.policy,
                color: Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Colors.grey[200] : Colors.black,
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen())),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.brightness_4,
                color: Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Colors.grey[200] : Colors.black,
              ),
              onPressed: () => Provider.of<ThemeProvider>(context, listen: false).changeTheme(),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 1, color: Colors.grey.withOpacity(0.5)),
              ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: Expanded(
                  child: TextFormField(
                    focusNode: todoFocusNode,
                    autofocus: true,
                    style: TextStyle(height: 1.5),
                    maxLines: 50,
                    decoration: InputDecoration(focusColor: Colors.transparent, border: InputBorder.none),
                    controller: _textController,
                  ),
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      if (Provider.of<CreditProvider>(context, listen: false).credit > 0) {
                        _sendAndUpdate();
                        todoFocusNode.unfocus();
                        Provider.of<CreditProvider>(context, listen: false).decreaseCredit();
                        Future.delayed(const Duration(milliseconds: 150), () => SystemNavigator.pop());
                      } else {
                        var result = await showDialog(barrierDismissible: false, context: context, builder: (context) => watchAdAdDialog());
                        if (result) {
                          _rewardedAd.load();
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => WillPopScope(onWillPop: () async => false, child: Center(child: CircularProgressIndicator())),
                          );
                        }
                      }
                    },
                    child: Text('Save', style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () {
                      todoFocusNode.unfocus();
                      Future.delayed(const Duration(milliseconds: 150), () => SystemNavigator.pop());
                    },
                    child: Text('Cancel', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
