import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SectionEditor extends StatefulWidget {
  final String sectionId;
  final String content;
  final Function(String) onChanged;
  final bool isEditable;

  const SectionEditor({
    super.key,
    required this.sectionId,
    required this.content,
    required this.onChanged,
    this.isEditable = true,
  });

  @override
  State<SectionEditor> createState() => _SectionEditorState();
}

class _SectionEditorState extends State<SectionEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.content);
  }

  @override
  void didUpdateWidget(SectionEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content) {
      _controller.text = widget.content;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getSectionTitle(AppLocalizations l10n, String sectionId) {
    switch (sectionId) {
      case 'basic_info':
        return l10n.sectionBasicInfo;
      case 'strengths':
        return l10n.sectionStrengths;
      case 'weaknesses':
        return l10n.sectionWeaknesses;
      case 'likes':
        return l10n.sectionLikes;
      case 'dislikes':
        return l10n.sectionDislikes;
      case 'short_term_goals':
        return l10n.sectionShortTermGoals;
      case 'long_term_goals':
        return l10n.sectionLongTermGoals;
      case 'favorite_pastimes':
        return l10n.sectionFavoritePastimes;
      case 'family_situation':
        return l10n.sectionFamilySituation;
      case 'social_relationship':
        return l10n.sectionSocialRelationship;
      case 'financial_situation':
        return l10n.sectionFinancialSituation;
      case 'mental_conditions':
        return l10n.sectionMentalConditions;
      case 'health_conditions':
        return l10n.sectionHealthConditions;
      default:
        return sectionId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getSectionTitle(l10n, widget.sectionId),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              enabled: widget.isEditable,
              maxLines: 5,
              minLines: 5,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: _getSectionTitle(l10n, widget.sectionId),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
