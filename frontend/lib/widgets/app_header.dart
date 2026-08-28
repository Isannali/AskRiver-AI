import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../theme/app_theme.dart";

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF7F8FB),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primaryColor,
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildLogo(),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "AskRiver",
                        style: GoogleFonts.lora(
                          fontSize: 27,
                          fontWeight: FontWeight.w500,
                          color:
                              AppTheme.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: " AI",
                        style: GoogleFonts.lora(
                          fontSize: 27,
                          fontWeight: FontWeight.w600,
                          color:
                              AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6FB79B),
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 6),

                    const Text(
                      "Asisten dokumen siap membantu",
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          _OnlineStatus(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6176C9),
            Color(0xFF4055A8),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x334050A8),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: const Icon(
        Icons.water_outlined,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}

class _OnlineStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F8),
        borderRadius:
            BorderRadius.circular(30),
        border: Border.all(
          color: AppTheme.borderColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: const Color(0xFF6FB79B),
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x556FB79B),
                  blurRadius: 8,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          const Text(
            "Online",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}