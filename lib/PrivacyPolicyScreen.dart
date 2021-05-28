import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_ios, size: 18), onPressed: () => Navigator.pop(context)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('Privacy Policy'),
        ),
        body: Column(
          children: [
            Container(height: 1, color: Colors.grey.withOpacity(0.5)),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowGlow();
                    return false;
                  },
                  child: ListView(
                    children: [SizedBox(height: 10), Text(privacyPolicy)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String privacyPolicy = '''Simply Elegant built the Desktop Note app as an Ad Supported app. This SERVICE is provided by Simply Elegant at no cost and is intended for use as is.

We don't store your personal data. 
We physically can't. We don't even have a server. We don't even have a server database.

 Third party service providers

 Google Play Services
 AdMob

Links to Other Sites

This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.

Changes to This Privacy Policy

We may update our Privacy Policy from time to time. Thus, you are advised to review this for any changes.

This policy is effective as of 2021-05-27

Contact Us

If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at SimplyElegant.DesktopNote@gmail.com.''';
