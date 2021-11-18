;===============================================================================================
;============================================Presets============================================
;===============================================================================================

#SingleInstance Force
#UseHook On

;main config.ini variables
Global MAIN_KEY
Global MUS_CHECK_DELAY
Global MUS_PAUSE_DELAY
Global NIRCMD_FILE

Global DISABLED := 0
Global EXT := A_IsCompiled ? ".exe" : ".ahk"
Global INI := "config.ini"
IfExist, %INI%
{
    IniRead, MAIN_KEY,          %INI%, Configuration, MainKey
    IniRead, MUS_CHECK_DELAY,   %INI%, Configuration, MusCheckDelay
    IniRead, MUS_PAUSE_DELAY,   %INI%, Configuration, MusPauseDelay
    IniRead, NIRCMD_FILE,       %INI%, Configuration, NircmdFile
}
Else
{
    IniWrite, SC02B,            %INI%, Configuration, MainKey
    IniWrite, 666,              %INI%, Configuration, MusCheckDelay
    IniWrite, 10,               %INI%, Configuration, MusPauseDelay
    IniWrite, nircmd.exe,       %INI%, Configuration, NircmdFile
    FileAppend, `n,             %INI%
    IniWrite, US&D–EUR,         %INI%, CurrencyPairs, usd:eur
    IniWrite, &EUR–USD,         %INI%, CurrencyPairs, eur:usd|
    FileAppend, `n,             %INI%
    IniWrite, ... &to USD,      %INI%, ToCurrency, usd
    FileAppend, `n,             %INI%
    IniWrite, example@gmail.com,%INI%, SavedValue, Example e-mail value
    Run, menu%EXT%
}

;api keys
Global CURRENCY_KEY
Global WEATHER_KEY
RegRead, CURRENCY_KEY, HKEY_CURRENT_USER\Environment, GETGEOAPI
RegRead, WEATHER_KEY, HKEY_CURRENT_USER\Environment, OPENWEATHERMAP
Global CITY
RegRead, CITY, HKEY_CURRENT_USER\Environment, CITY

;on the fly advertisement controlling variables
Global MUTE := 0
Global SPOTIFY := 0
SpotifyDetectProcessId() ; fill SPOTIFY value

;music control label (auto pause music on long afk; auto mute volume when advertisement)
SetTimer, IdlePause, %MUS_CHECK_DELAY%
If FileExist(NIRCMD_FILE)
{
    SetTimer, SpotifyMute, %MUS_CHECK_DELAY%
}

;set icon
IfExist, menu.ico
{
    Menu, Tray, Icon, menu.ico, , 1
}

Hotkey,   %MAIN_KEY%, PasteMenu
Hotkey,  +%MAIN_KEY%, MessageMenu
Hotkey, ^+%MAIN_KEY%, DisabledToggle


;===============================================================================================
;=========================================Menu billet===========================================
;===============================================================================================

;edit currency sub-sub-sub-menu
            Menu, ManageCurrencies, Add, Add currency pair, AddCurrencyPair
            Menu, ManageCurrencies, Add, Delete currency pair, DeleteCurrencyPair
            Menu, ManageCurrencies, Add, Add currency for auto-detect, AddCurrency
            Menu, ManageCurrencies, Add, Delete currency for auto-detect, DeleteCurrency

For _, name in ["Clip", "Sel", "Inp", "ClipMsg", "SelMsg", "InpMsg"]
{
    normalize_%name%    := Func("@" . name).Bind("Normalize")
    capitalize_%name%   := Func("@" . name).Bind("Capitalized")
    lowercase_%name%    := Func("@" . name).Bind("Lowercase")
    uppercase_%name%    := Func("@" . name).Bind("Uppercase")
    inverted_%name%     := Func("@" . name).Bind("Inverted")
    sentence_%name%     := Func("@" . name).Bind("Sentence")
    en_ru_q_%name%      := Func("@" . name).Bind(Func("LayoutSwitch").Bind("qphyx_en_ru"))
    ru_en_q_%name%      := Func("@" . name).Bind(Func("LayoutSwitch").Bind("qphyx_ru_en"))
    en_ru_l_%name%      := Func("@" . name).Bind(Func("LayoutSwitch").Bind("qwerty_en_ru"))
    ru_en_l_%name%      := Func("@" . name).Bind(Func("LayoutSwitch").Bind("qwerty_ru_en"))
    en_ru_t_%name%      := Func("@" . name).Bind(Func("LayoutSwitch").Bind("translit_en_ru"))
    ru_en_t_%name%      := Func("@" . name).Bind(Func("LayoutSwitch").Bind("translit_ru_en"))
    calc_expr_%name%    := Func("@" . name).Bind("Execute")
    format_time_%name%  := Func("@" . name).Bind("DatetimeFormat")
    Menu, %name%, Add, Nor&malize,  % normalize_%name%
    Menu, %name%, Add, &Sentence,   % sentence_%name%
    Menu, %name%, Add, &Capitalized,% capitalize_%name%
    Menu, %name%, Add, &Lowercase,  % lowercase_%name%
    Menu, %name%, Add, &Uppercase,  % uppercase_%name%
    Menu, %name%, Add, &Inverted,   % inverted_%name%
    Menu, %name%, Add
    Menu, %name%, Add, En-Ru q&phyx switch,     % en_ru_q_%name%
    Menu, %name%, Add, Ru-En &qphyx switch,     % ru_en_q_%name%
    Menu, %name%, Add, &En-Ru qwerty switch,    % en_ru_l_%name%
    Menu, %name%, Add, &Ru-En qwerty switch,    % ru_en_l_%name%
    Menu, %name%, Add, E&n-Ru transliteration,  % en_ru_t_%name%
    Menu, %name%, Add, Ru-En transliterati&on,  % ru_en_t_%name%
    Menu, %name%, Add
    Menu, %name%, Add, C&alculate the expression, % calc_expr_%name%
    Menu, %name%, Add, &Format Time (e.g. "dd/MM" to "26/03"), % format_time_%name%
    ;currency converter submenu
        IniRead, section, %INI%, CurrencyPairs
        For ind, pair in StrSplit(section, "`n")
        {
            values := StrSplit(pair, "=")
            currencies := StrSplit(values[1], ":")
            paste_%name%_cur%ind% := Func("@" . name)
                .Bind(Func("ExchRates").Bind(currencies[1], SubStr(currencies[2], 1, 3), 0))
            Menu, Conv%name%, Add, % values[2], % paste_%name%_cur%ind%
            If (SubStr(currencies[2], 4, 1) == "|")
            {
                Menu, Conv%name%, Add
            }
        }
        Menu, Conv%name%, Add
        IniRead, section, %INI%, ToCurrency
        For ind, pair in StrSplit(section, "`n")
        {
            values := StrSplit(pair, "=")
            unk_to_%values1% := Func("@" . name).Bind(Func("UnknownCurrency").Bind(values[1]))
            Menu, Conv%name%, Add, % values[2], % unk_to_%values1%
        }
        Menu, Conv%name%, Add
        Menu, Conv%name%, Add, &Manage currencies, :ManageCurrencies
    Menu, %name%, Add, Currenc&y converter, :Conv%name%
}

