import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http_proxy/http_proxy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpProxy httpProxy = await HttpProxy.createHttpProxy();
  httpProxy.host = "104.20.89.77";// replace with your server ip
  httpProxy.port = "80";// replace with your server port
  HttpOverrides.global=httpProxy;
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InterstitialAd? interstitialAd;
  bool isInterstitialAdLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAdInter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Ads"), centerTitle: true),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: EdgeInsets.only(left: 170),
          child: ElevatedButton(
              onPressed: () {
                interstitialAd!.show();
              },
              child: Text("Inter Ad")),
        )
      ]),
    );
  }

  void loadAdInter() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-3940256099942544/1033173712",
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(

                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {
                  loadAdInter();
                },
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            print('====$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            // setState(() {
            setState(() {
              interstitialAd = ad;
              isInterstitialAdLoaded = true;
            });
            // });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            setState(() {
              isInterstitialAdLoaded = false;
            });
          },
        ));
  }
}
