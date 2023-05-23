class OnBoardingScreenModel {
  final String title;
  final String description;
  final String imageUrl;

  OnBoardingScreenModel(
      {required this.title,
        required this.description,
        required this.imageUrl});
}

  List<OnBoardingScreenModel> contents = [
      OnBoardingScreenModel(
        title: 'Fast, Fluid & Secure',
        description: 'Enjoy The Best Live Streams In The Palm Of Your Hands.',
        imageUrl: 'assets/lottie/livestreaming.json',
      ),
      OnBoardingScreenModel(
        title: 'Follow Your Favorites',
        description: 'Connect & Follow Your Favorite Streamers Anytime Anywhere.',
        imageUrl: 'assets/lottie/man-and-woman-creating-podcast.json',
      ),
      OnBoardingScreenModel(
        title: 'Your Audience Is Here',
        description: 'You Want To Launch Your Own Steams? You\'re Only Some Clicks Away.',
        imageUrl: 'assets/lottie/people-with-microphones.json',
      ),
      OnBoardingScreenModel(
        title: 'Let The Show Begin!',
        description: 'What Are You Still Waiting For? Let The Adventure Begin Now!',
        imageUrl: 'assets/lottie/onBoarding.json',
      ),
];