For _, name in ["Clip", "ClipMsg"]
{
    ;time submenu
    time_%name%     := Func("@" . name).Bind(Func("Datetime").Bind("hh:mm:ss tt"))
    date_%name%     := Func("@" . name).Bind(Func("Datetime").Bind("MMMM dd"))
    datetime_%name% := Func("@" . name).Bind(Func("Datetime")
        .Bind("dddd, MMMM dd yyyy hh:mm:ss tt"))
    new_time_%name% := Func("@" . name).Bind("DecimalTime")
    new_date_%name% := Func("@" . name).Bind("HexalDate")
    new_dt_%name%   := Func("@" . name).Bind("NewDatetime")
    Menu, Datetime%name%, Add, &Time,           % time_%name%
    Menu, Datetime%name%, Add, &Date,           % date_%name%
    Menu, Datetime%name%, Add, DateTi&me,       % datetime_%name%
    Menu, Datetime%name%, Add, De&cimal time,   % new_time_%name%
    Menu, Datetime%name%, Add, &Hexal date,     % new_date_%name%
    Menu, Datetime%name%, Add, &New datetime,   % new_dt_%name%

    ;exchange rates submenu
    IniRead, section, %INI%, CurrencyPairs
    For ind, pair in StrSplit(section, "`n")
    {
        values := StrSplit(pair, "=")
        currencies := StrSplit(values[1], ":")
        paste_rates_cur%ind% := Func("@" . name)
            .Bind(Func("ExchRates").Bind(currencies[1], SubStr(currencies[2], 1, 3)))
        Menu, Rates%name%, Add, % values[2], % paste_rates_cur%ind%
        If (SubStr(currencies[2], 4, 1) == "|")
        {
            Menu, Rates%name%, Add
        }
    }
    Menu, Rates%name%, Add
    Menu, Rates%name%, Add, &Manage currencies, :ManageCurrencies

    weather_%name% := Func("@" . name).Bind(Func("Weather").Bind(CITY))
}


;===============================================================================================
;============================================Paste menu=========================================
;===============================================================================================

Menu, Paste, Add, Paste menu, Pass
Menu, Paste, ToggleEnable, Paste menu
Menu, Paste, Icon, Paste menu, %A_AhkPath%, -207

Menu, Paste, Add, &Clipboard text transform, :Clip
Menu, Paste, Add, &Selected text transform, :Sel
Menu, Paste, Add, &Input text to transform, :Inp
Menu, Paste, Add

;"predefined values paste" submenu
IniRead, section, %INI%, SavedValue
For ind, pair in StrSplit(section, "`n")
{
    values := StrSplit(pair, "=")
    saved_value%ind% := Func("SendValue").Bind(values[2])
    Menu, Values, Add, % values[1], % saved_value%ind%
}
    Menu, Values, Add
    Menu, Values, Add, Add new value, AddSavedValue
    Menu, Values, Add, Delete existing value, DeleteSavedValue
Menu, Paste, Add, Saved &values, :Values

