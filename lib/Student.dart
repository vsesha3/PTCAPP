import 'package:flutter/material.dart';

class StudentProfile extends StatefulWidget {
  final Function(bool) onValidationChanged;

  const StudentProfile({
    super.key,
    required this.onValidationChanged,
  });

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final _formKey = GlobalKey<FormState>();
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();
  final _textController3 = TextEditingController();
  final _textController4 = TextEditingController();
  final _nickNameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _otherInfoController = TextEditingController();
  String _selectedGender = 'Male';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Add listeners to all text controllers
    _textController1.addListener(_validateForm);
    _textController2.addListener(_validateForm);
    _textController3.addListener(_validateForm);
    _textController4.addListener(_validateForm);
    _nickNameController.addListener(_validateForm);
    _schoolController.addListener(_validateForm);
    _otherInfoController.addListener(_validateForm);
  }

  void _validateForm() {
    if (_formKey.currentState != null) {
      final isValid = _formKey.currentState!.validate();
      widget.onValidationChanged(isValid);
    }
  }

  @override
  void dispose() {
    _textController1.removeListener(_validateForm);
    _textController2.removeListener(_validateForm);
    _textController3.removeListener(_validateForm);
    _textController4.removeListener(_validateForm);
    _nickNameController.removeListener(_validateForm);
    _schoolController.removeListener(_validateForm);
    _otherInfoController.removeListener(_validateForm);
    _textController1.dispose();
    _textController2.dispose();
    _textController3.dispose();
    _textController4.dispose();
    _nickNameController.dispose();
    _schoolController.dispose();
    _otherInfoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _textController3.text =
            "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Student Profile',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                      ),
                      Text(
                        'Please fill in the following information',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'Inter',
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: Theme.of(context).colorScheme.outline,
                    height: 24,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Column
                      Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              // Handle image upload
                            },
                            child: Text('Change'),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      // Name Fields Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'First Name *',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                            SizedBox(height: 4),
                            TextFormField(
                              controller: _textController1,
                              decoration: InputDecoration(
                                hintText: 'Enter your first name',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Last Name *',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                            SizedBox(height: 4),
                            TextFormField(
                              controller: _textController2,
                              decoration: InputDecoration(
                                hintText: 'Enter your last name',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Birth Date *',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 8, 0, 0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(),
                                  ),
                                ),
                                TextFormField(
                                  controller: _textController3,
                                  readOnly: true,
                                  onTap: () => _selectDate(context),
                                  decoration: InputDecoration(
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                                    hintText: 'DD-MM-YYYY',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                                    suffixIcon: Icon(Icons.calendar_today),
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
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gender *',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile<String>(
                                        title: Text('Male'),
                                        value: 'Male',
                                        groupValue: _selectedGender,
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              _selectedGender = value;
                                              _textController4.text = value;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile<String>(
                                        title: Text('Female'),
                                        value: 'Female',
                                        groupValue: _selectedGender,
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              _selectedGender = value;
                                              _textController4.text = value;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nick Name',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 4, 0, 0),
                                  child: TextFormField(
                                    controller: _nickNameController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter nick name',
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
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Child School *',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 4, 0, 0),
                                  child: TextFormField(
                                    controller: _schoolController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter school name',
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
                          'Other Information',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: TextFormField(
                            controller: _otherInfoController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Enter any additional information',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.outline,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
          ),
        ),
      ),
    );
  }
}
