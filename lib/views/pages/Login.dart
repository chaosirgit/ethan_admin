import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/helpers/helper.dart';
import 'package:ethan_admin/services/StorageService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

class LoginController extends GetxController {
  // Create a connector
  WalletConnect? connector;
  SessionStatus? session;
  String qrcode = "";

  LoginController() {generateConnector();}

  void generateConnector() {
    if (this.connector == null) {
      this.connector = WalletConnect(
        bridge: 'https://bridge.walletconnect.org',
        clientMeta: PeerMeta(
          name: 'EthanAdmin',
          description: 'Admin App',
          url: 'https://ethan.admin',
          icons: [
            // 'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ],
        ),
      );
      // Subscribe to events
      this.connector!.on('connect', (session) async {
        this.session = session as SessionStatus;
        final storage = Get.find<StorageService>();
        await storage.box.write("account", this.session?.accounts[0]);
        Get.offAllNamed("/");
      });
      this
          .connector!
          .on('session_update', (payload) => print("payload: $payload"));
      this
          .connector!
          .on('disconnect', (session) => this.connector!.killSession());
    }
  }

  Future<void> refreshQrcode() async {

    if(connector!.connected){
      connector!.killSession();
    }
    if (session != null) {
      session = null;
    }
    generateConnector();
    if (!connector!.connected) {
      session = await connector!.createSession(
        chainId: 56,
        onDisplayUri: (uri) {
          qrcode = uri;
          update();
        },
      );
    }
  }
}

class Login extends StatelessWidget {
  // Layout({Key? key,required this.child});
  Login({Key? key}) : super(key: key);
  final LoginController lc = Get.put(LoginController());

  // Widget child;
  @override
  Widget build(BuildContext context) {
    lc.refreshQrcode();
    return Scaffold(
        body: SafeArea(
      //异形屏适配
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          flex: 5,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Text(
                    "Please scan QR code with Trust Wallet App for login",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                /// Name 输入框
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: SizedBox(
                    child: GetBuilder<LoginController>(
                      builder: (_) {
                        return QrImage(
                          data: lc.qrcode,
                          version: QrVersions.auto,
                          size: 400,
                          backgroundColor: Colors.white70,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: GetBuilder<LoginController>(
                    builder:(_){
                      return ElevatedButton(
                        onPressed: () {
                          lc.refreshQrcode();
                        }, child: Icon(Icons.refresh),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    ));
  }
}
