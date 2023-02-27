import 'package:flutter/material.dart';

Color _tertiaryColor = Color(0xFF3E363F);
Color _highlightColor = Colors.white;
Color _primaryColor = Color(0xFF2292A4);
Color _secondaryColor = Color(0xFFDD403A);
/// The color of the text, used in TextTheme
Color _textColor = _tertiaryColor;
// Color _textColor = Colors.black;
// Color _splashColor = Color(0xFF95b1db);
Color _splashColor = Colors.grey[300]!;
Color _canvasColor = Color(0xFFF5EFED);
var _greyColor = Colors.grey[500];

double textScaleFactor = 1;

ThemeData theme(BuildContext context){ 
  textScaleFactor = MediaQuery.textScaleFactorOf(context);
  return ThemeData(
    colorScheme: _colorScheme,
    splashColor: _splashColor,
    primaryColor: _primaryColor,
    highlightColor: _highlightColor,
    canvasColor: _canvasColor,
    fontFamily: 'Poppins',
    iconTheme: _iconTheme,
    inputDecorationTheme: _inputDecorationTheme,
    textTheme: _textTheme,
    textSelectionTheme: _textSelectionTheme,
    textButtonTheme: _textButtonTheme,
    elevatedButtonTheme: _elevatedButtonThemeData,
    buttonTheme: _buttonTheme,
    appBarTheme: _appBarTheme,
    snackBarTheme: _snackBarTheme,
    bottomNavigationBarTheme: _bottomNavigationBarTheme,
    floatingActionButtonTheme: _floatingActionButtonTheme,
    timePickerTheme: _timePickerThemeData,
    radioTheme: _radioThemeData,
    unselectedWidgetColor: _greyColor
  );
}

RadioThemeData _radioThemeData = RadioThemeData(
  fillColor: MaterialStateProperty.all<Color>(_primaryColor),

);

TimePickerThemeData _timePickerThemeData = TimePickerThemeData(
  backgroundColor: _canvasColor,
  
);

ColorScheme _colorScheme = ColorScheme(
  primary: _primaryColor,
  secondary: _secondaryColor,
  tertiary: _tertiaryColor, 
  background: _highlightColor, 
  brightness: Brightness.light, 
  error: Colors.red, 
  onBackground: Colors.black, 
  onError: _highlightColor, 
  onPrimary: Colors.black, 
  onSecondary: _highlightColor, 
  onTertiary: _highlightColor,
  onSurface: Colors.black, 
  surface: _primaryColor,
);

TextTheme _textTheme = TextTheme(
  headline1: TextStyle(
    color: _primaryColor,
    fontSize: 30*(1/textScaleFactor),
    fontWeight: FontWeight.w600
  ),
  headline2: TextStyle(
    color: _primaryColor,
    fontSize: 23*(1/textScaleFactor),
    fontWeight: FontWeight.w400
  ),
  /// Large text within body
  headline3: TextStyle(
    color: _primaryColor,
    fontSize: 20*(1/textScaleFactor),
    fontWeight: FontWeight.w400
  ),
  /// Text within AppBar
  headline4: TextStyle(
    color: _canvasColor,
    fontSize: 22*(1/textScaleFactor),
    fontWeight: FontWeight.bold
  ),
  /// Small text in TextButton
  headline5: TextStyle(
    color: _canvasColor,
    fontSize: 20*(1/textScaleFactor),
    // fontStyle: FontStyle.italic,
    //fontWeight: FontWeight.bold
  ),
  /// Should be for text within AppBar? (NOT YET)
  /// Used for Place's name throughout the app
  headline6: TextStyle(
    color: _textColor,
    fontSize: 18*(1/textScaleFactor),
    fontWeight: FontWeight.w400
  ),
  /// Subtitle1 refers to the input style in a text field
  subtitle1: TextStyle(
    color: _highlightColor
  ),
  subtitle2: TextStyle(
    color: _canvasColor,
    fontSize: 13*(1/textScaleFactor)
  ),
  bodyText1: TextStyle(
    color: _textColor,
    fontSize: 16*(1/textScaleFactor),
    //fontWeight: FontWeight.bold
  ),
  bodyText2: TextStyle(
    color: _textColor,
    fontSize: 13*(1/textScaleFactor),
    //fontWeight: FontWeight.bold
  ),
  /// Used inside "Detail" class
  /// Same size as overline but with FontWeight.bold
  labelMedium: TextStyle(
    color: _primaryColor,
    fontSize: 22*(1/textScaleFactor),
    //fontWeight: FontWeight.bold
  ),
  /// Small white text used within text buttons (in filter)
  caption: TextStyle(
    color: _secondaryColor,
    fontSize: 14*(1/textScaleFactor),
  ),
  /// Used inside "Detail" class
  /// Same size as labelMedium but without FontWeight.bold
  overline: TextStyle(
    letterSpacing: 0,
    color: _primaryColor,
    fontSize: 13*(1/textScaleFactor),
  ),
);

