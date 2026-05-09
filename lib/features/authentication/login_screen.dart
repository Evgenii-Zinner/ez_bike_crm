import '../../utils/imports.dart';

/// The entry-point screen for unauthenticated users.
///
/// Provides a Google Sign-In interface and coordinates with the [AuthService]
/// to authenticate the user before redirecting to the [MainScreen].
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider);
    final appStrings = ref.watch(localizationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appStrings!.login),
      ),
      body: FutureBuilder(
        future: Future.value(null),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Trigger Google Sign-In via the AuthService.
                  await authService.signInWithGoogle();

                  // Navigate to the MainScreen upon successful authentication.
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()),
                    );
                  }
                },
                child: Text(appStrings.login),
              ),
            );
          }
        },
      ),
    );
  }
}
