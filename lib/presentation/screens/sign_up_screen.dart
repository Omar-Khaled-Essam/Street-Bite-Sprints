import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streetbrite/l10n/app_localizations.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/message_resolver.dart';
import '../../core/utils/validators.dart';
import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.shell,
                (_) => false,
              );
            }
            if (state is AuthFailureState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                SnackBar(content: Text(resolveMessage(context, state.message))),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text(
                      l10n.signUpTitle,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 28),
                    AppTextField(
                      controller: _name,
                      hint: l10n.fullName,
                      validator: (v) => Validators.fullName(
                        v,
                        l10n.requiredField,
                        l10n.nameCapitalError,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _email,
                      hint: l10n.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          Validators.email(v, l10n.requiredField, l10n.emailError),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _password,
                      hint: l10n.password,
                      obscure: true,
                      validator: (v) => Validators.password(
                        v,
                        l10n.requiredField,
                        l10n.passwordError,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _confirm,
                      hint: l10n.confirmPassword,
                      obscure: true,
                      validator: (v) => Validators.confirm(
                        v,
                        _password.text,
                        l10n.requiredField,
                        l10n.confirmPasswordError,
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: l10n.createAccount,
                      busy: state is AuthLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().register(
                            fullName: _name.text.trim(),
                            email: _email.text.trim(),
                            password: _password.text,
                          );
                        }
                      },
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        l10n.alreadyHaveAccount,
                        style: const TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
