import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/colors.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  bool _isFrench = true;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
        }
      });
      return _secondsRemaining > 0;
    });
  }

  void _resendCode() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
      for (var c in _controllers) {
        c.clear();
      }
    });
    _startTimer();
    // TODO: appel API resend OTP quand Chéri livre l'endpoint
  }

  void _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length < 6) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    // TODO: remplacer par appel API quand Chéri livre /auth/verify-otp
    // final response = await authService.verifyOtp(otp);

    if (otp == '123456') {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFrench
                  ? 'Code incorrect. Réessaie.'
                  : 'Wrong code. Try again.',
            ),
            backgroundColor: LeWayColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        for (var c in _controllers) {
          c.clear();
        }
        _focusNodes[0].requestFocus();
      }
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
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
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
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
                  const SizedBox(height: 24),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.sms_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isFrench ? 'Vérification SMS' : 'SMS Verification',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isFrench
                        ? 'Entre le code à 6 chiffres envoyé sur ton téléphone'
                        : 'Enter the 6-digit code sent to your phone',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Bandeau code de test
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3), width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bug_report_outlined,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          _isFrench
                              ? 'Mode test — code : 123456'
                              : 'Test mode — code: 123456',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Champs OTP
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48,
                    height: 56,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: LeWayColors.primary,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: LeWayColors.primaryLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: LeWayColors.primary, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        }
                        if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        final otp =
                            _controllers.map((c) => c.text).join();
                        if (otp.length == 6) {
                          _verifyOtp();
                        }
                      },
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 32),

            // Timer + Renvoyer
            _canResend
                ? GestureDetector(
                    onTap: _resendCode,
                    child: Text(
                      _isFrench
                          ? 'Renvoyer le code'
                          : 'Resend the code',
                      style: const TextStyle(
                        fontSize: 14,
                        color: LeWayColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Text(
                    _isFrench
                        ? 'Renvoyer dans ${_secondsRemaining}s'
                        : 'Resend in ${_secondsRemaining}s',
                    style: TextStyle(
                      fontSize: 14,
                      color: LeWayColors.textSecondary.withOpacity(0.7),
                    ),
                  ),

            const Spacer(),

            // Bouton vérifier
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LeWayColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _isFrench ? 'Vérifier' : 'Verify',
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
}