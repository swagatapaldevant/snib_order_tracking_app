import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:snib_order_tracking_app/core/utils/commonWidgets/common_button.dart';
import 'package:snib_order_tracking_app/core/utils/constants/app_colors.dart';
import 'package:snib_order_tracking_app/core/utils/helper/common_utils.dart';
import 'package:snib_order_tracking_app/core/utils/helper/screen_utils.dart';
import 'package:snib_order_tracking_app/features/dashboard/widgets/attach_file_container.dart';

class AcknowledgeImageUploadScreen extends StatefulWidget {
  const AcknowledgeImageUploadScreen({super.key});

  @override
  State<AcknowledgeImageUploadScreen> createState() => _AcknowledgeImageUploadScreenState();
}

class _AcknowledgeImageUploadScreenState extends State<AcknowledgeImageUploadScreen> {
  final List<FileDetails> selectedFiles = [];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtils().screenWidth(context);
    final screenHeight = ScreenUtils().screenHeight(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        title: Bounceable(
            onTap: (){
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, size: 30,)),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AttachFileContainerWidget(
                      bgColor: AppColors.alphabetFunContainer4,
                      icon: Icons.attach_file,
                      textColor: AppColors.white,
                      text: 'Attach files Select from your device',
                      onTap: pickFiles
                  ),
                  AttachFileContainerWidget(
                    bgColor: AppColors.alphabetSafeArea,
                    icon: Icons.camera_alt_outlined,
                    textColor: AppColors.white,
                    text: "Capture image from camera",
                    onTap: captureImage,
                  )
                ],
              ),

              SizedBox(height: screenHeight * 0.03),

              if (selectedFiles.isNotEmpty)
                ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: selectedFiles.length,
                  itemBuilder: (context, index) {
                    final file = selectedFiles[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      color: AppColors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: Image.asset(
                          getFileIcon(file.type),
                          height: 30,
                          width: 30,
                        ),
                        title: Text(
                          file.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () => removeFile(index),
                        ),
                      ),
                    );
                  },
                ),
              SizedBox(height: screenHeight * 0.03),
              CommonButton(
                onTap: (){
                  Navigator.pushNamed(context, "/SuccessScreen");
                },
                  height: ScreenUtils().screenHeight(context)*0.05,
                  width: ScreenUtils().screenWidth(context),
                  buttonName: "Submit",
                  fontSize: 14,
                  borderRadius: 10,
                  buttonTextColor: AppColors.white,
                  gradientColor1: AppColors.alphabetFunContainer,
                  gradientColor2: AppColors.colorSkyBlue500
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Pick multiple files with validation
  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<FileDetails> tempFiles = [];

      for (var file in result.files) {
        if (file.size > 5 * 1024 * 1024) {
          CommonUtils().flutterSnackBar(
            context: context,
            mes: "File '${file.name}' is greater than 5MB!",
            messageType: 4,
          );
          continue;
        } else {
          String? mimeType = lookupMimeType(file.path!);
          tempFiles.add(FileDetails(
            name: file.name,
            type: mimeType ?? "unknown",
            file: File(file.path!),
          ));
        }
      }

      setState(() {
        selectedFiles.addAll(tempFiles);
      });
    }
  }

  /// Capture an image with validation
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
        selectedFiles.add(FileDetails(
          name: "Captured Image",
          type: "image/jpeg",
          file: file,
        ));
      });
    }
  }

  /// Remove file from list
  void removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  /// Resolve MIME type to icon path
  String getFileIcon(String type) {
    if (type == "image/jpeg" || type == "image/png") return "assets/icons/file.png";
    if (type == "application/pdf") return "assets/icons/pdf.png";
    if (type.contains("doc")) return "assets/icons/doc.png";
    if (type.contains("ppt")) return "assets/icons/powerpoint.png";
    if (type.contains("xls")) return "assets/icons/excel.png";
    return "assets/icons/fil2.png";
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