ButtonThemeData _buttonTheme = ButtonThemeData(
  splashColor: Colors.white70,
  // colorScheme: ColorScheme(
  //   error: Colors.red.withOpacity(0.3),
  //   background: _primaryColor,
  //   primaryVariant: _primaryColor,
  //   secondaryVariant: _primaryColor,
  //   onBackground: _primaryColor,
  //   onError: _primaryColor,
  //   onPrimary: _primaryColor,
  //   onSecondary: _primaryColor,
  //   onSurface: _primaryColor,
  //   brightness: Brightness.light,
  //   surface: _primaryColor,
  //   primary: _primaryColor,
  //   secondary: _secondaryColor

  // )
);

ElevatedButtonThemeData _elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(
      _highlightColor
    ),
    backgroundColor: MaterialStateProperty.all<Color>(
      _primaryColor
    ),
    
    padding: MaterialStateProperty.all<EdgeInsets>(
      EdgeInsets.symmetric(vertical: 15, horizontal: 30)
    ),
    textStyle: MaterialStateProperty.all<TextStyle>(
      TextStyle(
        fontSize: 20*(1/textScaleFactor),
      )
    ),
    /// Doesn't depend on whether it is focused or not
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      )
    ),
  )
);

TextButtonThemeData _textButtonTheme = TextButtonThemeData(
  style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(
      _highlightColor
    ),
    backgroundColor: MaterialStateProperty.all<Color>(
      _primaryColor
    ),
    overlayColor: MaterialStateProperty.all<Color>(
      _splashColor
    ),
    padding: MaterialStateProperty.all<EdgeInsets>(
      EdgeInsets.symmetric(vertical: 15, horizontal: 30)
    ),
    textStyle: MaterialStateProperty.all<TextStyle>(
      TextStyle(
        fontSize: 17*(1/textScaleFactor),
        color: _highlightColor 
      )
    ),
    /// Doesn't depend on whether it is focused or not
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      )
    ),
  )
);

IconThemeData _iconTheme = IconThemeData(
  color: Colors.black
);

TextSelectionThemeData _textSelectionTheme = TextSelectionThemeData(
  cursorColor: _secondaryColor,
  selectionHandleColor: _secondaryColor,
  selectionColor: _secondaryColor
  // cursorColor: _secondaryColor,
  // selectionHandleColor: _secondaryColor,
  // selectionColor: _secondaryColor
);

InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
  focusColor: _secondaryColor,
  // fillColor: _primaryColor,
  fillColor: _highlightColor,
  filled: true,
  floatingLabelBehavior: FloatingLabelBehavior.always,
  contentPadding: EdgeInsets.symmetric( horizontal: 0),
  suffixStyle: TextStyle(color: _highlightColor,),
  labelStyle: TextStyle(
    color: _greyColor,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.transparent)
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.transparent)
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.transparent),
  ),
);

BottomNavigationBarThemeData _bottomNavigationBarTheme = BottomNavigationBarThemeData(
  // showSelectedLabels: false,
  // showUnselectedLabels: false,
  elevation: 0,
  selectedItemColor: _secondaryColor,
  // backgroundColor: Colors.grey[200],
  backgroundColor: _canvasColor,
  //selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  unselectedLabelStyle: TextStyle(color: Colors.black),
  unselectedItemColor: _primaryColor,
  selectedIconTheme: IconThemeData(
    size: 30
  ),
  unselectedIconTheme: IconThemeData(
    size: 30
  ),
);

AppBarTheme _appBarTheme = AppBarTheme(
  elevation: 0,
  backgroundColor: Colors.transparent,
  titleTextStyle: TextStyle(
    color: _tertiaryColor,
    fontSize: 23*(1/textScaleFactor),
    fontWeight: FontWeight.bold
    //fontFamily: 'Raleway'
  )
);

SnackBarThemeData _snackBarTheme = SnackBarThemeData(
  backgroundColor: _primaryColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
  ),
  behavior: SnackBarBehavior.floating,
  contentTextStyle: TextStyle(
    fontFamily: "Raleway"
  )
);

FloatingActionButtonThemeData _floatingActionButtonTheme = FloatingActionButtonThemeData(
  splashColor: _splashColor,
  backgroundColor: _primaryColor,
  hoverColor: Colors.black,
  focusColor: Colors.black,
  disabledElevation: 0,
);