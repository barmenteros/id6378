//+------------------------------------------------------------------+
//|                                                  WindowsUtils.mqh |
//+------------------------------------------------------------------+
//| Windows API utilities and system functions for Web24hub EA       |
//+------------------------------------------------------------------+
#property strict

//+------------------------------------------------------------------+
//| Windows API Imports                                              |
//+------------------------------------------------------------------+
#import "kernel32.dll"
int GlobalAlloc(int Flags, int Size);
int GlobalLock(int hMem);
int GlobalUnlock(int hMem);
int GlobalFree(int hMem);
int lstrcpyW(int ptrhMem, string Text);
#import "user32.dll"
int SetWindowLongA(int hWnd, int nIndex, int dwNewLong);
int GetWindowLongA(int hWnd, int nIndex);
int SetWindowPos(int hWnd, int hWndInsertAfter, int X, int Y, int cx, int cy, int uFlags);
int GetParent(int hWnd);
int GetTopWindow(int hWnd);
int GetWindow(int hWnd, int wCmd);
int OpenClipboard(int hOwnerWindow);
int EmptyClipboard();
int CloseClipboard();
int SetClipboardData(int Format, int hMem);
#import

//+------------------------------------------------------------------+
//| Windows API Constants                                            |
//+------------------------------------------------------------------+
#define GWL_STYLE         -16
#define WS_CAPTION        0x00C00000
#define WS_BORDER         0x00800000
#define WS_SIZEBOX        0x00040000
#define WS_DLGFRAME       0x00400000
#define SWP_NOSIZE        0x0001
#define SWP_NOMOVE        0x0002
#define SWP_NOZORDER      0x0004
#define SWP_NOACTIVATE    0x0010
#define SWP_FRAMECHANGED  0x0020
#define GW_CHILD          0x0005
#define GW_HWNDNEXT       0x0002
#define GMEM_MOVEABLE   2
#define CF_UNICODETEXT  13

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
int borderhidden = 0;

//+------------------------------------------------------------------+
//| Manage Windows State                                             |
//+------------------------------------------------------------------+
void manageWindows(bool state)
{
    int hChartParent = GetParent((int)ChartGetInteger(ChartID(), CHART_WINDOW_HANDLE));
    int hMDIClient   = GetParent(hChartParent);
    int hChildWindow = GetTopWindow(hMDIClient);
    while(hChildWindow > 0) {
        ManageBorderByWindowHandle(hChildWindow, state);
        hChildWindow = GetWindow(hChildWindow, GW_HWNDNEXT);
        hChildWindow = 0;
    }
    if(state == 1) ChartSetInteger(0, CHART_SCALEFIX, 1);
    if(state == 0) ChartSetInteger(0, CHART_SCALEFIX, 0);
}

//+------------------------------------------------------------------+
//| Manage Border by Window Handle                                  |
//+------------------------------------------------------------------+
void ManageBorderByWindowHandle(int hWindow, bool state)
{
    int iNewStyle;
    if(state) iNewStyle = GetWindowLongA(hWindow, GWL_STYLE) & (~(WS_BORDER | WS_DLGFRAME | WS_SIZEBOX));
    else iNewStyle = GetWindowLongA(hWindow, GWL_STYLE) | ( (WS_BORDER | WS_DLGFRAME | WS_SIZEBOX));
    if(hWindow > 0 && iNewStyle > 0) {
        SetWindowLongA(hWindow, GWL_STYLE, iNewStyle);
        SetWindowPos(hWindow, 0, 0, 0, 0, 0, SWP_NOZORDER | SWP_NOMOVE | SWP_NOSIZE | SWP_NOACTIVATE | SWP_FRAMECHANGED);
    }
}
//+------------------------------------------------------------------+
