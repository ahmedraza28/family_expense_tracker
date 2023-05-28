import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Models
import '../models/access_code_model.dart';

// Features
import '../../books/books.dart';

class ShareAccessQRButton extends ConsumerWidget {
  const ShareAccessQRButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBookId = ref.watch(selectedBookProvider)!.id;
    return CustomTextButton(
      height: 36,
      width: 176,
      borderRadius: 100,
      onPressed: () {
        final accessCode = AccessCodeModel(
          inviteCode: selectedBookId,
          role: MemberRole.editor,
        );
        showDialog<void>(
          context: context,
          builder: (_) => Center(
            child: Material(
              type: MaterialType.transparency,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 36,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.8, 1),
                      colors: <Color>[
                        Color(0xFFFEEDFC),
                        Colors.white,
                        Color(0xFFE4E6F7),
                        Color(0xFFE2E5F5),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                    borderRadius: Corners.rounded20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // QR Code
                      Container(
                        padding: const EdgeInsets.all(16),
                        height: 240,
                        width: 240,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: Corners.rounded(60),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment(0.8, 1),
                            colors: <Color>[
                              Colors.white,
                              Color(0xFFE4E6F7),
                              Colors.white,
                            ],
                            tileMode: TileMode.mirror,
                          ),
                        ),
                        child: Center(
                          child: QrImage(
                            data: AppUtils.generateJWTToken(
                              accessCode.toJson(),
                            ),
                            size: 180,
                            foregroundColor: const Color(0xFF8194FE),
                          ),
                        ),
                      ),

                      // Code message
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            'Here your code!',
                            fontSize: 28,
                            color: AppColors.primaryColor,
                          ),
                          CustomText(
                            'This is your unique QR code for another person to scan',
                          ),
                        ],
                      ),

                      // Share button
                      Column(
                        children: [
                          // Button
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 32,
                                  color: const Color.fromARGB(
                                    255,
                                    133,
                                    142,
                                    212,
                                  ).withOpacity(0.68),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.share_rounded,
                              color: AppColors.primaryColor,
                            ),
                          ),

                          Insets.gapH10,

                          // Label
                          const CustomText('Share'),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      color: Colors.white,
      border: Border.all(
        color: AppColors.primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.share_rounded,
            size: 18,
            color: AppColors.primaryColor,
          ),
          Insets.gapW5,
          CustomText.subtitle(
            'Share access code',
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
