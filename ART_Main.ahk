
#Include AHKv2_Screenshotter_Quickstart.ahk

helpStr := "
(
Ctrl + Shift + F1   - Показать сочетания клавиш (Это окно)
Alt  + Shift + F1   - Показать настройки
Ctrl + Shift + Num+ - //<+ $изм$
Ctrl + Shift + Num* - //<* $изм$
Ctrl + Shift + Num- - //<- $изм$
Ctrl + Shift + N    -  ЕСТЬ NULL
Alt  + Shift + N    - ЕстьNULL(, )
Ctrl + Shift + ,    - Вставляет <
Ctrl + Shift + .    - Вставляет >
Ctrl + Shift + [    - Вставляет [
Ctrl + Shift + ]    - Вставляет ]
Ctrl + Shift + '    - Вставляет '
Ctrl + Shift + 2    - Вставляет @
Ctrl + Shift + 3    - Вставляет #
Ctrl + Shift + 7    - Вставляет &
Ctrl + Shift + \    - Вставляет |
Ctrl + Shift + T    - Запускает основной скрипт (mainScriptPath)
Win  + s            - Сохранить скрин экрана
Win  + a            - Сохранить скрин активного окна
Win  + c            - Сохранить скрин канваса активного окна
Win  + Ctrl + a     - Сохранить скрин активного окна (рендер)
Win  + Ctrl + c     - Сохранить скрин канваса активного окна (рендер)
Win  + n            - Ввести и сохранить заметку
Win  + o            - Открыть папку с заметками
)"

^+F1:: MsgBox(helpStr)
!+F1:: {
	varsText := "
	(
folderPathScreenshots = '.folderPathScreenshots.'
userName := '.userName.'
mainScriptPath := '.mainScriptPath.'
	)"
	varsText := StrReplace(varsText, ".folderPathScreenshots.", folderPathScreenshots)
	varsText := StrReplace(varsText, ".userName.", userName)
	varsText := StrReplace(varsText, ".mainScriptPath.", mainScriptPath)
	MsgBox(varsText)
}
#o:: {
    try {
        run("explorer " folderPathScreenshots)
    } catch Error as e {
        MsgBox "Ошибка открытия: " e.Message, "Ошибка", "Iconx"
    }
}
#n:: {
    ; Показываем диалог ввода
    try {
        ;userInput := InputBox("Введите текст для сохранения:", "Сохранение текста", "w400 h300")
        userInput := InputBox("Введите текст для сохранения:", "Сохранение текста")
        
        if (userInput.Result = "OK" && userInput.Value != "") {
            SaveTextToFile(userInput.Value)
        } else if (userInput.Result = "OK") {
            MsgBox "Текст не может быть пустым!", "Ошибка", "Iconx"
        }
    } catch Error as e {
        MsgBox "Ошибка: " e.Message, "Ошибка", "Iconx"
    }
}

SaveTextToFile(text) {
    ;SaveDir := "C:\TextNotes\"
	SaveDir := folderPathScreenshots
    
    if !DirExist(SaveDir)
        DirCreate(SaveDir)
    
    CurrentDateTime := FormatTime(, "yyyy-MM-dd_HH-mm-ss")
    FilePath := SaveDir . "note_" . CurrentDateTime . ".txt"
    
    try {
        FileAppend(text, FilePath, "UTF-8")
        ;MsgBox "Текст сохранен в:`n" FilePath, "Успех", "Iconi"
    } catch Error as e {
        MsgBox "Ошибка при сохранении: " e.Message, "Ошибка", "Iconx"
    }
}

^+NumpadAdd::
{
	SetKeyDelay 100, 200
	TimeString := FormatTime(, "yyyy`_MM`_dd HH:mm:ss")
	NewString := "
	(
		//<+ $изм$ .userName. .TimeString.

		//+> $изм$ .userName. .TimeString.
	)"
	
	NewString := StrReplace(NewString, ".userName.", userName)
	NewString := StrReplace(NewString, ".TimeString.", TimeString)
	SendText NewString
}
^+NumpadMult::
{
	SetKeyDelay 200, 300
	TimeString := FormatTime(, "yyyy`_MM`_dd HH:mm:ss")
	NewString := "
	(
		//<* $изм$ .userName. .TimeString.
		//

		//*> $изм$ .userName. .TimeString.
	)"
	NewString := StrReplace(NewString, ".userName.", userName)
	NewString := StrReplace(NewString, ".TimeString.", TimeString)
	SendText NewString
}
^+NumpadSub::
{
	SetKeyDelay 50, 100
	TimeString := FormatTime(, "yyyy`_MM`_dd HH:mm:ss")
	NewString := "
	(
		//<- $изм$ .userName. .TimeString.
		//
		//-> $изм$ .userName. .TimeString.
	)"
	NewString := StrReplace(NewString, ".userName.", userName)
	NewString := StrReplace(NewString, ".TimeString.", TimeString)
	SendText NewString
}
^+n::SendText "ЕСТЬ NULL"
!+n::SendText "ЕстьNULL(, )"
^+,::SendText "<"
^+.::SendText ">"
^+VKDB::SendText "["
^+VKDD::SendText "]"
^+VKDE::SendText "'"
^+2::SendText "@"
^+3::SendText "#"
^+7::SendText "&"
^+\::SendText "|"
^+t::Run mainScriptPath

