import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/chat_provider.dart";
import "../theme/app_theme.dart";

class DocumentUploader extends StatelessWidget {
  const DocumentUploader({super.key});

  Future<void> _pickAndUpload(
    BuildContext context,
  ) async {
    final messenger =
        ScaffoldMessenger.of(context);

    final chatProvider =
        context.read<ChatProvider>();

    try {
      final PlatformFile? file =
          await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ["pdf"],
      );

      if (file == null) {
        return;
      }

      final fileBytes =
          await file.readAsBytes();

      if (fileBytes.isEmpty) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              "Gagal membaca data file PDF",
            ),
          ),
        );
        return;
      }

      await chatProvider.uploadDocument(
        filename: file.name,
        fileBytes: fileBytes,
      );

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            "${file.name} berhasil diupload",
          ),
        ),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            "Upload gagal: $error",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<ChatProvider>();

    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderColor,
          ),
        ),
      ),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: provider.isUploading
                ? null
                : () => _pickAndUpload(context),
            icon: const Icon(
              Icons.upload_file_outlined,
            ),
            label: const Text(
              "Upload PDF",
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor:
                  const Color(0xFFF0F3FA),
              foregroundColor:
                  AppTheme.primaryColor,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 17,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18),
                side: const BorderSide(
                  color: AppTheme.borderColor,
                ),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 16),

          if (provider.isUploading)
            const SizedBox(
              width: 24,
              height: 24,
              child:
                  CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),

          if (provider.uploadedFilename != null &&
              !provider.isUploading)
            Expanded(
              child: Container(
                height: 54,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FB),
                  borderRadius:
                      BorderRadius.circular(18),
                  border: Border.all(
                    color: AppTheme.borderColor,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.attach_file,
                      color:
                          AppTheme.textSecondary,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        provider
                            .uploadedFilename!,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          color:
                              AppTheme.textPrimary,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                    ),

                    const Icon(
                      Icons.close,
                      size: 20,
                      color:
                          AppTheme.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}