import 'package:flutter/material.dart';

class Questions extends StatefulWidget {
  const Questions({super.key});

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  final _formKey = GlobalKey<FormState>();
  final _otherSourceController = TextEditingController();
  final _otherSourceFocusNode = FocusNode();

  // Checkbox states for learning sources
  bool _facebookSelected = false;
  bool _instagramSelected = false;
  bool _friendSelected = false;
  bool _websiteSelected = false;
  bool _othersSelected = false;

  // Checkbox states for branch selection
  bool _bakhundoleSelected = false;
  bool _gairidharaSelected = false;

  // Workshop selection states
  final Map<String, bool> _workshopSelections = {
    'Basic Grooming Workshop': false,
    'Advanced Grooming Workshop': false,
    'Pet Styling Workshop': false,
    'Pet Care Workshop': false,
    'Business Management Workshop': false,
  };

  // Getter for selected workshops
  List<String> get selectedWorkshops => _workshopSelections.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();

  // Getter for display text
  String get workshopDisplayText {
    if (selectedWorkshops.isEmpty) return 'Select workshops';
    if (selectedWorkshops.length == 1) return selectedWorkshops.first;
    return '${selectedWorkshops.length} workshops selected';
  }

  @override
  void dispose() {
    _otherSourceController.dispose();
    _otherSourceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(32, 16, 32, 0),
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.5,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 2,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Questions',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'Inter',
                                    fontSize: 24,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Please answer the following questions',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'Inter',
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontSize: 14,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Divider(
                                thickness: 2,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From where did you learn about Grooming Tales? *',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckboxListTile(
                                title: Text('Facebook'),
                                value: _facebookSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _facebookSelected = value ?? false;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text('Instagram'),
                                value: _instagramSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _instagramSelected = value ?? false;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text('A friend or relative'),
                                value: _friendSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _friendSelected = value ?? false;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text('Tales Website'),
                                value: _websiteSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _websiteSelected = value ?? false;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text('Others'),
                                value: _othersSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _othersSelected = value ?? false;
                                    if (_othersSelected) {
                                      _otherSourceFocusNode.requestFocus();
                                    }
                                  });
                                },
                              ),
                              if (_othersSelected)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 8, 0, 0),
                                  child: TextFormField(
                                    controller: _otherSourceController,
                                    focusNode: _otherSourceFocusNode,
                                    decoration: InputDecoration(
                                      hintText: 'Please specify other source',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Divider(
                                thickness: 2,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Which branch of Grooming tales are you joining? *',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckboxListTile(
                                title: Text(
                                    'Grooming tales, Bakhundole, Lalitpur'),
                                value: _bakhundoleSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _bakhundoleSelected = value ?? false;
                                    if (_bakhundoleSelected) {
                                      _gairidharaSelected = false;
                                    }
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text(
                                    'Grooming tales, Gairidhara, Kathmandu'),
                                value: _gairidharaSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _gairidharaSelected = value ?? false;
                                    if (_gairidharaSelected) {
                                      _bakhundoleSelected = false;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Divider(
                                thickness: 2,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Workshops you want to join? *',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                          child: PopupMenuButton<String>(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.outline,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    workshopDisplayText,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                            itemBuilder: (BuildContext context) {
                              return _workshopSelections.entries.map((entry) {
                                return PopupMenuItem<String>(
                                  value: entry.key,
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: entry.value,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _workshopSelections[entry.key] =
                                                value ?? false;
                                          });
                                        },
                                      ),
                                      SizedBox(width: 8),
                                      Text(entry.key),
                                    ],
                                  ),
                                );
                              }).toList();
                            },
                            onSelected: (String value) {
                              // Handle selection if needed
                            },
                          ),
                        ),
                        if (selectedWorkshops.isEmpty)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                            child: Text(
                              'Please select at least one workshop',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