;emoji submenu
    Menu, Emoji, Add, ¯\_(ツ)_/¯ &Shrug, Emoji
    Menu, Emoji, Add, ( ͡° ͜ʖ ͡°) &Lenny, Emoji
    Menu, Emoji, Add, ಠoಠ &Dude, Emoji
    Menu, Emoji, Add, ლ(・﹏・ლ) &Why, Emoji
    Menu, Emoji, Add, (ง'̀-'́)ง &Fight, Emoji
    Menu, Emoji, Add, ༼ つ ◕_◕ ༽つ &Take My Energy, Emoji
    Menu, Emoji, Add, (╯°□°)╯︵ ┻━┻ &Rage, Emoji
    Menu, Emoji, Add, ┬─┬ノ( º _ ºノ) &Putting Table Back, Emoji
    Menu, Emoji, Add, (；一_一) &Ashamed, Emoji
    Menu, Emoji, Add, （＾～＾） &Meh, Emoji
    Menu, Emoji, Add, ʕ •ᴥ•ʔ &Koala, Emoji
    Menu, Emoji, Add, (◐‿◑) &Crazy, Emoji
    Menu, Emoji, Add, (っ⌒‿⌒)っ &Hug, Emoji
    Menu, Emoji, Add, (☉__☉”) &Yikes, Emoji
    Menu, Emoji, Add, (ﾉﾟ0ﾟ)ﾉ~ w&Ow, Emoji
    Menu, Emoji, Add, ༼ ༎ຶ ෴ ༎ຶ༽ &Upset, Emoji
Menu, Paste, Add, &Emoji, :Emoji

Menu, Paste, Add, &Datetime, :DatetimeClip
Menu, Paste, Add, E&xchange rate, :RatesClip
Menu, Paste, Add, Current &weather, % weather_Clip


;===============================================================================================
;============================================Message menu=======================================
;===============================================================================================

Menu, Func, Add, Message menu, Pass
Menu, Func, ToggleEnable, Message menu
Menu, Func, Icon, Message menu, %A_AhkPath%, -207

Menu, Func, Add, &Clipboard text transform, :ClipMsg
Menu, Func, Add, &Selected text transform, :SelMsg
Menu, Func, Add, &Input text to transform, :InpMsg
Menu, Func, Add

Menu, Func, Add, &Datetime, :DatetimeClipMsg
Menu, Func, Add, E&xchange rate, :RatesClipMsg

;other
Menu, Func, Add, Current &weather, % weather_ClipMsg

Menu, Func, Add, &Reminder, Reminder

compare_msg := Func("Compare")
Menu, Func, Add, C&ompare selected with clipboard, % compare_msg

Menu, Func, Add, &Auto-stop music on AFK delay (now is %MUS_PAUSE_DELAY%m), MusTimer


;===============================================================================================
;=============================================Tray menu=========================================
;===============================================================================================

Menu, Tray, Add, Tray Menu, TrayMenu
Menu, Tray, Default, Tray Menu
Menu, Tray, Click, 1
Menu, Tray, Disable, Tray Menu
Menu, Tray, Tip, menu%EXT% – enabled
Menu, Tray, NoStandard

Menu, Tray, Add, &Clipboard text transform, :ClipMsg
Menu, Tray, Add, &Selected text transform, :SelMsg
Menu, Tray, Add, &Input text to transform, :InpMsg
Menu, Tray, Add
Menu, Tray, Add, &Datetime, :DatetimeClipMsg
Menu, Tray, Add, E&xchange rate, :RatesClipMsg
Menu, Tray, Add, Current &weather, % weather_ClipMsg
Menu, Tray, Add, &Reminder, Reminder
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Settings, Pass
Menu, Tray, ToggleEnable, Settings
Menu, Tray, Icon, Settings, %A_AhkPath%, -206
Menu, Tray, Add, &Auto-stop music on AFK delay (now is %MUS_PAUSE_DELAY%m), MusTimer
Menu, Tray, Add, Disa&ble menu (ctrl+sh+leader to toggle), DisabledToggle
Menu, Tray, Add, &Exit, Exit


;===============================================================================================
;===========================================Decorators==========================================
;===============================================================================================

@Clip(func, params*)
{
    result := %func%(params)
    SendInput, {Raw}%result%
}

@Sel(func, params*)
{
    saved_value := Clipboard
    Clipboard := ""
    SendInput, ^{SC02E}
    Sleep, 33
    result := %func%(params)
    SendInput, {Raw}%result%
    Sleep, 33
    Clipboard := saved_value
}

@Inp(func, params*)
{
    InputBox, user_input, %func%, Input for %func% function, , 300, 150
    If !ErrorLevel
    {
        saved_value := Clipboard
        Sleep, 33
        Clipboard := user_input
        Sleep, 33
        result := %func%(params)
        SendInput, {Raw}%result%
        Sleep, 33
        Clipboard := saved_value
    }
}

@ClipMsg(func, params*)
{
    result := %func%(params)
    MsgBox, 260, %func%, %result% `nSave result to clipboard?
    IfMsgBox Yes
    {
        Clipboard := result
    }
}

@SelMsg(func, params*)
{
    saved_value := Clipboard
    Clipboard := ""
    SendInput, ^{SC02E}
    Sleep, 33
    Clipboard := Trim(Clipboard)
    result := %func%(params)
    Sleep, 33
    MsgBox, 260, %func%, %result% `nSave result to clipboard?
    IfMsgBox Yes
    {
        Clipboard := result
    }
    Else
    {
        Clipboard := saved_value
    }
}

