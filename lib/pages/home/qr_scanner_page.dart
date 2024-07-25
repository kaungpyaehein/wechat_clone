import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scan/scan.dart';
import 'package:wechat_clone/blocs/scan_qr_bloc.dart';
import 'package:wechat_clone/pages/home/my_qr_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/extensions.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({
    super.key,
  });

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  ScanController controller = ScanController();

  @override
  void dispose() {
    controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScanQRBloc(),
      child: Builder(builder: (context) {
        final bloc = context.read<ScanQRBloc>();

        return Scaffold(
          body: Stack(
            children: [
              //// Scanner View
              ScanView(
                controller: controller,
                scanAreaScale: .7,
                scanLineColor: Colors.white,
                onCapture: (data) {
                  print(data.toString());

                  bloc.onDetectData(data.toString()).then((_) {
                    print("data is ========== $data");
                  }).catchError((error) {
                    widget.showErrorSnackBarWithMessage(
                        context, error.toString());
                  }).whenComplete(() => Navigator.pop(context));
                },
              ),

              const Positioned(
                left: kMarginMedium2,
                child: SafeArea(
                  child: BackButton(
                    color: Colors.white,
                    style: ButtonStyle(),
                  ),
                ),
              ),

              TapToScanView(),

              MyQRButtonView()
            ],
          ),
        );
      }),
    );
  }
}

class TapToScanView extends StatelessWidget {
  const TapToScanView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: kMargin45,
      right: kMargin45,
      top: 130,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(kMarginMedium2)),
        padding: const EdgeInsets.all(kMarginMedium3),
        child: const Column(
          children: [
            Text(
              "Tap to Scan",
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.w700,
                fontSize: kText18,
              ),
            ),
            SizedBox(
              height: kMargin5,
            ),
            Text(
              "Scan the QR code to add your friend in contact.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyQRButtonView extends StatelessWidget {
  const MyQRButtonView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 100,
      right: 100,
      bottom: 100,
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyQRPage(),
              ));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(kMarginMedium2)),
          padding: const EdgeInsets.all(kMarginMedium3),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code,
                  color: kPrimaryColor,
                ),
                SizedBox(
                  width: kMarginMedium2,
                ),
                Text(
                  "My QR",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: kText18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
