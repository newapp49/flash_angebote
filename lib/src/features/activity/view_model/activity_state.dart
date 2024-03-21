abstract class ActivityPageState {
  const ActivityPageState();
}

class ActivityPageInitial extends ActivityPageState {
  const ActivityPageInitial();
}

class ActivityPageLoading extends ActivityPageState {
  const ActivityPageLoading();
}

class ActivityPageComplete extends ActivityPageState {
  const ActivityPageComplete();
}

class ActivityPageError extends ActivityPageState {
  final String error;
  const ActivityPageError(this.error);
}