@InpMsg(func, params*)
{
    InputBox, user_input, %func%, Input for %func% function, , 300, 150
    If !ErrorLevel
    {
        saved_value := Clipboard
        Sleep, 33
        Clipboard := user_input
        Sleep, 33
        result := %func%(params)
        Sleep, 33
        MsgBox, 260, %func%, %result% `nSave result to clipboard?
        IfMsgBox Yes
        {
            Clipboard := result
        }
        Else
        {
            Clipboard := saved_value
        }
    }
}


;===============================================================================================
;===========================================Tool functions======================================
;===============================================================================================

SendValue(value)
{
    SendInput, %value%
}

;detect current spotify process
SpotifyDetectProcessId()
{
    WinGet, id, list, , , Program Manager
    Loop, %id%
    {
        this_id := id%A_Index%
        WinGet, proc, ProcessName, ahk_id %this_id%
        WinGetTitle, title, ahk_id %this_id%
        If (title && proc == "Spotify.exe")
        {
            SPOTIFY := this_id
            Break
        }
    }
    If !SPOTIFY
    {
        SetTimer, SpotifyDetectProcessId, -66666
    }
}

;compare selected with clipboard value
Compare()
{
    saved_value := Clipboard
    SendInput, ^{SC02E}
    Sleep, 33
    result := (Clipboard == saved_value) ? "Identical" : "Not identical"
    Sleep, 33
    Clipboard := saved_value
    Msgbox, , Message, %result%
}

;calculate expression
Execute() ; https://www.autohotkey.com/boards/viewtopic.php?p=221460#p221460
{
    expr := Clipboard
    expr := StrReplace(RegExReplace(expr, "\s") , ",", ".")
    expr := RegExReplace(StrReplace(expr, "**", "^")
            , "(\w+(\.*\d+)?)\^(\w+(\.*\d+)?)", "pow($1,$3)")
    expr := RegExReplace(expr, "=+", "==")
    expr := RegExReplace(expr, "\b(E|LN2|LN10|LOG2E|LOG10E|PI|SQRT1_2|SQRT2)\b", "Math.$1")
    expr := RegExReplace(expr, "\b(abs|acos|asin|atan|atan2|ceil|cos|exp"
            . "|floor|log|max|min|pow|random|round|sin|sqrt|tan)\b\(", "Math.$1(")
    (o := ComObjCreate("HTMLfile")).write("<body><script>document"
            . ".body.innerText=eval('" . expr . "');</script>")
    o := StrReplace(StrReplace(StrReplace(InStr(o:=o.body.innerText, "body") ? "" : o
            , "false", 0), "true", 1), "undefined", "")
    Return o ;InStr(o, "e") ? Format("{:f}", o) : o
}

Emoji(item_name)
{
    SendInput, % RegExReplace(item_name, "i)[ a-z0-9&]*$")
}

Reminder()
{
    InputBox, user_input, Reminder, Remind me in ... minutes, , 200, 130
    If !ErrorLevel
    {
        If user_input is number
        {
            delay := user_input * 60000
            SetTimer, Alarma, %delay%
        }
        Else
        {
            MsgBox, 53, Incorrect value, The input must be a number!
            IfMsgBox Retry
            {
                Reminder()
            }
        }
    }
}

Alarma()
{
    MsgBox, 48, ALARMA, ALARMA
    SetTimer, Alarma, Off
}


;===============================================================================================
;===========================================INI edit============================================
;===============================================================================================

MusTimer()
{
    InputBox, user_input, Set new auto-stop music on AFK delay
        , New value in minutes (e.g. 10), , 444, 130
    If !ErrorLevel
    {
        If user_input is number
        {
            old_value = %MUS_PAUSE_DELAY%
            IniWrite, %user_input%, %INI%, Configuration, MusPauseDelay
            MUS_PAUSE_DELAY := user_input
            Menu, Func, Rename, &Auto-stop music on AFK delay (now is %old_value%m)
                , &Auto-stop music on AFK delay (now is %MUS_PAUSE_DELAY%m)
            Menu, Tray, Rename, &Auto-stop music on AFK delay (now is %old_value%m)
                , &Auto-stop music on AFK delay (now is %MUS_PAUSE_DELAY%m)
        }
        Else
        {
            MsgBox, 53, Incorrect value, The input must be a number!
            IfMsgBox Retry
            {
                MusTimer()
            }
        }
    }
}

AddSavedValue()
{
    message =
    (
        Enter name for new value (with "&&" for hotkey)
Take into account that "test", "&&test" and "tes&&t" are three different values!
If you enter existing value name it will be overwritten without warning!
    )
    InputBox, user_input, New value name, %message%, , 470, 160
    If !ErrorLevel
    {
        InputBox, user_input_2, Value for %user_input%
            , Enter value for %user_input%`nAll values stored solely in "config.ini", , 444, 160
        If !ErrorLevel
        {
            IniWrite, %user_input_2%, %INI%, SavedValue, %user_input%
            MsgBox, Success!
            Run, menu%EXT%
        }
    }
}

