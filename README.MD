﻿**menu** is a script which provide you many small auxiliary functionality for work with text and some more.

With this script you will get access to:
  * 15 transforming text functions of three categories
  * 5 easy data access functions
  * 4 other functions
  * easy tuning [qPhyx](https://github.com/uqqu/menu)

All functions available from the keyboard in two or three taps.

As input can be used clipboard, current selected text or internal text input window.
Output can be performed as text to input or to separate text message.


## Function listing

### Transforming text functions

  * Fix text functions
    * Normalize case and spaces
    `Input:  " 	—	teST!?so ,i'M a test  	string	;and i’m too .  	"`
    `Output: "— Test!? So, I'm a test string; and I’m too."`
    * Normalize case (sentence function)
    `Input:  " 	—	teST!?so ,i'M a test  	string	;and i’m too .  	"`
    `Output: " 	—	Test!?so ,i'm a test  	string;and I’m too .  	"`
    * Capitalized case
    `Input:  "new test string"`
    `Output: "New Test String"`
    * Uppercase
    * Lowercase
    * Inverted case
  * Latin <-> Cyrillic script transformations
    * Transliterations en <-> ru; ru -> en
    * qwerty <–> йцукен fix
    * qphyx_lat <–> qphyx_cyr fix
  * Calculete expression
    `Input:  "(1+2 * 3 ^4)/5**2"`
    `Output: "6.52"`
  * Format time by template
    `Input:  "dd/MMMM (ddd)"`
    `Output: "12/September (Sun)"`
  * Currency converter (currencies set by user in any currency submenu).
    `Input:  "100"`
    `Output: "84.45"` (USD to EUR pair, for example)
  * Unknown currency converter
    `Input:  "৳100"`
    `Output: "100 Bangladeshi taka to usd: 1.18"` (... to USD, for example)

> Currency functions receive actual rates from [getgeoapi](https://getgeoapi.com/). You need to get API key there and paste it to your environment variables with variable name `GETGEOAPI`.

### Easy data access functions

  * User predefined values for fast-paste
  * Fast datetime paste functions
    * Standard date / time / datetime
    * Hexal date system (10 months, 6 weeks each, 6 days each + 1 additional "new-year week" per year)
    * Decimal time (10h, 100m each, 100s each. Second is 15.74% faster)
  * Exchange rate for user set currency pairs (works with [getgeoapi](https://getgeoapi.com/))
  * Emoji
  * Current weather (Condition, temp., "feels like", wind speed)
  `Clouds
  21.34° (20.37°)
  3.22m/s`

> Weather function receive actual data from [openweathermap](https://openweathermap.org/). You need to get API key there and paste it to your environment variables with variable name `OPENWEATHERMAP`.
<br>You also need to add environment variable `CITY` and specify the city you are interested in.

### Other small functions

  * Auto music pause on long idle. Set by user, editable in two taps
  * Minimalistic reminder
  * Text identity comparator
  * Auto muter Spotify process when title becomes "advertisement"

> Last function works with [nircmd](https://nircmd.nirsoft.net/). You need to download it and set path to this file in `config.ini`, or just place it near `menu` without edit config.

### Qphyx management

  * Change num-row mode (Latin and Cyrillic, separately)
  * Define user keys
  * Toggle dotted/dotless i feature
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
6. *(optional)* Place [nircmd](https://nircmd.nirsoft.net/) near `menu` or set path to it in `config.ini` to Spotify advertisement muting;
7. *(recommended)* Look at [qPhyx](https://github.com/uqqu/layout). If you would like to try, set path to `qPhyx` folder in `config.ini` near `menu`, and path to `menu` folder in `config.ini` near `qPhyx`.


## FAQ

¯\_(ツ)_/¯