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


 Var := GetCurrentDesktopNumber()
 Max := GetDesktopCount() - 1
 if (Max == 0){
  MsgBox, hi
  ExitApp
 }
 GoToDesktopNumber(Max)
  Loop, %Max%{
  Send {LWin down}{Ctrl down}{F4}{Ctrl up}{LWin up}
  sleep, 50
  }
ExitApp
