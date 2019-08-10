import 'dart:convert';

import 'package:crust/components/screens/register_screen.dart';
import 'package:crust/main.dart';
import 'package:crust/models/user.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/me/me_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

class PrivacyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var child = Column(children: <Widget>[
      Container(height: 20.0),
      _text('Privacy Policy'),
      _text('Before we get into the detail, we just want to make sure you know that your privacy is important to us. We know you’ve heard this all before, but quite frankly, we mean it. You’ve placed your trust in us by using the UNiDAYS services and we value that trust. That means we’re committed to protecting and safeguarding any personal data you give us.\nSo anyway, here we go with the detail. This Privacy Policy explains who we are, how and why we collect, share and use personal information about you, and how you can exercise your privacy rights. If you have any questions, or any confusions about our use of your personal information, please contact us using the contact details provided on the “How to contact us” section below.'),
      _text('Accessing Our Site'),
      _text(
        'Access to our Site is permitted on a temporary basis, and we reserve the right to withdraw or amend the service we provide on our Site without notice (see below). We will not be liable if for any reason our Site is unavailable at any time or for any period.\nFrom time to time, we may restrict access to some parts of our Site, or our entire site, to users who have registered with us.\nIf you choose, or you are provided with, a user identification code, password or any other piece of information as part of our security procedures, you must treat such information as confidential, and you must not disclose it to any third party. We have the right to disable any user identification code or password, whether chosen by you or allocated by us, at any time, if in our opinion you have failed to comply with any of the provisions of these Terms.\nYou are responsible for making all arrangements necessary for you to have access to our Site. You are also responsible for ensuring that all persons who access our Site through your Internet connection are aware of these terms, and that they comply with them.\nBy obtaining a promotional code or accessing an offer or discount through our Site, you acknowledge that such offer or discount is subject to third party terms and conditions and it is your responsibility to review such terms and conditions before entering into any transaction with that third party.\nThe UNiDAYS service is not intended for individuals under the age of 16 years old. If you are under 16 years of age, you are not permitted to use the UNiDAYS service. By using the service, you confirm that you are at least 16 years of age. If you are 16 to 17 years of age, you may only sign up to the UNiDAYS service with the consent of a parent or legal guardian. By using the UNiDAYS service you confirm that you have such consent and that you shall abide by and comply with these Terms. If you are 18 years of age or over you confirm that you are fully able and competent to enter into the terms, conditions, obligations, confirmations, representations, and warranties set forth in these Terms, and to abide by and comply with these Terms.'),
      _text('Intellectual property rights'),
      _text(
        'We are the owner of all intellectual property rights in our Site. With the exception of information that has been gathered from other websites and product and company advertisements, we also own the intellectual property rights in the materials published on the Site. These works are protected by copyright laws and treaties around the world. All such rights are reserved.\nYou may print off one copy, and may download extracts, of any page(s) from our Site for your personal reference and you may draw the attention of others to material posted on our Site, unless as directed.\nYou must not modify the paper or digital copies of any materials you have printed off or downloaded in any way, and you must not use any illustrations, photographs, video or audio sequences or any graphics separately from any accompanying text.\nOur status (and that of any identified contributors) as the authors of material on our Site must always be acknowledged.\nYou must not use any part of the materials on our Site for commercial purposes without first obtaining a licence from us to do so.\nIf you print off, copy or download any part of our Site in breach of these Terms, your right to use our Site will cease immediately and you must, at our option, return or destroy any copies of the materials you have made.'),
    ]);
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverSafeArea(
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: child,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _text(String text) {
    return Container(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Text(text),
    );
  }
}
