VDA_PATH := A_ScriptDir . "\dependencies\VirtualDesktopAccessor.dll"

hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", VDA_PATH, "Ptr")

GetCurrentDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GetCurrentDesktopNumber", "Ptr")
GetDesktopCountProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GetDesktopCount", "Ptr")
GoToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GoToDesktopNumber", "Ptr")
MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "MoveWindowToDesktopNumber", "Ptr")

GetDesktopCount() {
    global GetDesktopCountProc
    count := DllCall(GetDesktopCountProc, "Int")
    return count
}

GetCurrentDesktopNumber() {
    global GetCurrentDesktopNumberProc
    count := DllCall(GetCurrentDesktopNumberProc, "Int")
    return count
}

GoToDesktopNumber(num) {
    global GoToDesktopNumberProc
    DllCall(GoToDesktopNumberProc, "Int", num, "Int")
    return
}

MoveCurrentWindowToDesktop(desktopNumber) {
  global MoveWindowToDesktopNumberProc, GoToDesktopNumberProc
  WinGet, activeHwnd, ID, A
  DllCall(MoveWindowToDesktopNumberProc, "Ptr", activeHwnd, "Int", desktopNumber, "Int")
}

MoveWindowToDesktop(desktopNumber,  window) {
  global MoveWindowToDesktopNumberProc
  MsgBox, pass through here
  DllCall(MoveWindowToDesktopNumberProc, "Ptr", window, "Int", desktopNumber, "Int")
}

MacosTileView(){
  Var := GetCurrentDesktopNumber()
  if (Var == 0) {
    WinGetTitle, Title, A
    if (Title = "" or Title = "Program Manager") {
      return  ; Exit if no valid window is active
    }
    WinSet, ExStyle, ^0x80, %Title%
    sleep 50
    Send {LWin down}{Ctrl down}{d}{Ctrl up}{LWin up}
    sleep 80
    WinSet, ExStyle, ^0x80, %Title%
    sleep, 50
    WinActivate, %Title%
    sleep, 50
    WinMaximize, %Title%
  } else {
    WinGetTitle, Title, A
    if (Title = "" or Title = "Program Manager") {
      return  ; Exit if no valid window is active
    }
    sleep 50
    MoveCurrentWindowToDesktop(0)
    sleep, 50
    Send {LWin down}{Ctrl down}{F4}{Ctrl up}{LWin up}
    sleep, 50
    GoToDesktopNumber(0)
    sleep, 50
    WinActivate, %Title%
    WinRestore, %Title%
  return
  }
}


; DllCall(RegisterPostMessageHookProc, "Ptr", A_ScriptHwnd, "Int", 0x1400 + 30, "Int")


#!Left::
 Var := GetCurrentDesktopNumber()
  WinGetTitle, Title, A
  if (Title = "" or Title = "Program Manager") {
    return  ; Exit if no valid window is active
  } 
  if (Var <= 1){
    Return
  }
  WinSet, ExStyle, ^0x80, %Title%
  Send {LWin down}{Ctrl down}{Left}{Ctrl up}{LWin up}
  sleep, 50
  MoveCurrentWindowToDesktop(Var)
  sleep, 50
  WinSet, ExStyle, ^0x80, %Title%
  sleep, 50
  WinActivate, %Title%
Return

; Add switching between window spaces instead of simply moving the windows left and right

#!Right::
 Var := GetCurrentDesktopNumber()
 Max := GetDesktopCount() - 1
  WinGetTitle, Title, A
  if (Title = "" or Title = "Program Manager") {
    return  ; Exit if no valid window is active
  }
  if (Var == Max){
    Return
  }
  WinSet, ExStyle, ^0x80, %Title%
  Send {LWin down}{Ctrl down}{Right}{Ctrl up}{LWin up}
  sleep, 50
  MoveCurrentWindowToDesktop(Var)
  sleep, 50
  WinSet, ExStyle, ^0x80, %Title%
  sleep, 50
  WinActivate, %Title%
Return

!+f::
  MacosTileView()
Return

!+q::
  Send, {LAlt down}{F4 down}{LAlt up}{F4 up}
Return

