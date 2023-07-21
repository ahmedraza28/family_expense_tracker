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
  const ShareAccessQRButton({
    required this.height,
    super.key,
  });

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBookId = ref.watch(selectedBookProvider)?.id;
    return selectedBookId == null
        ? Insets.shrink
        : CustomTextButton(
            height: height,
            width: 176,
            borderRadius: 100,
            onPressed: () {
              final accessCode = AccessCodeModel(
                inviteCode: selectedBookId,
                role: MemberRole.editor,
              );
              showDialog<void>(
                context: context,
                barrierColor: AppColors.barrierColor.withOpacity(0.75),
                builder: (_) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Center(
                    child: Material(
                      type: MaterialType.transparency,
                      child: SingleChildScrollView(
                        child: Container(
                          height: 500,
                          padding: const EdgeInsets.all(40),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment(0.8, 1),
                              colors: <Color>[
                                Color(0xFFE4E6F7),
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
                                height: 210,
                                width: 210,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: Corners.rounded20,
                                  gradient: LinearGradient(
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
                                  child: QrImageView(
                                    data: AppUtils.generateJWTToken(
                                      accessCode.toJson(),
                                    ),
                                    dataModuleStyle: const QrDataModuleStyle(
                                      color: Color(0xFF8194FE),
                                    ),
                                    eyeStyle: const QrEyeStyle(
                                      color: Color(0xFF8194FE),
                                      eyeShape: QrEyeShape.square,
                                    ),
                                    size: 180,
                                  ),
                                ),
                              ),

                              Insets.gapH5,

                              // Code message
                              const Column(
                                children: [
                                  CustomText(
                                    'Here your code',
                                    fontSize: 24,
                                    color: AppColors.primaryColor,
                                  ),
                                  Insets.gapH5,
                                  CustomText(
                                    'This is your unique QR code for another person to scan',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ],
                              ),

                              Insets.gapH5,

                              // Share button
                              Column(
                                children: [
                                  // Button
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
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
