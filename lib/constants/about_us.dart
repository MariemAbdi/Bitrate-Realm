
import 'package:bitrate_realm/models/about_us.dart';
import 'package:easy_localization/easy_localization.dart';

import '../translations/locale_keys.g.dart';

Map<String, String> availableLanguages = {
  "English": "en",
  "Français": "fr",
  "العربية": "ar",
};

List<AboutUsModel> aboutUsList = [
  AboutUsModel(
    tabTitle: "NAME",//LocaleKeys.nameTitle.tr(),
    title: "Our Name, Our Mission",
    content: LocaleKeys.nameBody.tr(),
    lottieLink: "assets/lottie/sad-dog.json",
  ),
  AboutUsModel(
    tabTitle: LocaleKeys.founderTitle.tr(),
    title: "Meet the Visionary Behind Our Success",
    content: LocaleKeys.founderBody.tr(),
    ///[Founder's Name] is the driving force behind the creation of [Your Company Name]. With a passion for [industry/field], [he/she/they] envisioned a company that would challenge conventions and provide innovative solutions. With a strong background in [mention background, education, or key experience], [Founder's Name] embarked on a journey to bring this vision to life, focusing on [specific goals, values, or challenges the founder aimed to address]. Today, [his/her/their] leadership continues to inspire the company’s growth and success.
    lottieLink: "assets/lottie/sad-dog.json",
  ),
  AboutUsModel(
    tabTitle: LocaleKeys.enterpriseTitle.tr(),
    title: "Our Enterprise: A Commitment to Excellence",
    content: LocaleKeys.enterpriseBody.tr(),
    ///Since its inception, [Your Company Name] has grown from a passionate startup into a respected enterprise in the [industry/field]. We are dedicated to providing [products/services] that make a difference and help [target audience] achieve [specific goals]. Our team is our greatest asset, consisting of talented individuals who share a common goal: to deliver unmatched quality and innovation. Through sustainable practices, cutting-edge technologies, and exceptional customer service, we strive to maintain our reputation as a leader in our industry.
    lottieLink: "assets/lottie/sad-dog.json",
  ),
  AboutUsModel(
    tabTitle: LocaleKeys.valuesTitle.tr(),
    title: "Our Core Values: Guiding Principles for Success",
    content: LocaleKeys.valuesBody.tr(),
    ///At the heart of everything we do are our core values, which guide our decisions, actions, and interactions with our clients, employees, and the community. Our values include:
    //
    // Integrity: We believe in doing the right thing, even when no one is watching.
    // Innovation: Constantly evolving and embracing new ideas is key to our success.
    // Excellence: We strive for the highest quality in all our endeavors.
    // Collaboration: We work together to achieve greater results for all.
    // These values are not just words; they are the foundation of our culture and the driving force behind our continued growth and success.
    lottieLink: "assets/lottie/sad-dog.json",
  ),
];