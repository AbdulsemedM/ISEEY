class ResetPasswordResponse {
  final bool success;
  final String message;

  ResetPasswordResponse({required this.success, required this.message});

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  // toString method for debugging
  @override
  String toString() {
    return 'ResetPasswordResponse{success: $success, message: $message}';
  }
  
}