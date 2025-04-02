import 'package:flutter/material.dart';

class Questions extends StatefulWidget {
  final Function(bool) onValidationChanged;
  final Function(Map<String, dynamic>)? onDataChanged;

  const Questions({
    super.key,
    required this.onValidationChanged,
    this.onDataChanged,
  });

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

  @override
  void initState() {
    super.initState();
    _otherSourceController.addListener(() {
      _validateForm();
      _updateFormData();
    });

    // Initial validation
    _validateForm();
  }

  void _validateForm() {
    if (_formKey.currentState != null) {
      final isValid = _formKey.currentState!.validate() &&
          (_facebookSelected ||
              _instagramSelected ||
              _friendSelected ||
              _websiteSelected ||
              (_othersSelected && _otherSourceController.text.isNotEmpty));
      widget.onValidationChanged(isValid);
    }
  }

  void _updateFormData() {
    if (widget.onDataChanged != null) {
      widget.onDataChanged!({
        'facebook': _facebookSelected,
        'instagram': _instagramSelected,
        'friend': _friendSelected,
        'website': _websiteSelected,
        'others': _othersSelected ? _otherSourceController.text : null,
      });
    }
  }

  @override
  void dispose() {
    _otherSourceController.removeListener(_validateForm);
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
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Please answer the following questions',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                                title: const Text('Facebook'),
                                value: _facebookSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _facebookSelected = value ?? false;
                                    _updateFormData();
                                  });
                                  _validateForm();
                                },
                              ),
                              CheckboxListTile(
                                title: const Text('Instagram'),
                                value: _instagramSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _instagramSelected = value ?? false;
                                    _updateFormData();
                                  });
                                  _validateForm();
                                },
                              ),
                              CheckboxListTile(
                                title: const Text('A friend or relative'),
                                value: _friendSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _friendSelected = value ?? false;
                                    _updateFormData();
                                  });
                                  _validateForm();
                                },
                              ),
                              CheckboxListTile(
                                title: const Text('Tales Website'),
                                value: _websiteSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _websiteSelected = value ?? false;
                                    _updateFormData();
                                  });
                                  _validateForm();
                                },
                              ),
                              CheckboxListTile(
                                title: const Text('Others'),
                                value: _othersSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _othersSelected = value ?? false;
                                    if (_othersSelected) {
                                      FocusScope.of(context)
                                          .requestFocus(_otherSourceFocusNode);
                                    }
                                    _updateFormData();
                                  });
                                  _validateForm();
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
