import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Models
import '../models/access_code_model.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

// Features
import '../../books/books.dart';

class QrScannerScreen extends StatefulWidget {
  final VoidCallback? onPressed;

  const QrScannerScreen({
    super.key,
    this.onPressed,
  });

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late final MobileScannerController _qrController;

  @override
  void initState() {
    super.initState();
    _qrController = MobileScannerController();
  }

  @override
  void dispose() {
    _qrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      appBar: AppBar(
        title: const CustomText(
          'QR Scanner',
          fontSize: 20,
        ),
        actions: [
          // Rotate Camera
          IconButton(
            onPressed: _qrController.switchCamera,
            icon: ValueListenableBuilder<CameraFacing>(
              valueListenable: _qrController.cameraFacingState,
              builder: (_, state, __) {
                return state == CameraFacing.front
                    ? const Icon(Icons.camera_front_rounded)
                    : const Icon(Icons.camera_rear_rounded);
              },
            ),
          ),

          // Flash On/Off
          ValueListenableBuilder<CameraFacing>(
            valueListenable: _qrController.cameraFacingState,
            builder: (_, state, child) {
              return state == CameraFacing.back
                  ? child!
                  : const SizedBox.shrink();
            },
            child: IconButton(
              onPressed: _qrController.toggleTorch,
              icon: ValueListenableBuilder<TorchState>(
                valueListenable: _qrController.torchState,
                builder: (_, state, __) {
                  return state == TorchState.on
                      ? const Icon(Icons.lightbulb_rounded)
                      : const Icon(Icons.lightbulb_outline);
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Insets.gapH(40),

          // Instructions
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: CustomText(
              'Please scan the invite QR code shared by the owner.',
              textAlign: TextAlign.center,
              fontSize: 16,
              maxLines: 2,
              color: AppColors.textGreyColor,
            ),
          ),

          Insets.gapH(40),

          // Scanner
          SizedBox(
            height: 300,
            width: 300,
            child: Consumer(
              builder: (_, ref, __) {
                return MobileScanner(
                  controller: _qrController,
                  onDetect: (barcode) {
                    final code = barcode.raw;
                    final args = AppUtils.decodeJWTToken(code as String);
                    final accessCode = AccessCodeModel.fromJson(args);
                    ref.read(booksProvider.notifier).addMemberToBook(
                          bookId: accessCode.inviteCode,
                          role: accessCode.role,
                        );
                    (widget.onPressed ?? AppRouter.pop).call();
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
