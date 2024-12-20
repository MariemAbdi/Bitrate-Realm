class AlertData{
  final String title, description, lottieAsset;
  final void Function()? onConfirm;
  
  AlertData({
    required this.title,
    required this.description,
    required this.lottieAsset,
    required this.onConfirm,
  });

}