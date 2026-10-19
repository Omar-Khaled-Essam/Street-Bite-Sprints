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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
                      l10n.loginTitle,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 28),
                    AppTextField(
                      fieldKey: const ValueKey('login_email'),
                      controller: _email,
                      hint: l10n.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          Validators.email(v, l10n.requiredField, l10n.emailError),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      fieldKey: const ValueKey('login_password'),
                      controller: _password,
                      hint: l10n.password,
                      obscure: true,
                      validator: (v) => Validators.password(
                        v,
                        l10n.requiredField,
                        l10n.passwordError,
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      key: const ValueKey('login_button'),
                      label: l10n.login,
                      busy: state is AuthLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().login(
                            _email.text.trim(),
                            _password.text,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.signUp),
                      child: Text(
                        l10n.noAccount,
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
