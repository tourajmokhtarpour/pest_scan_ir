import 'package:flutter/material.dart';
import '../models/pest.dart';
import '../utils/constants.dart';

class PestCard extends StatelessWidget {
  final Pest pest;
  final VoidCallback? onTap;

  const PestCard({
    Key? key,
    required this.pest,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: pest.quarantineClass == 'A1' 
                ? Colors.red.withOpacity(0.3) 
                : Colors.orange.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.bug_report,
                color: AppConstants.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pest.persianName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pest.scientificName,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pest.commonName,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            _buildQuarantineBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuarantineBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: pest.quarantineClass == 'A1' 
            ? Colors.red.withOpacity(0.2) 
            : Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: pest.quarantineClass == 'A1' ? Colors.red : Colors.orange,
          width: 1.5,
        ),
      ),
      child: Text(
        pest.quarantineClass,
        style: TextStyle(
          color: pest.quarantineClass == 'A1' ? Colors.red : Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}