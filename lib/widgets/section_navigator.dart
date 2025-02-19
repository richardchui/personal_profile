import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:personal_profile/l10n/app_localizations.dart';
import 'package:personal_profile/widgets/section_editor.dart';

class SectionNavigator extends StatefulWidget {
  final Map<String, dynamic> sections;
  final Function(Map<String, dynamic>) onSectionsChanged;
  final bool isEditable;

  const SectionNavigator({
    super.key,
    required this.sections,
    required this.onSectionsChanged,
    this.isEditable = true,
  });

  @override
  State<SectionNavigator> createState() => _SectionNavigatorState();
}

class _SectionNavigatorState extends State<SectionNavigator> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> _sectionsList = [];

  @override
  void initState() {
    super.initState();
    _loadSections();
  }

  Future<void> _loadSections() async {
    final jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/sections.json');
    final data = json.decode(jsonString);
    final sections = List<Map<String, dynamic>>.from(data['sections']);
    sections.sort((a, b) => a['order'].compareTo(b['order']));
    setState(() {
      _sectionsList = sections;
    });
  }

  void _onSectionChanged(String sectionId, String value) {
    final newSections = Map<String, dynamic>.from(widget.sections);
    newSections[sectionId] = value;
    widget.onSectionsChanged(newSections);
  }

  void _navigateToSection(int index) {
    if (index >= 0 && index < _sectionsList.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  String _getSectionTitle(BuildContext context, String titleKey) {
    final l10n = AppLocalizations.of(context)!;
    switch (titleKey) {
      case 'section.basic_info':
        return l10n.sectionBasicInfo;
      case 'section.work_experience':
        return l10n.sectionWorkExperience;
      case 'section.education':
        return l10n.sectionEducation;
      case 'section.skills':
        return l10n.sectionSkills;
      case 'section.projects':
        return l10n.sectionProjects;
      case 'section.certifications':
        return l10n.sectionCertifications;
      case 'section.languages':
        return l10n.sectionLanguages;
      case 'section.volunteer_work':
        return l10n.sectionVolunteerWork;
      case 'section.awards':
        return l10n.sectionAwards;
      case 'section.publications':
        return l10n.sectionPublications;
      case 'section.patents':
        return l10n.sectionPatents;
      case 'section.references':
        return l10n.sectionReferences;
      case 'section.personal_interests':
        return l10n.sectionPersonalInterests;
      case 'section.social_media':
        return l10n.sectionSocialMedia;
      case 'section.financial_situation':
        return l10n.sectionFinancialSituation;
      case 'section.mental_conditions':
        return l10n.sectionMentalConditions;
      case 'section.health_conditions':
        return l10n.sectionHealthConditions;
      default:
        return titleKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_sectionsList.isEmpty) {
      return Center(
        child: Text(l10n.noSections),
      );
    }

    final currentSection = _sectionsList[_currentIndex];
    final sectionId = currentSection['id'] as String;
    final sectionContent = widget.sections[sectionId] ?? '';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _currentIndex,
                  decoration: const InputDecoration(
                    labelText: 'Section',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (var i = 0; i < _sectionsList.length; i++)
                      DropdownMenuItem(
                        value: i,
                        child: Text(_getSectionTitle(context, _sectionsList[i]['titleKey'] as String)),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      _navigateToSection(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: SectionEditor(
                  sectionId: sectionId,
                  content: sectionContent.toString(),
                  onChanged: (value) => _onSectionChanged(sectionId, value),
                  isEditable: widget.isEditable,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _currentIndex > 0
                          ? () => _navigateToSection(_currentIndex - 1)
                          : null,
                      child: const Text('Previous'),
                    ),
                    Text(
                      '${_currentIndex + 1}/${_sectionsList.length}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    ElevatedButton(
                      onPressed: _currentIndex < _sectionsList.length - 1
                          ? () => _navigateToSection(_currentIndex + 1)
                          : null,
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
