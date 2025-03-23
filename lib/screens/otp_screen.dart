import 'package:flutter/material.dart';
import 'package:jsonuiapp/services/auth_service.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final ValueNotifier<bool> _isOtpSent = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isVerifying = ValueNotifier<bool>(false);
  final FocusNode _otpFocusNode = FocusNode();

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    _isOtpSent.dispose();
    _isLoading.dispose();
    _isVerifying.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_mobileController.text.length != 10) {
      _showSnackbar("Please enter a valid 10-digit mobile number");
      return;
    }
    _isLoading.value = true;

    AuthService().signInWithPhone('+91 ${_mobileController.text}', (
      verificationId,
      forceResendingToken,
    ) {
      _isLoading.value = false;
      _isOtpSent.value = true;
      _showSnackbar("OTP Sent Successfully!");
      FocusScope.of(
        context,
      ).requestFocus(_otpFocusNode); // Auto focus OTP input
    });
  }

  void _verifyOtp() {
    if (_otpController.text.length != 6) {
      _showSnackbar("Please enter a valid 6-digit OTP");
      return;
    }
    _isVerifying.value = true;
    _showSnackbar("Verifying OTP...");

    // Add OTP verification logic here
    Future.delayed(Duration(seconds: 2), () {
      _isVerifying.value = false;
      _showSnackbar("OTP Verified Successfully!");
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: _isOtpSent,
              builder: (context, isOtpSent, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isOtpSent) ...[
                      _buildMobileInput(),
                      const SizedBox(height: 16),
                      _buildSendOtpButton(),
                    ] else ...[
                      _buildMobileNumberWithEdit(),
                      const SizedBox(height: 16),
                      _buildOtpInput(),
                      const SizedBox(height: 16),
                      _buildVerifyOtpButton(),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileInput() {
    return TextField(
      controller: _mobileController,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      onChanged: (value) => setState(() {}),
      // Refresh UI on input change
      buildCounter:
          (
            _, {
            required currentLength,
            required isFocused,
            required maxLength,
          }) => null,
      decoration: InputDecoration(
        labelText: "Mobile Number",
        hintText: "Enter your mobile number",
        border: OutlineInputBorder(),
        suffixIcon:
            _mobileController.text.length == 10
                ? Icon(Icons.check_circle, color: Colors.green)
                : null,
      ),
    );
  }

  Widget _buildSendOtpButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoading,
      builder: (context, isLoading, child) {
        return ElevatedButton(
          onPressed:
              _mobileController.text.length == 10 && !isLoading
                  ? _sendOtp
                  : null,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
          child:
              isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Send OTP"),
        );
      },
    );
  }

  Widget _buildMobileNumberWithEdit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "+91 ${_mobileController.text}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            _isOtpSent.value = false;
            _mobileController.clear();
          },
          child: Text("Edit"),
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return TextField(
      controller: _otpController,
      focusNode: _otpFocusNode,
      keyboardType: TextInputType.number,
      maxLength: 6,
      onChanged: (value) {
        if (value.length == 6) {
          _verifyOtp();
        }
      },
      decoration: InputDecoration(
        labelText: "OTP",
        hintText: "Enter OTP",
        border: OutlineInputBorder(),
        suffixIcon:
            _otpController.text.length == 6
                ? Icon(Icons.check_circle, color: Colors.green)
                : null,
      ),
    );
  }

  Widget _buildVerifyOtpButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isVerifying,
      builder: (context, isVerifying, child) {
        return ElevatedButton(
          onPressed:
              _otpController.text.length == 6 && !isVerifying
                  ? _verifyOtp
                  : null,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
          child:
              isVerifying
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Verify OTP"),
        );
      },
    );
  }
}
