import 'package:crust/components/common/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var child = Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Container(width: 50.0, height: 60.0),
      BackArrow(color: Burnt.lightGrey),
      Container(height: 20.0),
      _text('Terms & Conditions'),
      _text('By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy, or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages, or make derivative versions. The app itself, and all the trade marks, copyright, database rights and other intellectual property rights related to it, still belong to Burntoast Inc.. Burntoast Inc. is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for. The Burntoast app stores and processes personal data that you have provided to us, in order to provide our Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the Burntoast app won’t work properly or at all. The app does use third party services that declare their own Terms and Conditions. Link to Terms and Conditions of third party service providers used by the app Google Play Services (https://www.google.com/policies/privacy/). You should be aware that there are certain things that Burntoast Inc. will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi, or provided by your mobile network provider, but Burntoast Inc. cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left. If you’re using the app outside of an area with Wi-Fi, you should remember that your terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app. Along the same lines, Burntoast Inc. cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, Burntoast Inc. cannot accept responsibility. With respect to Burntoast Inc.’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavour to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. Burntoast Inc. accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app. At some point, we may wish to update the app. The app is currently available on Android & iOS – the requirements for both systems(and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. Burntoast Inc. does not promise that it will always update the app so that it is relevant to you and/or works with the Android & iOS version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device.'),
      _text('Changes to This Terms and Conditions'),
      _text('We may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. we will notify you of any changes by posting the new Terms and Conditions on this page. These terms and conditions are effective as of 2020-01-01.'),
      _text('Contact Us'),
      _text('If you have any questions or suggestions about our Terms and Conditions, do not hesitate to contact us at info@burntoast.com.')
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
