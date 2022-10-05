import 'package:flutter/services.dart';


class TextConstant {
  static String metamuskAddress = "0xb794f5ea0ba39494ce839613fffba74279579268";
  static String dummyText1 =
      "Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat";

  static String dummyText2 =
      "Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat"
      "Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat";

  static String dummyText3 =
      "Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat"
      "Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat"
      "Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat";

  static String dummyText4 =
      "Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat"
      "Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat"
      "Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat"
      "Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat";

  static List<String> categories = ["Vegetable", "Cereal", "Fruit"];
  static List<String> productNames = [
    "Pineapple",
    'Grapefruit',
    "Avocado",
    "Pepper",
    "Cucumber",
    'Strawberry',
    'Onion',
    'Spring onion',
    'Watermelon',
    'Tomatoes',
    'Okro',
    'Maize',
    'Garlic',
    'Egg plant',
    'Cabbage',
    'Carrot',
    'Banana'
  ];

  static List<String> productWeightUnits = [
    "Grams",
    "Kilograms",
    "Tonnes",
  ];

  static List fakeAddress = [
    "0xD5cE086A9d4987Adf088889A520De98299E10bb5",
    "0x6B5C35d525D2d94c68Ab5c5AF9729092fc8771Dd",
    "0x4541c7745c82DF8c10bD4A58e28161534B353064",
    "0x0a00Fb2e074Ffaaf6c561164C6458b5C448120FC",
    "0x3A3999e6501e2a36dD3C0B8Fc2Bd165fc4a22e54"
  ];


static List<TextInputFormatter> inputFormatterForWholeNumbers = [
  FilteringTextInputFormatter.allow(RegExp('[1-9]')),
  LengthLimitingTextInputFormatter(10)
];
static List<TextInputFormatter> inputFormatterForDecimal = [
  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
  
  LengthLimitingTextInputFormatter(10)
];

static List<TextInputFormatter> inputFormatterForText1= [
  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
  FilteringTextInputFormatter.allow(RegExp(' ')),
  LengthLimitingTextInputFormatter(10)
];

static List<TextInputFormatter> inputFormatterForText2 = [
  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
  FilteringTextInputFormatter.allow(RegExp(' ')),
  LengthLimitingTextInputFormatter(30)
];

static List<TextInputFormatter> inputFormatterMetaMuskID = [];

}

