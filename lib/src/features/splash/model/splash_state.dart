abstract class SplashState {
  SplashState();
}

class SplashInitial extends SplashState {
  SplashInitial();
}

class SplashLoading extends SplashState {
  SplashLoading();
}

class SplashCompleted extends SplashState {
  SplashCompleted();
}

class SplashError extends SplashState {
  final String message;

  SplashError(this.message);
}
