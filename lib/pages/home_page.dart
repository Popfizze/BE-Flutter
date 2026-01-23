import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/experience_detail_view.dart';
import '../widgets/home/experience_list_header.dart';
import '../widgets/home/experience_list_view.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  double _leftPanelWidth = 450.0;
  int? _selectedExperienceIndex;

  @override
  Widget build(BuildContext context) {
    // Note: 'experiences' used to be watched here, but now it is watched inside ExperienceListView

    return Scaffold(
      backgroundColor: const Color.fromRGBO(144, 146, 170, 1.0),
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.only(top: 10, left: 25),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                      width: _leftPanelWidth,
                      child: Container(
                        color: const Color.fromRGBO(206, 206, 211, 1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ExperienceListHeader(
                              key: const Key('headerExperienceList'),
                              onClearAll: () {
                                setState(() {
                                  _selectedExperienceIndex = null;
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            Expanded(
                              key: const Key('experienceList'),
                              child: ExperienceListView(
                                onSelect: (index) {
                                  setState(() {
                                    _selectedExperienceIndex = index;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      )),
                  MouseRegion(
                    cursor: SystemMouseCursors.resizeColumn,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          _leftPanelWidth += details.delta.dx;
                          if (_leftPanelWidth < 200) _leftPanelWidth = 200;
                        });
                      },
                      child: Container(
                        width: 5,
                        color: const Color.fromRGBO(206, 206, 211, 1.0),
                        alignment: Alignment.center,
                        child: Container(
                          width: 1,
                          color: const Color.fromRGBO(206, 206, 211, 1.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: const Color(0XDEDEDEFF),
                      child: _selectedExperienceIndex != null
                          ? ExperienceDetailView(
                              experienceIndex: _selectedExperienceIndex!,
                              // Force rebuild when selection changes
                              key: ValueKey(_selectedExperienceIndex),
                            )
                          : const Center(
                              child: Text(
                                '',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
