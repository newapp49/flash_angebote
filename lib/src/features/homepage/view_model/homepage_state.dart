abstract class HomePageState{
  const HomePageState();
}


class HomePageInitial extends HomePageState{
  const HomePageInitial();
}


class HomePageLoading extends HomePageState{
  const HomePageLoading();
}

class HomePageComplete extends HomePageState{
  const HomePageComplete();
}


class HomePageError extends HomePageState{
  final String error;
  const HomePageError(this.error);
}