DeleteSavedValue()
{
    InputBox, user_input, Enter deleting value name
        , Enter deleting value name (with "&&" if there is), , 470, 140
    If !ErrorLevel
    {
        If !user_input
        {
            MsgBox, 53, , Input must be not empty!
            IfMsgBox Retry
            {
                DeleteSavedValue()
            }
        }
        Else
        {
            IniDelete, %INI%, SavedValue, %user_input%
            If !ErrorLevel
            {
                MsgBox, Success (or not ¯\_(ツ)_/¯)
                Run, menu%EXT%
            }
            Else
            {
                MsgBox, 53, Incorrect value
                IfMsgBox Retry
                {
                    DeleteSavedValue()
                }
            }
        }
    }
}

AddCurrencyPair()
{
    message =
    (
        Enter currency code pair through the ":"
ISO 4217 format. E.g. USD:EUR
Add "|" with the last symbol for adittional seperator to menu after this option.
If you enter existing pair (in the same sequence) it will be overwritten without warning!
    )
    InputBox, user_input, Enter currency pair, %message%, , 530, 190
    If !ErrorLevel
    {
        If (!user_input || !(RegExMatch(user_input, "i)^[a-z]{3}:[a-z]{3}\|?$")))
        {
            MsgBox, 53, , Incorrect input!
            IfMsgBox Retry
            {
                AddCurrencyPair()
            }
        }
        Else
        {
            Loop
            {
                InputBox, user_input_2, Option text
                    , Enter text for menu option (with "&&" for hotkey), , 444, 160
                If ErrorLevel
                {
                    MsgBox, 53, , Incorrect input!
                    IfMsgBox Retry
                    {
                    }
                    Else
                    {
                        Break
                    }
                }
                Else
                {
                    StringLower, user_input, user_input
                    IniWrite, %user_input_2%, %INI%, CurrencyPairs, %user_input%
                    MsgBox, Success!
                    Run, menu%EXT%
                }
            }
        }
    }
}

DeleteCurrencyPair()
{
    message =
    (
        Enter currency code pair through the ":"
If you set additional separator with "|" it also must be entered here
    )
    InputBox, user_input, Enter currency pair, %message%, , 470, 160
    If !ErrorLevel
    {
        If (!user_input || !(RegExMatch(user_input, "i)^[a-z]{3}:[a-z]{3}\|?$")))
        {
            MsgBox, 53, , Incorrect input!
            IfMsgBox Retry
            {
                DeleteCurrencyPair()
            }
        }
        Else
        {
            StringLower, user_input, user_input
            IniDelete, %INI%, CurrencyPairs, %user_input%
            If !ErrorLevel
            {
                MsgBox, Success (or not ¯\_(ツ)_/¯)
                Run, menu%EXT%
            }
            Else
            {
                MsgBox, 53, Incorrect value
                IfMsgBox Retry
                {
                    DeleteCurrencyPair()
                }
            }
        }
    }
}

AddCurrency()
{
    message =
    (
        Enter currency code in ISO 4217 format. E.g. "USD" or "EUR"
If you enter existing value it will be overwritten without warning!
    )
    InputBox, user_input, Enter currency, %message%, , 530, 190
    If !ErrorLevel
    {
        If (!user_input || !(RegExMatch(user_input, "i)^[a-z]{3}$")))
        {
            MsgBox, 53, , Incorrect input!
            IfMsgBox Retry
            {
                AddCurrency()
            }
        }
        Else
        {
            Loop
            {
                InputBox, user_input_2, Option text
                    , Enter text for menu option (with "&&" for hotkey), , 444, 160
                If ErrorLevel
                {
                    MsgBox, 53, , Incorrect input!
                    IfMsgBox Retry
                    {
                    }
                    Else
                    {
                        Break
                    }
                }
                Else
                {
                    StringLower, user_input, user_input
                    IniWrite, %user_input_2%, %INI%, ToCurrency, %user_input%
                    MsgBox, Success!
                    Run, menu%EXT%
                }
            }
        }
    }
}

DeleteCurrency()
{
    InputBox, user_input, Enter currency code, Enter currency code, , 470, 160
    If !ErrorLevel
    {
        If (!user_input || !(RegExMatch(user_input, "i)^[a-z]{3}$")))
        {
            MsgBox, 53, , Incorrect input!
            IfMsgBox Retry
            {
                DeleteCurrency()
            }
        }
        Else
        {
            StringLower, user_input, user_input
            IniDelete, %INI%, ToCurrency, %user_input%
            If !ErrorLevel
            {
                MsgBox, Success (or not ¯\_(ツ)_/¯)
                Run, menu%EXT%
            }
            Else
            {
                MsgBox, 53, Incorrect value
                IfMsgBox Retry
                {
                    DeleteCurrency()
                }
            }
        }
    }
}


;===============================================================================================
;======================================Third-API functions======================================
;===============================================================================================

