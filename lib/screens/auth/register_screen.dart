import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isFrench = true;
  bool _isLoading = false;

  // Contrôleurs étape 1
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Contrôleurs étape 2
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Étape 3 — Infos BAC
  String? _selectedSerie;
  String? _selectedMention;
  String? _selectedEtablissement;

  final List<String> _series = ['S1', 'S2', 'S3', 'D', 'A', 'B', 'C', 'G'];
  final List<String> _mentions = [
    'Passable',
    'Assez Bien',
    'Bien',
    'Très Bien'
  ];

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

 void _nextStep() async {
    if (_currentStep == 0) {
      if (_formKey1.currentState!.validate()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    } else if (_currentStep == 1) {
      if (_formKey2.currentState!.validate()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    } else {
      if (_selectedSerie != null && _selectedMention != null && _selectedEtablissement != null) {
        setState(() => _isLoading = true);
        try {
          final response = await apiService.register({
            'nom': _nomController.text.trim(),
            'prenom': _prenomController.text.trim(),
            'email': _emailController.text.trim(),
            'telephone': _phoneController.text.trim(),
            'mot_de_passe': _passwordController.text,
            'serie_bac': _selectedSerie,
            'notes_bac': null,
          });
          await StorageService.saveToken(response['access_token']);
          await AuthService.refreshUser();
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }
        } catch (e) {
          setState(() => _isLoading = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erreur : $e'),
                backgroundColor: LeWayColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        }
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LeWayColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LeWayColors.headerGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _prevStep,
                        child: const Icon(Icons.arrow_back_ios_rounded,
                            color: Colors.white, size: 20),
                      ),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _isFrench = !_isFrench),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text('FR',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: _isFrench
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.5))),
                              const SizedBox(width: 6),
                              Container(
                                  width: 1,
                                  height: 12,
                                  color: Colors.white.withOpacity(0.4)),
                              const SizedBox(width: 6),
                              Text('EN',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: !_isFrench
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.5))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _isFrench ? 'Créer un compte' : 'Create account',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stepper
                  Row(
                    children: List.generate(3, (index) {
                      final isActive = index <= _currentStep;
                      final isCurrent = index == _currentStep;
                      return Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: isCurrent ? 6 : 4,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                            if (index < 2) const SizedBox(width: 6),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isFrench
                        ? 'Étape ${_currentStep + 1} sur 3'
                        : 'Step ${_currentStep + 1} of 3',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Contenu des étapes
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentStep = i),
                children: [
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                ],
              ),
            ),

            // Bouton suivant
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LeWayColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentStep == 2
                        ? (_isFrench ? 'Créer mon compte' : 'Create my account')
                        : (_isFrench ? 'Suivant' : 'Next'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ÉTAPE 1 — Infos personnelles
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildLabel(_isFrench ? 'Nom' : 'Last name'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _nomController,
              hint: _isFrench ? 'Votre nom' : 'Your last name',
              icon: Icons.person_outline_rounded,
              validator: (v) => v!.isEmpty
                  ? (_isFrench ? 'Nom requis' : 'Last name required')
                  : null,
            ),
            const SizedBox(height: 16),
            _buildLabel(_isFrench ? 'Prénom' : 'First name'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _prenomController,
              hint: _isFrench ? 'Votre prénom' : 'Your first name',
              icon: Icons.person_outline_rounded,
              validator: (v) => v!.isEmpty
                  ? (_isFrench ? 'Prénom requis' : 'First name required')
                  : null,
            ),
            const SizedBox(height: 16),
            _buildLabel('Email'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _emailController,
              hint: 'exemple@email.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v!.isEmpty
                  ? (_isFrench ? 'Email requis' : 'Email required')
                  : null,
            ),
            const SizedBox(height: 16),
            _buildLabel(_isFrench ? 'Téléphone' : 'Phone'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _phoneController,
              hint: '+229 XX XX XX XX',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) => v!.isEmpty
                  ? (_isFrench ? 'Téléphone requis' : 'Phone required')
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ÉTAPE 2 — Mot de passe
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildLabel(_isFrench ? 'Mot de passe' : 'Password'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _passwordController,
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              obscure: _obscurePassword,
              suffixIcon: GestureDetector(
                onTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                child: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: LeWayColors.textSecondary,
                  size: 20,
                ),
              ),
              validator: (v) {
                if (v!.isEmpty) {
                  return _isFrench
                      ? 'Mot de passe requis'
                      : 'Password required';
                }
                if (v.length < 6) {
                  return _isFrench
                      ? 'Minimum 6 caractères'
                      : 'Minimum 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildLabel(
                _isFrench ? 'Confirmer le mot de passe' : 'Confirm password'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _confirmPasswordController,
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              obscure: _obscureConfirm,
              suffixIcon: GestureDetector(
                onTap: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                child: Icon(
                  _obscureConfirm
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: LeWayColors.textSecondary,
                  size: 20,
                ),
              ),
              validator: (v) {
                if (v != _passwordController.text) {
                  return _isFrench
                      ? 'Les mots de passe ne correspondent pas'
                      : 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: LeWayColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: LeWayColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _isFrench
                          ? 'Minimum 6 caractères, incluant lettres et chiffres'
                          : 'Minimum 6 characters, including letters and numbers',
                      style: const TextStyle(
                        fontSize: 13,
                        color: LeWayColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ÉTAPE 3 — Infos BAC
  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildLabel(_isFrench ? 'Série du BAC' : 'BAC series'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _series.map((serie) {
              final isSelected = _selectedSerie == serie;
              return GestureDetector(
                onTap: () => setState(() => _selectedSerie = serie),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? LeWayColors.primary900
                        : LeWayColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    serie,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : LeWayColors.primaryDark,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          _buildLabel(_isFrench ? 'Mention obtenue' : 'Grade obtained'),
          const SizedBox(height: 12),
          Column(
            children: _mentions.map((mention) {
              final isSelected = _selectedMention == mention;
              return GestureDetector(
                onTap: () => setState(() => _selectedMention = mention),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? LeWayColors.primary900
                        : LeWayColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: isSelected
                            ? Colors.white
                            : LeWayColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        mention,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : LeWayColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          _buildLabel(_isFrench
              ? 'Type d\'établissement'
              : 'Type of institution'),
          const SizedBox(height: 12),
          ...['Public', 'Privé laïc', 'Privé confessionnel', 'Autre']
              .map((type) {
            final isSelected = _selectedEtablissement == type;
            return GestureDetector(
              onTap: () =>
                  setState(() => _selectedEtablissement = type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? LeWayColors.primary900
                      : LeWayColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      color: isSelected
                          ? Colors.white
                          : LeWayColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : LeWayColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: LeWayColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontSize: 15,
        color: LeWayColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: LeWayColors.textSecondary.withOpacity(0.6),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: LeWayColors.primary, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: LeWayColors.primaryLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: LeWayColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: LeWayColors.error, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

class _selectedEtablissement {
}