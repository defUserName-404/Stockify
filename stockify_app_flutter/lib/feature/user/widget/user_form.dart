import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/widget/app_button.dart';
import 'package:stockify_app_flutter/feature/user/model/user.dart';
import 'package:stockify_app_flutter/feature/user/util/user_validator.dart';

class UserForm extends StatefulWidget {
  final User? editingUser;
  final Function(User) onSave;
  final VoidCallback onCancel;

  const UserForm({
    super.key,
    this.editingUser,
    required this.onSave,
    required this.onCancel,
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
      _roomNoController,
      _floorController;

  @override
  void initState() {
    super.initState();
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
    _roomNoController = TextEditingController();
    _floorController = TextEditingController();
    _updateControllersWithNewUser();
  }

  void _updateControllersWithNewUser() {
    _userNameController.text = widget.editingUser?.userName ?? '';
    _designationController.text = widget.editingUser?.designation ?? '';
    _sapIdController.text = widget.editingUser?.sapId ?? '';
    _roomNoController.text = widget.editingUser?.roomNo ?? '';
    _floorController.text = widget.editingUser?.floor ?? '';
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _designationController.dispose();
    _sapIdController.dispose();
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
          readOnly: readOnly,
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
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outline.withAlpha(20),
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.editingUser == null
                    ? Icons.person_add_outlined
                    : Icons.edit_outlined,
                color: AppColors.colorAccent,
              ),
              const SizedBox(width: 12),
              Text(
                widget.editingUser == null ? 'Add New User' : 'Edit User',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: widget.onCancel,
                child: Icon(
                  Icons.close,
                ),
              ),
            ],
          ),
        ),
        // Form Content
        Expanded(
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
                                validator: UserInputValidator.validateUsername,
                              ),
                              const SizedBox(height: 16),
                              _buildFormField(
                                label: 'Designation',
                                controller: _designationController,
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          label: 'SAP ID',
                          controller: _sapIdController,
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
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outline.withAlpha(20),
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
                icon:
                    widget.editingUser == null ? Icons.person_add : Icons.save,
                text: widget.editingUser == null ? 'Add User' : 'Save Changes',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
