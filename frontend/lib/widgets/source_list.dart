// Modifikasi kecil di lib/widgets/source_list.dart
import "package:flutter/material.dart";
import "../models/source.dart";
import "../theme/app_theme.dart"; // Tambahkan import theme

class SourceList extends StatelessWidget {
  final List<Source> sources;
  final String answer;

  const SourceList({
    super.key,
    required this.sources,
    required this.answer,
  });

  bool _shouldHideSources() {
    if (sources.isEmpty) {
      return true;
    }

    final normalizedAnswer = answer.toLowerCase();

    const irrelevantResponses = [
      "tidak ditemukan dalam dokumen",
      "tidak ada dalam dokumen",
      "tidak terdapat dalam dokumen",
      "tidak tersedia dalam dokumen",
      "tidak relevan",
      "di luar konteks",
      "diluar konteks",
      "tidak memiliki informasi",
      "maaf, saya tidak menemukan",
    ];

    return irrelevantResponses.any(
      normalizedAnswer.contains,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldHideSources()) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        const Text(
          "Sources:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary, // Tambahkan warna dari AppTheme
          ),
        ),

        const SizedBox(height: 4),

        ...sources.map(
          (source) {
            final filename =
                source.metadata["filename"] ??
                    "Unknown document";

            final page =
                source.metadata["page"];

            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                page != null
                    ? "• $filename — Page $page"
                    : "• $filename",
                style: const TextStyle(
                  color: AppTheme.textSecondary, // Tambahkan warna dari AppTheme
                  fontSize: 13,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}