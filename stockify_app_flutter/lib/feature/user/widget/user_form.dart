import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/widget/app_button.dart';
import 'package:stockify_app_flutter/feature/user/model/user.dart';
import 'package:stockify_app_flutter/feature/user/util/user_validator.dart';

class UserForm extends StatefulWidget {
  final User? editingUser;
  final Function(User) onSave;
  final VoidCallback onCancel;
  final bool isViewOnly;

  const UserForm({
    super.key,
    this.editingUser,
    required this.onSave,
    required this.onCancel,
    this.isViewOnly = false,
  });

  @override
  State<UserForm> createState() => UserFormState();
}

class UserFormState extends State<UserForm> {
  final formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController _userNameController,
      _designationController,
      _sapIdController,
      _ipPhoneController,
      _roomNoController,
      _floorController;
  late bool _isViewOnly;

  @override
  void initState() {
    super.initState();
    _isViewOnly = widget.isViewOnly;
    _initializeControllers();
  }

  @override
  void didUpdateWidget(UserForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.editingUser != widget.editingUser) {
      _updateControllersWithNewUser();
    }
  }

  void _initializeControllers() {
    _userNameController = TextEditingController();
    _designationController = TextEditingController();
    _sapIdController = TextEditingController();
    _ipPhoneController = TextEditingController();
    _roomNoController = TextEditingController();
    _floorController = TextEditingController();
    _updateControllersWithNewUser();
  }

  void _updateControllersWithNewUser() {
    _userNameController.text = widget.editingUser?.userName ?? '';
    _designationController.text = widget.editingUser?.designation ?? '';
    _sapIdController.text = widget.editingUser?.sapId ?? '';
    _ipPhoneController.text = widget.editingUser?.ipPhone ?? '';
    _roomNoController.text = widget.editingUser?.roomNo ?? '';
    _floorController.text = widget.editingUser?.floor ?? '';
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _designationController.dispose();
    _sapIdController.dispose();
    _ipPhoneController.dispose();
    _roomNoController.dispose();
    _floorController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _saveUser() {
    if (formKey.currentState?.validate() ?? false) {
      final user = User(
        id: widget.editingUser?.id,
        userName: _userNameController.text,
        designation: _designationController.text,
        sapId: _sapIdController.text,
        ipPhone: _ipPhoneController.text,
        roomNo: _roomNoController.text,
        floor: _floorController.text,
      );
      widget.onSave(user);
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    VoidCallback? onTap,
    bool readOnly = false,
    TextInputType? keyboardType,
    int? maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          onTap: onTap,
          readOnly: readOnly || _isViewOnly,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withAlpha(30),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withAlpha(30),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            suffixIcon: suffixIcon,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        AppShortcuts.save: VoidCallbackIntent(() {
          if (!_isViewOnly) {
            _saveUser();
          }
        }),
        AppShortcuts.editItem: VoidCallbackIntent(() {
          if (_isViewOnly) {
            setState(() {
              _isViewOnly = false;
            });
          }
        })
      },
      child: Actions(
        actions: {
          VoidCallbackIntent: CallbackAction<VoidCallbackIntent>(
            onInvoke: (intent) => intent.callback(),
          ),
        },
        child: FocusScope(
          autofocus: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.outline.withAlpha(20),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isViewOnly
                          ? Icons.person_outline
                          : (widget.editingUser == null
                              ? Icons.person_add_outlined
                              : Icons.edit_outlined),
                      color: AppColors.colorAccent,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isViewOnly
                          ? 'User Details'
                          : (widget.editingUser == null
                              ? 'Add New User'
                              : 'Edit User'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    if (_isViewOnly)
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _isViewOnly = false;
                          });
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: widget.onCancel,
                      child: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
              ),
              // Form Content
              Flexible(
                child: Form(
                  key: formKey,
                  child: Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 400;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Basic Information Section
                              _buildSectionTitle('Basic Information'),
                              if (isWide)
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'User Name',
                                        controller: _userNameController,
                                        validator:
                                            UserInputValidator.validateUsername,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Designation',
                                        controller: _designationController,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildFormField(
                                      label: 'User Name',
                                      controller: _userNameController,
                                      validator:
                                          UserInputValidator.validateUsername,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildFormField(
                                      label: 'Designation',
                                      controller: _designationController,
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 16),
                              if (isWide)
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'SAP ID',
                                        controller: _sapIdController,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'IP Phone',
                                        controller: _ipPhoneController,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildFormField(
                                      label: 'SAP ID',
                                      controller: _sapIdController,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildFormField(
                                      label: 'IP Phone',
                                      controller: _ipPhoneController,
                                    ),
                                  ],
                                ),
                              // Location Information Section
                              _buildSectionTitle('Location Information'),
                              if (isWide)
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Room Number',
                                        controller: _roomNoController,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Floor Number',
                                        controller: _floorController,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildFormField(
                                      label: 'Room Number',
                                      controller: _roomNoController,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildFormField(
                                      label: 'Floor Number',
                                      controller: _floorController,
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 32),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // Action Buttons
              if (!_isViewOnly)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withAlpha(20),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton(
                        onPressed: widget.onCancel,
                        icon: Icons.cancel,
                        iconColor: AppColors.colorTextDark,
                        text: 'Cancel',
                        backgroundColor: AppColors.colorTextSemiLight,
                        foregroundColor: AppColors.colorTextDark,
                      ),
                      const SizedBox(width: 16),
                      AppButton(
                        onPressed: _saveUser,
                        icon: widget.editingUser == null
                            ? Icons.person_add
                            : Icons.save,
                        text: widget.editingUser == null
                            ? 'Add User'
                            : 'Save Changes',
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}