import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:snib_order_tracking_app/core/network/apiHelper/api_endpoint.dart';
import 'package:snib_order_tracking_app/core/network/apiHelper/locator.dart';
import 'package:snib_order_tracking_app/core/network/dioClient/dio_client.dart';
import 'package:snib_order_tracking_app/core/services/localStorage/shared_pref.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/common_button.dart';
import 'package:snib_order_tracking_app/core/utils/constants/app_colors.dart';
import 'package:snib_order_tracking_app/core/utils/helper/common_utils.dart';
import 'package:snib_order_tracking_app/core/utils/helper/screen_utils.dart';
import 'package:snib_order_tracking_app/features/dashboard/widgets/attach_file_container.dart';

class AcknowledgeImageUploadScreen extends StatefulWidget {
  final String requisitionId;
  final String routeListId;
  final String otp;
  final String type;
  const AcknowledgeImageUploadScreen(
      {super.key,
      required this.requisitionId,
      required this.routeListId,
      required this.otp,
      required this.type
      });

  @override
  State<AcknowledgeImageUploadScreen> createState() =>
      _AcknowledgeImageUploadScreenState();
}

class _AcknowledgeImageUploadScreenState
    extends State<AcknowledgeImageUploadScreen> {
  final List<FileDetails> selectedFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  final SharedPref _pref = getIt<SharedPref>();
  final Dio _dio = DioClient().dio;

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtils().screenWidth(context);
    final screenHeight = ScreenUtils().screenHeight(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        title: Bounceable(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, size: 30),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Please upload an image for acknowledgement",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // Show buttons only if no file selected
              // if (selectedFiles.isEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AttachFileContainerWidget(
                    bgColor: AppColors.alphabetFunContainer4,
                    icon: Icons.attach_file,
                    textColor: AppColors.white,
                    text: 'Attach files\nSelect from your device',
                    onTap: pickFiles,
                  ),
                  AttachFileContainerWidget(
                    bgColor: AppColors.alphabetSafeArea,
                    icon: Icons.camera_alt_outlined,
                    textColor: AppColors.white,
                    text: "Capture image\nfrom camera",
                    onTap: captureImage,
                  )
                ],
              ),

              SizedBox(height: screenHeight * 0.03),

              // Single file card
              if (selectedFiles.isNotEmpty)
                Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  color: AppColors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Image.asset(
                      getFileIcon(selectedFiles.first.type),
                      height: 30,
                      width: 30,
                    ),
                    title: Text(
                      selectedFiles.first.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => removeFile(0),
                    ),
                  ),
                ),

              SizedBox(height: screenHeight * 0.03),

             isLoading?CircularProgressIndicator(
               color: AppColors.alphabetFunContainer1,
             ): CommonButton(
                onTap: () {
                  print(widget.type);
                  widget.type == "pickup"?
                  pickupConsignment():dropOffConsignment();
                  //Navigator.pushNamed(context, "/SuccessScreen");
                },
                height: screenHeight * 0.05,
                width: screenWidth,
                buttonName: "Submit",
                fontSize: 14,
                borderRadius: 10,
                buttonTextColor: AppColors.white,
                gradientColor1: AppColors.alphabetFunContainer,
                gradientColor2: AppColors.colorSkyBlue500,
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Pick single file with validation
  Future<void> pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;

      if (file.size > 5 * 1024 * 1024) {
        CommonUtils().flutterSnackBar(
          context: context,
          mes: "File '${file.name}' is greater than 5MB!",
          messageType: 4,
        );
        return;
      }

      String? mimeType = lookupMimeType(file.path!);

      setState(() {
        selectedFiles.clear(); // Replace any existing file
        selectedFiles.add(FileDetails(
          name: file.name,
          type: mimeType ?? "unknown",
          file: File(file.path!),
        ));
      });
    }
  }

  /// Capture image with validation
  Future<void> captureImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      File file = File(image.path);

      if (file.lengthSync() > 5 * 1024 * 1024) {
        CommonUtils().flutterSnackBar(
          context: context,
          mes: "Captured image is greater than 5MB!",
          messageType: 4,
        );
        return;
      }

      setState(() {
        selectedFiles.clear(); // Replace any existing file
        selectedFiles.add(FileDetails(
          name: "Captured Image",
          type: "image/jpeg",
          file: file,
        ));
      });
    }
  }

  /// Remove the selected file
  void removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  /// Resolve MIME type to icon asset
  String getFileIcon(String type) {
    if (type == "image/jpeg" || type == "image/png")
      return "assets/icons/file.png";
    if (type == "application/pdf") return "assets/icons/pdf.png";
    if (type.contains("doc")) return "assets/icons/doc.png";
    if (type.contains("ppt")) return "assets/icons/powerpoint.png";
    if (type.contains("xls")) return "assets/icons/excel.png";
    return "assets/icons/fil2.png";
  }

  Future<void> pickupConsignment() async {
    setState(() {
      isLoading = true;
    });

    try {
      final authToken = await _pref.getUserAuthToken();
      final url = ApiEndPoint.verifyOtp;

      // Create FormData with file and fields
      final formData = FormData.fromMap({
        "requisition": widget.requisitionId,
        "routeListId": widget.routeListId,
        "otp": widget.otp,
        if (selectedFiles.isNotEmpty)
          "file": await MultipartFile.fromFile(
            selectedFiles.first.file.path,
          ),
      });

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        // Handle success (navigate or show message)
        Navigator.pushNamed(context, "/SuccessScreen");
      } else {
        CommonUtils().flutterSnackBar(
          context: context,
          mes: "Invalid OTP",
          messageType: 4,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        CommonUtils().flutterSnackBar(
          context: context,
          mes: "${e.response?.data}",
          messageType: 4,
        );
        print("${e.response?.data}");
      } else {
        CommonUtils().flutterSnackBar(
          context: context,
          mes: "${e.message}",
          messageType: 4,
        );
        print("${e.message}");
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> dropOffConsignment() async {
    setState(() {
      isLoading = true;
    });

    try {
      final authToken = await _pref.getUserAuthToken();
      final url = ApiEndPoint.dropOff;

      // Create FormData with file and fields
      final formData = FormData.fromMap({
        "requisition": widget.requisitionId,
        "routeListId": widget.routeListId,
        "otp": widget.otp,
        if (selectedFiles.isNotEmpty)
          "file": await MultipartFile.fromFile(
            selectedFiles.first.file.path,
          ),
      });

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        // Handle success (navigate or show message)
        Navigator.pushNamed(context, "/SuccessScreen");
      } else {
        CommonUtils().flutterSnackBar(
          context: context,
          mes: "Invalid OTP",
          messageType: 4,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        CommonUtils().flutterSnackBar(
          context: context,
          mes: "${e.response?.data}",
          messageType: 4,
        );
        print("${e.response?.data}");
      } else {
        CommonUtils().flutterSnackBar(
          context: context,
          mes: "${e.message}",
          messageType: 4,
        );
        print("${e.message}");
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

/// Data model for selected file
class FileDetails {
  final String name;
  final String type;
  final File file;

  FileDetails({
    required this.name,
    required this.type,
    required this.file,
  });
}
