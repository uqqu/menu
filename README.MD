**menu** is a script which provide you many small auxiliary functionality for work with text and some more.

With this script you will get access to:
  * 15 transforming text functions of three categories
  * 5 easy data access functions
  * several other functions
  * easy tuning [qPhyx](https://github.com/uqqu/layout)

All functions available from the keyboard in two or three taps.

As input can be used clipboard, current selected text or internal text input window.
Output can be performed as text to input or to separate text message.


## Function listing

### Transforming text functions

  * Fix text functions
    * Normalize case and spaces
    <br>`Input:  " 	—	teST!?so ,i'M a test  	string	;and i’m too .  	"`
    <br>`Output: "— Test!? So, I'm a test string; and I’m too."`
    * Normalize case (sentence function)
    <br>`Input:  " 	—	teST!?so ,i'M a test  	string	;and i’m too .  	"`
    <br>`Output: " 	—	Test!?so ,i'm a test  	string;and I’m too .  	"`
    * Invert case
    * To Capitalized Case
    * to lowercase
    * TO UPPERCASE
  * Latin <-> Cyrillic script transformations
    * Transliteration en <-> ru; ru -> en
    * qwerty <–> йцукен
    * qphyx_lat <–> qphyx_cyr
  * Calculate expression
    <br>`Input:  "(1+2 * 3 ^4)/5**2"`
    <br>`Output: "6.52"`
  * Format time by template
    <br>`Input:  "dd/MMMM (ddd)"`
    <br>`Output: "12/September (Sun)"`
  * Currency converter (currencies set by user in any currency submenu).
    <br>`Input:  "100"`
    <br>`Output: "84.45"` (USD to EUR pair, for example)
  * Unknown currency converter
    <br>`Input:  "৳100"`
    <br>`Output: "100 Bangladeshi taka to usd: 1.18"` (... to USD, for example)

> Currency functions receive actual rates from [getgeoapi](https://getgeoapi.com/). You need to get API key there and paste it to your environment variables with variable name `GETGEOAPI`.

### Easy data access functions

  * User predefined values for fast-paste
  * Fast datetime paste functions
    * Standard date / time / datetime
    * Hexal date system (10 months, 6 weeks each, 6 days each + 1 additional "new-year week" per year)
    * Decimal time (10h, 100m each, 100s each. Second is 15.74% faster)
  * Exchange rate for user set currency pairs (works with [getgeoapi](https://getgeoapi.com/))
  * Emoji paste
  * Current weather (Condition, temp., "feels like", wind speed)
  <br>`Output: "Clouds
  21.34° (20.37°)
  3.22m/s"`

> Weather function receive actual data from [openweathermap](https://openweathermap.org/). You need to get API key there and paste it to your environment variables with variable name `OPENWEATHERMAP`.
<br>You also need to add environment variable `CITY` and specify the city you are interested in.

### Other small functions

  * Auto music pause on long idle. "Idle duration" set by user, editable in two taps at any time
  * Minimalistic reminder
  * Text identity comparator

### Qphyx management

  * Change language mode (Latin and Cyrillic, separately)
  * Toggle some options (dotted/dotless i; no-break space; esc as caps; numpad availability)
  * Define user keys
  * Set "long press" delay
  * Disable/enable qPhyx completely

> This submenu shown only if you use [qPhyx](https://github.com/uqqu/layout) project and set path to `qPhyx` folder in `config.ini`


## Installation

> Windows only ¯\\\_(ツ)\_/¯

1. *(optional)* Install <a href="https://www.autohotkey.com/">AHK</a>, if you want to use uncompiled version;
2. Place [menu.exe](https://github.com/uqqu/menu/blob/master/menu.exe) or its uncompiled counterpart – [menu.ahk](https://github.com/uqqu/menu/blob/master/menu.ahk) in a folder of your choice and run first time;
3. Edit generated `config.ini` near the `menu`;
4. *(optional)* Get API key to convert currency from [getgeoapi](https://getgeoapi.com/) and add it to environment variables with `GETGEOAPI` name;
5. *(optional)* Get API key to weather data from [openweathermap](https://openweathermap.org/) and add it to environment variables with `OPENWEATHERMAP` name;
6. *(recommended)* Look at [qPhyx](https://github.com/uqqu/layout). If you would like to try, set path to `qPhyx` folder in `config.ini` near `menu`, and path to `menu` folder in `config.ini` near `qPhyx`.


## FAQ

¯\\\_(ツ)_/¯