Weather(q_city)
{
    If !WEATHER_KEY
    {
        Return "Not found api key in environment variables (search 'OPENWEATHERMAP')"
    }
    web_request := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    web_request.Open("GET", "https://api.openweathermap.org/data/2.5/weather?q=" q_city
        . "&appid=" WEATHER_KEY "&units=metric")
    web_request.Send()
    stat := RegExReplace(web_request.ResponseText, ".+""main"":""(\w+)"".+", "$u1")
    StringUpper stat, stat, T
    temp := RegExReplace(web_request.ResponseText, ".+""temp"":(-?\d+.\d+).+", "$u1")
    feel := RegExReplace(web_request.ResponseText, ".+""feels_like"":(-?\d+.\d+).+", "$u1")
    wind := RegExReplace(web_request.ResponseText, ".+""speed"":(\d+.\d+).+", "$u1")
    Return stat . "`n" . temp . "° (" . feel . "°)`n" . wind . "m/s"
}

ExchRates(base, symbol, amount:=1)
{
    If !CURRENCY_KEY
    {
        Return "Not found api key in environment variables (search 'GETGEOAPI')"
    }
    If !amount
    {
        amount := RegExReplace(RegExReplace(Clipboard, "[^\d+\.,]"), ",", ".")
    }
    web_request := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    web_request.Open("GET", "https://api.getgeoapi.com/api/v2/currency/convert?api_key="
        . CURRENCY_KEY . "&from=" . base . "&to=" . symbol . "&amount=" . amount . "&format=json")
    web_request.Send()
    Return Round(RegExReplace(web_request.ResponseText
        , ".+""rate_for_amount"":""(\d+\.\d+)"".+", "$u1"), 2)
}

UnknownCurrency(base)
{
    If !CURRENCY_KEY
    {
        Return "Not found api key in environment variables (search 'GETGEOAPI')"
    }
    currencies := []
    IniRead, section, currencies.ini, currencies
    For ind, pair in StrSplit(section, "`n")
    {
        values := StrSplit(pair, "=")
        currencies.Push([StrSplit(values[2], ","), values[1]])
    }

    RegExMatch(Clipboard, "(\d+(\.\d+){0,1})", amount)
    If amount1
    {
        For ind, elem in currencies
        {
            For _, var in elem[1]
            {
                If InStr(Clipboard, var)
                {
                    web_request := ComObjCreate("WinHttp.WinHttpRequest.5.1")
                    web_request.Open("GET"
                        , "https://api.getgeoapi.com/api/v2/currency/convert?api_key="
                        . CURRENCY_KEY . "&from=" . elem[1][1] . "&to=" . base . "&amount="
                        . amount1 . "&format=json")
                    web_request.Send()
                    result := amount1 . " " . elem[2] . " to " . base . ": "
                        . Round(RegExReplace(web_request.ResponseText
                            , ".+""rate_for_amount"":""(\d+\.\d+)"".+", "$u1"), 2)
                    Break 2
                }
            }
        }
    }
    Else
    {
        result := "Incorrect value"
    }
    Return result
}


;===============================================================================================
;===========================================Datetime functions==================================
;===============================================================================================

Datetime(format)
{
    FormatTime, time_string, %A_Now%, %format%
    Return time_string
}

DatetimeFormat()
{
    Clipboard := StrReplace(StrReplace(StrReplace(Clipboard, "д", "d"), "м", "m"), "М", "M")
    Clipboard := StrReplace(StrReplace(StrReplace(Clipboard, "г", "y"), "э", "gg"), "ч", "h")
    Clipboard := StrReplace(StrReplace(StrReplace(Clipboard, "Ч", "H"), "с", "S"), "п", "t")
    FormatTime, time_string, %A_Now%, %Clipboard%
    Return time_string
}


;; concept briefly:
; 10 hours in a day (0-9), 100 minutes in a hour (00-99), 100 seconds in a minute (00-99).
; Second was accelerated by 100_000/86_400≈1.1574
DecimalTime()
{
    ms := (((A_Hour * 60 + A_Min) * 60 + A_Sec) * 1000 + A_MSec) * 1.1574
    hours := Round(ms // 10000000)
    minutes := Round((ms - hours * 10000000) // 100000)
    seconds := Round((ms - hours * 10000000 - minutes * 100000) // 1000)
    Return hours . ":" . minutes . ":" . seconds
}

; 10 months in a year (0-9), 6 weeks in a month (0-5), 6 days in a week (0-5).
; The last 5(6 if leap year) days of the year is a holiday week.
; New Year on the Winter solstice (dec 21-22, old style).
HexalDate()
{
    leap_mark := (!Mod(A_YYYY, 400) || !Mod(A_YYYY, 4) && Mod(A_YYYY, 100)) ? 1 : 0
    If (A_YDay > 355+leap_mark)
    {
        year := A_YYYY + 1
        day := A_YDay - 356 - leap_mark
    }
    Else If (A_YDay > 350)
    {
        day := A_YDay - 351
        Return A_YYYY . "–" . A_YYYY + 1 . " holidays, " . day . "/" . 4 + leap_mark
    }
    Else
    {
        year := A_YYYY
        day := A_YDay + 9
    }

    dd := Mod(day, 6)
    ww := Mod(day, 36) // 6
    mm := day // 36
    Return mm . ww . dd . ". " . year
}

NewDatetime()
{
    Return DecimalTime() . " | " . HexalDate()
}


;===============================================================================================
;===========================================Text transform======================================
;===============================================================================================

; Sample: gO or STaY  ?nOw i goTTa ChoOse, AND i’Ll aCCePt yoUR iNviTATioN to THe blUeS

Normalize()
{
    ; Go or stay? Now I gotta choose, and I’ll accept your invitation to the blues
    StringLower, result, Clipboard
    Return Trim(RegExReplace(RegExReplace(Trim(RegExReplace(result, "[ \t]+", " "))
        , " ?([.,!?;]+) ?", "$1 ")
        , "(((^|^[–—] |[.!?] )[a-zа-яё])| i['’ ])", "$u1"))
}

Sentence()
{
    ; Go or stay  ?now I gotta choose, and I’ll accept your invitation to the blues
    StringLower, result, Clipboard
    Return RegExReplace(result, "(((^\s*—?–?\s*|([.!?]\s+))[a-zа-яё])|[ \t]i['’ \t])", "$u1")
}

Capitalized()
{
    ; Go Or Stay  ?Now I Gotta Choose, And I’ll Accept Your Invitation To The Blues
    StringUpper result, Clipboard, T
    Return result
}

Lowercase()
{
    ; go or stay  ?now i gotta choose, and i’ll accept your invitation to the blues
    StringLower result, Clipboard
    Return result
}

Uppercase()
{
    ; GO OR STAY  ?NOW I GOTTA CHOOSE, AND I’LL ACCEPT YOUR INVITATION TO THE BLUES
    StringUpper result, Clipboard
    Return result
}

Inverted()
{
    ; Go OR stAy  ?NoW I GOttA cHOoSE, and I’lL AccEpT YOur InVItatIOn TO thE BLuEs
    result := RegExReplace(Clipboard, "([a-zа-яё])|([A-ZА-ЯЁ])", "$U1$L2")
    Return result
}

LayoutSwitch(dict)
{
    qphyx_en_ru := { 113:[1102],112:[1087],104:[1093],121:[1099],120:[1103],122:[1079],119:[1096]
        , 108:[1083],100:[1076],118:[1074],101:[1077],097:[1072],111:[1086],105:[1080],117:[1091]
        , 109:[1084],115:[1089],116:[1090],114:[1088],110:[1085],099:[1094],106:[1081],103:[1075]
        , 107:[1082],102:[1092],098:[1073],081:[1070],080:[1055],072:[1061],089:[1067],088:[1071]
        , 090:[1047],087:[1064],076:[1051],068:[1044],086:[1042],069:[1045],065:[1040],079:[1054]
        , 073:[1048],085:[1059],077:[1052],083:[1057],084:[1058],082:[1056],078:[1053],067:[1062]
        , 074:[1049],071:[1043],075:[1050],070:[1060],066:[1041]}
    qphyx_ru_en := { 1102:[113],1087:[112],1093:[104],1099:[121],1103:[120],1079:[122],1096:[119]
        , 1083:[108],1076:[100],1074:[118],1078:[],   1098:[],   1077:[101],1072:[097],1086:[111]
        , 1080:[105],1091:[117],1084:[109],1089:[115],1090:[116],1088:[114],1085:[110],1094:[099]
        , 1081:[106],1101:[],   1105:[],   1075:[103],1100:[],   1082:[107],1092:[102],1095:[]
        , 1097:[],   1073:[098],1070:[081],1055:[080],1061:[072],1067:[089],1071:[088],1047:[090]
        , 1064:[087],1051:[076],1044:[068],1042:[086],1046:[],   1068:[],   1045:[069],1040:[065]
        , 1054:[079],1048:[073],1059:[085],1052:[077],1057:[083],1058:[084],1056:[082],1053:[078]
        , 1062:[067],1049:[074],1069:[],   1025:[],   1043:[071],1066:[],   1050:[075],1060:[070]
        , 1063:[],   1065:[],   1041:[066]}
    qwerty_en_ru := {113:[1081],119:[1094],101:[1091],114:[1082],116:[1077],121:[1085],117:[1075]
        , 105:[1096],111:[1097],112:[1079],091:[1093],093:[1098],097:[1092],115:[1099],100:[1074]
        , 102:[1072],103:[1087],104:[1088],106:[1086],107:[1083],108:[1076],059:[1078],039:[1101]
        , 122:[1103],120:[1095],099:[1089],118:[1084],098:[1080],110:[1090],109:[1100],044:[1073]
        , 046:[1102],047:[0046],096:[1105],081:[1049],087:[1062],069:[1059],082:[1050],084:[1045]
        , 089:[1053],085:[1043],073:[1064],079:[1065],080:[1047],123:[1061],125:[1068],065:[1060]
        , 083:[1067],068:[1042],070:[1040],071:[1055],072:[1056],074:[1054],075:[1051],076:[1044]
        , 058:[1046],034:[1069],090:[1071],088:[1063],067:[1057],086:[1052],066:[1048],078:[1058]
        , 077:[1066],060:[1041],062:[1070],063:[0044],126:[1025],064:[0034],035:[8470],036:[0059]
        , 094:[0058],038:[0063]}
    qwerty_ru_en := {1081:[113],1094:[119],1091:[101],1082:[114],1077:[116],1085:[121],1075:[117]
        , 1096:[105],1097:[111],1079:[112],1093:[091],1098:[093],1092:[097],1099:[115],1074:[100]
        , 1072:[102],1087:[103],1088:[104],1086:[106],1083:[107],1076:[108],1078:[059],1101:[039]
        , 1103:[122],1095:[120],1089:[099],1084:[118],1080:[098],1090:[110],1100:[109],1073:[044]
        , 1102:[046],0046:[047],1105:[096],1049:[081],1062:[087],1059:[069],1050:[082],1045:[084]
        , 1053:[089],1043:[085],1064:[073],1065:[079],1047:[080],1061:[123],1068:[125],1060:[065]
        , 1067:[083],1042:[068],1040:[070],1055:[071],1056:[072],1054:[074],1051:[075],1044:[076]
        , 1046:[058],1069:[034],1071:[090],1063:[088],1057:[067],1052:[086],1048:[066],1058:[078]
        , 1066:[077],1041:[060],1070:[062],0044:[063],1025:[126],0034:[064],8470:[035],0059:[036]
        , 0058:[094],0063:[038]}
    translit_en_ru := {065:[1040],066:[1041],067:[1062],068:[1044],069:[1045],070:[1060]
        , 071:[1043],072:[1061],073:[1048],074:[1046],075:[1050],076:[1051],077:[1052]
        , 078:[1053],079:[1054],080:[1055],081:[1050],082:[1056],083:[1057],084:[1058]
        , 085:[1059],086:[1042],087:[1042],089:[1049],090:[1047],097:[1072],098:[1073]
        , 099:[1094],100:[1076],101:[1077],102:[1092],103:[1075],104:[1093],105:[1080]
        , 106:[1078],107:[1082],108:[1083],109:[1084],110:[1085],111:[1086],112:[1087]
        , 113:[1082],114:[1088],115:[1089],116:[1090],117:[1091],118:[1074],119:[1074]
        , 121:[1081],122:[1079],088:[1050,1057],120:[1082,1089]}
    translit_ru_en := {1040:[65],1041:[66],1042:[86],1043:[71],1044:[68],1045:[69],1046:[90,72]
        , 1047:[90],1048:[73],1049:[89],1050:[75],1051:[76],1052:[77],1053:[78],1054:[79]
        , 1055:[80],1056:[82],1057:[83],1058:[84],1059:[85],1060:[70],1061:[75,72],1062:[84,83]
        , 1063:[67,72],1064:[83,72],1065:[83,72,67,72],1066:[],1067:[89],1068:[],1069:[69]
        , 1070:[89,85],1071:[89,65],1025:[89,79],1072:[97],1073:[98],1074:[118],1075:[103]
        , 1076:[100],1077:[101],1078:[122,104],1079:[122],1080:[105],1081:[121],1082:[107]
        , 1083:[108],1084:[109],1085:[110],1086:[111],1087:[112],1088:[114],1089:[115],1090:[116]
        , 1091:[117],1092:[102],1093:[107,104],1094:[116,115],1095:[99,104],1096:[115,104]
        , 1097:[115,104,99,104],1098:[],1099:[121],1100:[],1101:[101],1102:[121,117]
        , 1103:[121,97],1105:[121,111]}
    result := ""
    Loop % StrLen(Clipboard)
    {
        cur_char := Asc(SubStr(Clipboard, A_Index, 1))
        If %dict%.haskey(cur_char)
        {
            For ind, elem in %dict%[cur_char]
            {
                result := result . Chr(elem)
            }
        }
        Else
        {
            result := result . Chr(cur_char)
        }
    }
    Return result
}


;===============================================================================================
;===========================================Other===============================================
;===============================================================================================

Pass:
    Return

Exit:
    ExitApp

IdlePause:
    IfGreater, A_TimeIdle, % MUS_PAUSE_DELAY * 60000, SendInput, {SC124}
    Return

SpotifyMute:
    If SPOTIFY
    {
        WinGetTitle, title, ahk_id %SPOTIFY%
        If ((title == "Advertisement") ^ !MUTE)
        {
            MUTE := !MUTE
            Run, %NIRCMD_FILE% setappvolume Spotify.exe %MUTE%
        }
    }
    Return


DisabledToggle:
    DISABLED := !DISABLED
    If DISABLED
    {
        IfExist, disabled.ico
        {
            Menu, Tray, Icon, disabled.ico, , 1
        }
        Menu, Tray, Tip, menu%EXT% – disabled
        Menu, Tray, Rename, Disa&ble menu (ctrl+sh+leader to toggle)
            , Ena&ble menu (ctrl+sh+leader to toggle)
    }
    Else
    {
        IfExist, menu.ico
        {
            Menu, Tray, Icon, menu.ico, , 1
        }
        Menu, Tray, Tip, menu%EXT% – enabled
        Menu, Tray, Rename, Ena&ble menu (ctrl+sh+leader to toggle)
            , Disa&ble menu (ctrl+sh+leader to toggle)
    }
    Return

PasteMenu:
    If DISABLED
    {
        SendInput, {%MAIN_KEY%}
    }
    Else
    {
        Menu, Paste, Show, %A_CaretX%, %A_CaretY%
    }
    Return

MessageMenu:
    If DISABLED
    {
        SendInput, +{%MAIN_KEY%}
    }
    Else
    {
        Menu, Func, Show, %A_CaretX%, %A_CaretY%
    }
    Return

TrayMenu:
    Menu, Tray, Show
