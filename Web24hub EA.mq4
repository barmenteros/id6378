//+------------------------------------------------------------------+
//|                                                      Web24hub EA |
//|                                                   Copyright 2025 |
//|                             https://web24hub.example.com/support |
//+------------------------------------------------------------------+

#property copyright   "Copyright 2025 Web24hub EA Team"
#property link        "https://web24hub.example.com/support"
#property description "Web24hub EA: Advanced Supply & Demand Scanner and Trade Manager for MT4. Provides automated analysis, alerts, and trade management tools."
#define EA_VERSION  "1.00"
#property version   EA_VERSION
#property strict

#include "WindowsUtils.mqh"
#include "ChartObjects.mqh"
#include "TradingFunctions.mqh"
#include "AlertSystem.mqh"

string vers = "Web24hub EA v" + EA_VERSION;

enum TYPEBREAK {
    HLorLH = 1,
    Orderblock = 2,
};

input bool INTERNAL_STRUCTURE = false;
input bool SEE_LEGS = false;
int VPROFILE = 0;
input bool DASHBOARD = false;
input int ZOOM_PIXEL = 1;
input int FONT_SIZE = 8;
input int FONT_SIZE_CHART_TEXT = 7;
input TYPEBREAK CHECK_MITIGATION_AFTER = 1;
input string PROTECTION = "------------------------------------------------------";
input long CLOSE_ALL_AT_EQUITY = 0;
input long CLOSE_ALL_AT_PROFIT = 0;
input double MAX_DRAWDOWN_PERCENT = 20.0;  // Maximum drawdown percentage (default 20%)
input string SYMBOL_CHANGER = "------------------------------------------------------";
input string PREFIX = "";
input string PAIRS = "AUDUSD,AUDCAD,AUDCHF,AUDJPY,AUDNZD,CADCHF,CADJPY,CHFJPY,EURAUD,EURCHF,EURCAD,EURUSD,EURGBP,EURJPY,EURNZD,GBPAUD,GBPCAD,GBPCHF,GBPNZD,GBPJPY,GBPUSD,NZDCAD,NZDJPY,NZDUSD,NZDCHF,USDCAD,USDJPY,USDCHF,XAUUSD";
input string SUFFIX = "";
input string TF_SETUP = "------------------------------------------------------";
input int RISKSIZE_TMANAGER = 1;

int POI_TF = PERIOD_H4;
int SIGNAL_ENTRY = PERIOD_M15;
int USE_LSB_SIGNAL_ENTRY = 0;

input string STYLE_SETUP = "------------------------------------------------------";
int HTF = POI_TF;
int TFL = SIGNAL_ENTRY;

int HIDE_TDM = 0;
int HIDE_TD0 = 1;
int HIDE_TD1 = 0;
int HIDE_TD2 = 0;
int BARRE_DEVIATION = 0;
int CURRCAND = 0;

int PRIMOAVVIO = 1;

input color BACKGROUNDCOL = C'022,026,037';
input color COLOR_FOREGROUND = clrWhite;
input bool PERIOD_SEPARATOR = true;
input color COLOR_GRID = clrNONE;
input color COLOR_ASK = clrYellow;
input color COLOR_BID = clrWhite;
input color BACKGROUNDCOL_SCANNER = clrBlack;
input color Col_BullCandle2 = C'068,150,148';
input color Col_BearCandle2 = C'212,098,098';
input color Col_BullCandle = C'071,147,143';
input color Col_BearCandle = C'224,090,081';
input color Col_NY_OPEN = clrGray;
input string SYSTEM_TESTS = "------------------------------------------------------";
input bool METER = false;
input bool DEBUGMODE = false;

input string AUTOMATED_TRADING = "---------- Automated Trading Controls ----------";
input bool ENABLE_AUTO_TRADING = true;           // Enable/Disable automated trading
input bool AUTO_TRADING_M15 = true;              // Enable M15 automated signals
input bool AUTO_TRADING_H1 = true;               // Enable H1 automated signals
input int MAX_AUTO_TRADES = 3;                   // Maximum simultaneous automated trades
input int FVG_LOOKBACK_BARS = 5;                 // Bars to look back for recent FVG
input double MIN_RISK_REWARD = 1.5;              // Minimum risk:reward ratio

input string TRAILING_STOP_SETTINGS = "---------- Trailing Stop Controls ----------";
input int ltrailingstop = 30;                    // Buy trades: Profit step to activate trailing (points)
input int strailingstop = 30;                    // Sell trades: Profit step to activate trailing (points)
input int trailing_distance = 20;                // Distance behind current price for trailing SL (points)
input bool enable_breakeven = true;              // Enable breakeven protection as first step
input int breakeven_trigger = 15;                // Points profit to trigger breakeven protection
input int breakeven_buffer = 5;                  // Buffer points above/below entry for breakeven SL

input group "=== BOS ALERT SETTINGS ==="
input bool    ALERT_MAJOR_BOS_ONLY = true;        // Only alert on major BOS (ignore minor)
input bool    ALERT_BOS_SHOW_LEVELS = true;       // Include price levels in BOS alerts
input int     ALERT_BOS_MIN_POINTS = 20;          // Minimum points for BOS significance

input group "=== CHoCH ALERT SETTINGS ==="
input bool    ALERT_CHOCH_EMERGENCY_MODE = true;      // Enable emergency CHoCH alerts (highest priority)
input bool    ALERT_CHOCH_SHOW_IMPACT = true;         // Show trade impact in CHoCH alerts
input bool    ALERT_CHOCH_AUTO_CONFIRM = true;        // Send confirmation after auto-exit

input group "=== SD ZONE ALERT SETTINGS ==="
input bool    ALERT_SD_SHOW_STRENGTH = true;          // Show zone strength in alerts
input bool    ALERT_SD_SHOW_SETUP_GUIDANCE = true;    // Include trading setup guidance
input bool    ALERT_SD_PRIORITIZE_SOURCE = true;      // Prioritize SOURCE zone alerts
input bool    ALERT_SD_FILTER_WEAK_ZONES = false;     // Filter out weak zone interactions

input group "=== ORDER BLOCK ALERT SETTINGS ==="
input bool    ALERT_OB_SHOW_STRENGTH = true;          // Show Order Block strength in alerts
input bool    ALERT_OB_INSTITUTIONAL_FOCUS = true;    // Emphasize institutional nature of OBs
input bool    ALERT_OB_SHOW_PRICE_LEVELS = true;      // Include OB price levels in alerts
input int     ALERT_OB_MIN_STRENGTH = 3;              // Minimum strength score for OB alerts

input group "=== UNIVERSAL ALERT TOGGLE CONTROLS ==="
input bool    ALERT_TRADE_OPENED_POPUP = true;   // Enable popup alerts for newly opened trades
input bool    ALERT_TRADE_OPENED_MOBILE = true;  // Enable mobile alerts for newly opened trades
input bool    ALERT_BOS_POPUP = true;            // Enable popup alerts for BOS occurrences
input bool    ALERT_BOS_MOBILE = true;           // Enable mobile alerts for BOS occurrences
input bool    ALERT_CHOCH_POPUP = true;          // Enable popup alerts for CHoCH occurrences
input bool    ALERT_CHOCH_MOBILE = true;         // Enable mobile alerts for CHoCH occurrences
input bool    ALERT_SD_POPUP = true;             // Enable popup alerts for SD zone activations
input bool    ALERT_SD_MOBILE = true;            // Enable mobile alerts for SD zone activations
input bool    ALERT_OB_POPUP = true;             // Enable popup alerts for Order Block occurrences
input bool    ALERT_OB_MOBILE = true;            // Enable mobile alerts for Order Block occurrences

input bool DebugMode = false;  // Enable detailed logging for timeframe prioritization

int OWF = 0;
int VEDILIVELLI = 1;

int TFF = 0;

// https://www.w3.org/2002/09/tests/keys.html
#define KEY_STARTINDIETRO  78  // TASTO N
#define KEY_STARTINDIETROfast  74  // TASTO J
#define KEY_STARTAVANTIfast 75 // TASTO K
#define KEY_STARTAVANTI  77    // TASTO M
#define KEY_H  72
#define KEY_V  86
#define KEY_F  70
#define KEY_BACKTONOW 66
#define KEY_A  65
#define KEY_L  76
#define KEY_T  84
#define KEY_E  69
#define KEY_I  73
#define KEY_Q  81

int STRA0 = 0;
int STRA0_MANUAL = 0;
int STRA1 = 0;
int STRA2 = 0;
int STRA3 = 0;
int STRA4 = 0;
int STRA5 = 1;

int M1 = 0;
int M5 = 0;
int M15 = 0;
int M30 = 0;
int H1 = 0;
int H4 = 0;
int D1 = 0;
int W1 = 0;
int MN1 = 0;

datetime M1NEWBAR = 0;
datetime M5NEWBAR = 0;
datetime M15NEWBAR = 0;
datetime M30NEWBAR = 0;
datetime H1NEWBAR = 0;
datetime H4NEWBAR = 0;
datetime D1NEWBAR = 0;
datetime W1NEWBAR = 0;
datetime MN1NEWBAR = 0;

int M1SD = 0;
int M5SD = 0;
int M15SD = 0;
int M30SD = 0;
int H1SD = 0;
int H4SD = 0;
int D1SD = 0;
int W1SD = 0;
int MN1SD = 0;

int M1LQ = 0;
int M5LQ = 0;
int M15LQ = 0;
int M30LQ = 0;
int H1LQ = 0;
int H4LQ = 0;
int D1LQ = 0;
int W1LQ = 0;
int MN1LQ = 0;

int M1FV = 0;
int M5FV = 0;
int M15FV = 0;
int M30FV = 0;
int H1FV = 0;
int H4FV = 0;
int D1FV = 0;
int W1FV = 0;
int MN1FV = 0;

int LSBSOURCE = 0;
int LSBSOURCEMITIGATED = 0;
int LSBBROKENYES = 0;
int BSSLSBSOURCE = 0;
int BSSLSBSOURCEMITIGATED = 0;
int BSSLSBBROKENYES = 0;

int TRADEMODE = 0;
int PENDINGMODE = 0;
int OPENTRADE = 0;

int VOL = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    if(borderhidden == 0) borderhidden = (int)GlobalVariableGet("BORD");
    M1CANDLE = 0;
    M5CANDLE = 0;
    M15CANDLE = 0;
    M30CANDLE = 0;
    H1CANDLE = 0;
    H4CANDLE = 0;
    D1CANDLE = 0;
    W1CANDLE = 0;
    MN1CANDLE = 0;
    int tot = GlobalVariablesTotal();
    int totalObjects = ObjectsTotal(0, 0, -1);
    for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
        if(StringSubstr(ObjectName(i), 0, 5) != "NODEL") ObjectDelete(ObjectName(i));
    }
    if(DASHBOARD == false) {
        ChartSetInteger(0, CHART_FOREGROUND, 0);
        Create_Button(0, "BUTT_TDM", 0, 0, 20, 20, 120, CORNER_LEFT_UPPER, "<", clrLightGray);
        Create_Button(0, "BUTXTDM_PROTECT", 0, 20, 20, 120, 20, CORNER_LEFT_UPPER, "PROTECT", clrLightGray);
        Create_Button(0, "BUTXTDM_COPYTPSL", 0, 20, 40, 120, 20, CORNER_LEFT_UPPER, "COPY TP/SL", clrLightGray);
        Create_Button(0, "BUTXTDM_MOVETPSL", 0, 20, 60, 120, 20, CORNER_LEFT_UPPER, "MOVE SL", clrLightGray);
        Create_Button(0, "BUTXTDM_CANCELTPSL", 0, 20, 80, 120, 20, CORNER_LEFT_UPPER, "CANCEL TP/SL", clrLightGray);
        Create_Button(0, "BUTXTDM_CLOSEALL", 0, 20, 100, 120, 20, CORNER_LEFT_UPPER, "CLOSE ALL", clrLightGray);
        Create_Button(0, "BUTXTDM_COPYORDER", 0, 20, 120, 120, 20, CORNER_LEFT_UPPER, "COPY ORDER", clrLightGray);
        Create_Button(0, "BUTT_TD0", 0, 0, 150, 20, 150, CORNER_LEFT_LOWER, "<", clrLightGray);
        Create_Button(0, "BUTXTD0_CLEAR", 0, 420, 150, 50, 20, CORNER_LEFT_LOWER, "CLEAR", clrLightGray);
        Create_Button(0, "BUTXTD0_YHYL", 0, 20, 150, 50, 20, CORNER_LEFT_LOWER, "YH/YL", clrLightGray);
        Create_Button(0, "BUTXTD0_WHWL", 0, 70, 150, 50, 20, CORNER_LEFT_LOWER, "WH/WL", clrLightGray);
        Create_Button(0, "BUTXTD0_MHML", 0, 120, 150, 50, 20, CORNER_LEFT_LOWER, "MH/ML", clrLightGray);
        Create_Button(0, "BUTXTD0_M1", 0, 20, 100, 50, 20, CORNER_LEFT_LOWER, "OFF", clrLightGray);
        Create_Button(0, "BUTXTD0_M5", 0, 70, 100, 50, 20, CORNER_LEFT_LOWER, "OFF", clrLightGray);
        Create_Button(0, "BUTXTD0_M15", 0, 120, 100, 50, 20, CORNER_LEFT_LOWER, "OFF", clrLightGray);
        Create_Button(0, "BUTXTD0_M30", 0, 170, 100, 50, 20, CORNER_LEFT_LOWER, "OFF", clrLightGray);
        Create_Button(0, "BUTXTD0_H1", 0, 220, 100, 50, 20, CORNER_LEFT_LOWER, "OFF", clrLightGray);
        Create_Button(0, "BUTXTD0_H4", 0, 270, 100, 50, 20, CORNER_LEFT_LOWER, "OFF", clrLightGray);
        Create_Button(0, "BUTXTD0_D1", 0, 320, 100, 50, 20, CORNER_LEFT_LOWER, "OFF", clrLightGray);
        Create_Button(0, "BUTXTD0_W1", 0, 370, 100, 50, 20, CORNER_LEFT_LOWER, "OFF", clrLightGray);
        Create_Button(0, "BUTXTD0_MN1", 0, 420, 100, 50, 20, CORNER_LEFT_LOWER, "OFF", clrLightGray);
        EditCreate(0, "BUTXTD0_LOADING", 0, 260 * ZOOM_PIXEL, 170 * ZOOM_PIXEL, 150 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "Last Candle", "Arial", FONT_SIZE, ALIGN_CENTER, true, CORNER_LEFT_LOWER, clrWhite, clrBlack, clrBlack);
        Create_Button(0, "BUTXTD0_BACKBACK", 0, 260, 150, 30, 20, CORNER_LEFT_LOWER, "<<", clrLightGray);
        Create_Button(0, "BUTXTD0_BACK", 0, 290, 150, 30, 20, CORNER_LEFT_LOWER, "<", clrLightGray);
        Create_Button(0, "BUTXTD0_NOW", 0, 320, 150, 30, 20, CORNER_LEFT_LOWER, "|", clrLightGray);
        Create_Button(0, "BUTXTD0_NEXT", 0, 350, 150, 30, 20, CORNER_LEFT_LOWER, ">", clrLightGray);
        Create_Button(0, "BUTXTD0_NEXTNEXT", 0, 380, 150, 30, 20, CORNER_LEFT_LOWER, ">>", clrLightGray);
        Create_Button(0, "BUTXTD0_ZM1", 0, 20, 120, 50, 20, CORNER_LEFT_LOWER, "M1", clrLightGray);
        Create_Button(0, "BUTXTD0_ZM5", 0, 70, 120, 50, 20, CORNER_LEFT_LOWER, "M5", clrLightGray);
        Create_Button(0, "BUTXTD0_ZM15", 0, 120, 120, 50, 20, CORNER_LEFT_LOWER, "M15", clrLightGray);
        Create_Button(0, "BUTXTD0_ZM30", 0, 170, 120, 50, 20, CORNER_LEFT_LOWER, "M30", clrLightGray);
        Create_Button(0, "BUTXTD0_ZH1", 0, 220, 120, 50, 20, CORNER_LEFT_LOWER, "H1", clrLightGray);
        Create_Button(0, "BUTXTD0_ZH4", 0, 270, 120, 50, 20, CORNER_LEFT_LOWER, "H4", clrLightGray);
        Create_Button(0, "BUTXTD0_ZD1", 0, 320, 120, 50, 20, CORNER_LEFT_LOWER, "D1", clrLightGray);
        Create_Button(0, "BUTXTD0_ZW1", 0, 370, 120, 50, 20, CORNER_LEFT_LOWER, "W1", clrLightGray);
        Create_Button(0, "BUTXTD0_ZMN1", 0, 420, 120, 50, 20, CORNER_LEFT_LOWER, "MN1", clrLightGray);
        Create_Button(0, "BUTXTD0_SESS", 0, 170, 150, 40, 20, CORNER_LEFT_LOWER, "KZ", clrLightGray);
        Create_Button(0, "BUTXTD0_ALERT", 0, 210, 150, 50, 20, CORNER_LEFT_LOWER, "ALERT", clrLightGray);
        if(DASHBOARD == false) TIMEFRAMESEL(Symbol(), Period());
        Create_Button(0, "BUTT_TD1", 0, 0, 260, 20, 80, CORNER_LEFT_LOWER, "<", clrLightGray);
        EditCreate(0, "BUTXTD1_RISKtext", 0, 20 * ZOOM_PIXEL, 260 * ZOOM_PIXEL, 100 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "RISK SIZE % ", "Arial", FONT_SIZE, ALIGN_CENTER, true, CORNER_LEFT_LOWER, clrBlue, clrLightGreen);
        EditCreate(0, "BUTXTD1_RISK", 0, 120 * ZOOM_PIXEL, 260 * ZOOM_PIXEL, 100 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, (string)RISKSIZE_TMANAGER, "Arial", FONT_SIZE, ALIGN_CENTER, false, CORNER_LEFT_LOWER, clrBlue);
        Create_Button(0, "BUTXTD1_DRAW", 0, 20, 240, 200, 20, CORNER_LEFT_LOWER, "SET ON CHART", clrLightGray);
        Create_Button(0, "BUTXTD1_PENDING", 0, 70, 220, 150, 20, CORNER_LEFT_LOWER, "PENDING MODE", clrLightGray);
        EditCreate(0, "BUTXTD1_NUMB", 0, 20 * ZOOM_PIXEL, 220 * ZOOM_PIXEL, 50 * ZOOM_PIXEL, 40 * ZOOM_PIXEL, "1", "Arial", FONT_SIZE, ALIGN_CENTER, false, CORNER_LEFT_LOWER, clrBlue);
        Create_Button(0, "BUTXTD1_OPEN", 0, 70, 200, 150, 20, CORNER_LEFT_LOWER, "OPEN TRADE", clrLightGray);
        Create_Button(0, "BUTXTD2_FIX_CHART", 0, 0, 480, 20, 20, CORNER_LEFT_LOWER, "X", clrLightGray);
        Create_Button(0, "BUTXTD2_NEW_CHART", 0, 20, 460, 40, 20, CORNER_LEFT_LOWER, "NEW", clrLightGray);
        Create_Button(0, "BUTXTD2_CLOSE_CHART", 0, 60, 460, 100, 20, CORNER_LEFT_LOWER, "CLOSE OTHERS", clrLightGray);
        ObjectSetString(0, "BUTXTD2_FIX_CHART", OBJPROP_TEXT, borderhidden ? "ON" : "X");
        ObjectSetInteger(0, "BUTXTD2_FIX_CHART", OBJPROP_BGCOLOR, borderhidden ? clrYellow : clrLightGray);
        Create_Button(0, "BUTT_TD2", 0, 0, 460, 20, 180, CORNER_LEFT_LOWER, "<", clrLightGray);
        SYMBOL_CHANGER(1);
    }
    else {
        totalObjects = ObjectsTotal(0, 0, -1);
        for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
            ObjectDelete(ObjectName(i));
        }
    }
    M1 = (int)GlobalVariableGet(Symbol() + "M1");
    M5 = (int)GlobalVariableGet(Symbol() + "M5");
    M15 = (int)GlobalVariableGet(Symbol() + "M15");
    M30 = (int)GlobalVariableGet(Symbol() + "M30");
    H1 = (int)GlobalVariableGet(Symbol() + "H1");
    H4 = (int)GlobalVariableGet(Symbol() + "H4");
    D1 = (int)GlobalVariableGet(Symbol() + "D1");
    W1 = (int)GlobalVariableGet(Symbol() + "W1");
    MN1 = (int)GlobalVariableGet(Symbol() + "MN1");
    int   dD = NULL;
    int   dM = NULL;
    int   dY = NULL;
    M1SD = (int)GlobalVariableGet(Symbol() + "M1SD");
    M5SD = (int)GlobalVariableGet(Symbol() + "M5SD");
    M15SD = (int)GlobalVariableGet(Symbol() + "M15SD");
    M30SD = (int)GlobalVariableGet(Symbol() + "M30SD");
    H1SD = (int)GlobalVariableGet(Symbol() + "H1SD");
    H4SD = (int)GlobalVariableGet(Symbol() + "H4SD");
    D1SD = (int)GlobalVariableGet(Symbol() + "D1SD");
    W1SD = (int)GlobalVariableGet(Symbol() + "W1SD");
    MN1SD = (int)GlobalVariableGet(Symbol() + "MN1SD");
    if(IsConnected()) dD = TimeDay(TimeCurrent());
    if(IsConnected()) dM = TimeMonth(TimeCurrent());
    if(IsConnected()) dY = TimeYear(TimeCurrent());
    M1LQ = (int)GlobalVariableGet(Symbol() + "M1LQ");
    M5LQ = (int)GlobalVariableGet(Symbol() + "M5LQ");
    M15LQ = (int)GlobalVariableGet(Symbol() + "M15LQ");
    M30LQ = (int)GlobalVariableGet(Symbol() + "M30LQ");
    H1LQ = (int)GlobalVariableGet(Symbol() + "H1LQ");
    H4LQ = (int)GlobalVariableGet(Symbol() + "H4LQ");
    D1LQ = (int)GlobalVariableGet(Symbol() + "D1LQ");
    W1LQ = (int)GlobalVariableGet(Symbol() + "W1LQ");
    MN1LQ = (int)GlobalVariableGet(Symbol() + "MN1LQ");
    M1FV = (int)GlobalVariableGet(Symbol() + "M1FVG");
    M5FV = (int)GlobalVariableGet(Symbol() + "M5FVG");
    M15FV = (int)GlobalVariableGet(Symbol() + "M15FVG");
    M30FV = (int)GlobalVariableGet(Symbol() + "M30FVG");
    H1FV = (int)GlobalVariableGet(Symbol() + "H1FVG");
    H4FV = (int)GlobalVariableGet(Symbol() + "H4FVG");
    D1FV = (int)GlobalVariableGet(Symbol() + "D1FVG");
    W1FV = (int)GlobalVariableGet(Symbol() + "W1FVG");
    MN1FV = (int)GlobalVariableGet(Symbol() + "MN1FVG");
    GlobalVariableSet(Symbol() + "TD0", 1);
    GlobalVariableSet(Symbol() + "TD0", 1);
    HIDE_TDM = (int)GlobalVariableGet(Symbol() + "TDM");
    HIDE_TD1 = (int)GlobalVariableGet(Symbol() + "TD1");
    HIDE_TD2 = (int)GlobalVariableGet(Symbol() + "TD2");
    VEDIPD = (int)GlobalVariableGet(Symbol() + "PD");
    VEDIPW = (int)GlobalVariableGet(Symbol() + "PW");
    VEDIPM = (int)GlobalVariableGet(Symbol() + "PM");
    OWF = 1;
    VEDIPDHL(Symbol(), PERIOD_D1, VEDIPD);
    VEDIPDHL(Symbol(), PERIOD_W1, VEDIPW);
    VEDIPDHL(Symbol(), PERIOD_MN1, VEDIPM);
    TFF = Period();
    if(DASHBOARD == false) {
        ChartSetInteger(0, CHART_SHOW_BID_LINE, true);
        ChartSetInteger(0, CHART_SHOW_ASK_LINE, true);
        ChartSetInteger(0, CHART_COLOR_ASK, COLOR_ASK);
        ChartSetInteger(0, CHART_COLOR_BID, COLOR_BID);
        ChartSetInteger(0, CHART_MODE, 1);
        ChartSetInteger(0, CHART_COLOR_BACKGROUND, BACKGROUNDCOL);
        ChartSetInteger(0, CHART_COLOR_CHART_LINE, clrWhite);
        ChartSetInteger(0, CHART_COLOR_FOREGROUND, COLOR_FOREGROUND);
        ChartSetInteger(0, CHART_COLOR_GRID, COLOR_GRID);
        ChartSetInteger(0, CHART_COLOR_CHART_DOWN, Col_BearCandle2);
        ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, Col_BearCandle);
        ChartSetInteger(0, CHART_COLOR_CHART_UP, Col_BullCandle2);
        ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, Col_BullCandle);
        ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, PERIOD_SEPARATOR);
        ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, VEDILIVELLI);
        ChartSetInteger(0, CHART_AUTOSCROLL, 1);
        ChartSetInteger(0, CHART_SHIFT, 1);
        ChartSetInteger(0, CHART_SCALEFIX, false);
        if(borderhidden == 1) ChartSetInteger(0, CHART_SCALEFIX, true);
        else ChartSetInteger(0, CHART_SCALEFIX, false);
    }
    if(DASHBOARD == true) {
        ChartSetInteger(0, CHART_SHOW_BID_LINE, false);
        ChartSetInteger(0, CHART_SHOW_ASK_LINE, false);
        ChartSetInteger(0, CHART_MODE, 1);
        ChartSetInteger(0, CHART_COLOR_BACKGROUND, BACKGROUNDCOL_SCANNER);
        ChartSetInteger(0, CHART_COLOR_FOREGROUND, clrNONE);
        ChartSetInteger(0, CHART_COLOR_CHART_DOWN, clrNONE);
        ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, clrNONE);
        ChartSetInteger(0, CHART_COLOR_CHART_UP, clrNONE);
        ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, clrNONE);
        ChartSetInteger(0, CHART_COLOR_CHART_LINE, clrNONE);
        ChartSetInteger(0, CHART_SHOW_GRID, 0);
        ChartSetInteger(0, CHART_COLOR_GRID, clrNONE);
        ChartSetInteger(0, CHART_FOREGROUND, 0);
        ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, VEDILIVELLI);
    }
    GlobalVariableSet(Symbol() + "STRA0", STRA0);
    GlobalVariableSet(Symbol() + "STRA5", STRA5);
    ALSYS = (int)GlobalVariableGet(Symbol() + "ALSYS");
    STRA0 = (int)GlobalVariableGet(Symbol() + "STRA0");
    STRA1 = (int)GlobalVariableGet("STRA1");
    STRA2 = (int)GlobalVariableGet("STRA2");
    STRA4 = (int)GlobalVariableGet(Symbol() + "STRA4");
    STRA5 = (int)GlobalVariableGet(Symbol() + "STRA5");
    USE_LSB_SIGNAL_ENTRY = (int)GlobalVariableGet(Symbol() + "STRA4");
    VOL = (int)iVolume(Symbol(), 5, 0);
    SHOWHIDE(HIDE_TD2, "TD2");
    SHOWHIDE(HIDE_TD1, "TD1");
    SHOWHIDE(HIDE_TD0, "TD0");
    SHOWHIDE_TDM(HIDE_TDM);
    if(BARRE_DEVIATION != 0) BARRE_DEVIATION = iBarShift(Symbol(), 0, iTime(Symbol(), (int)GlobalVariableGet(Symbol() + "TFBARRE"), (int)GlobalVariableGet(Symbol() + "BARRE")));
    else {
        GlobalVariableSet(Symbol() + "TFBARRE", Period());
        GlobalVariableSet(Symbol() + "BARRE", 0);
    }
    RILANCIAfun(0, Symbol());
    if(DASHBOARD == false) LabelCreate_topright(0, "BUTT_INFO0", 0, 10 * ZOOM_PIXEL, 3 * (2 * (FONT_SIZE + 5))*ZOOM_PIXEL, CORNER_RIGHT_LOWER, Symbol(), "Verdana", COLOR_FOREGROUND, 0, ANCHOR_RIGHT_LOWER, false, false, true, 0);
    if(DASHBOARD == false) LabelCreate_topright(0, "BUTT_INFO1", 0, 10 * ZOOM_PIXEL, 2 * (2 * (FONT_SIZE + 5))*ZOOM_PIXEL, CORNER_RIGHT_LOWER, tftransformation(Period()), "Verdana", COLOR_FOREGROUND, 0, ANCHOR_RIGHT_LOWER, false, false, true, 0);
    if(DASHBOARD == false) LabelCreate_topright(0, "BUTT_VERS2", 0, 10 * ZOOM_PIXEL, 1 * (2 * (FONT_SIZE + 5))*ZOOM_PIXEL, CORNER_RIGHT_LOWER, vers, "Verdana", COLOR_FOREGROUND, 0, ANCHOR_RIGHT_LOWER, false, false, true, 0);
    GlobalVariableSet("FIRES", 0);
    GlobalVariableSet(Symbol() + "POITREND" + (string)Period(), iBars(Symbol(), 0));
    GlobalVariableSet(Symbol() + "POIVSTREND" + (string)Period(), iBars(Symbol(), 0));

// Initialize automated trading settings
    if(ENABLE_AUTO_TRADING) {
        Print("Web24hub EA: Automated Trading ENABLED");
        Print("- M15 Auto Trading: ", (AUTO_TRADING_M15 ? "ON" : "OFF"));
        Print("- H1 Auto Trading: ", (AUTO_TRADING_H1 ? "ON" : "OFF"));
        Print("- Max Auto Trades: ", MAX_AUTO_TRADES);
        Print("- Risk per Trade: ", RISKSIZE_TMANAGER, "%");
        Print("- Min Risk:Reward: ", MIN_RISK_REWARD);
    }
    else {
        Print("Web24hub EA: Automated Trading DISABLED");
    }

// Initialize trailing stop settings
    if(ENABLE_AUTO_TRADING) {
        Print("Web24hub EA: Step Profit Trailing Stop Configuration:");
        Print("- Buy Profit Step: ", ltrailingstop, " points");
        Print("- Sell Profit Step: ", strailingstop, " points");
        Print("- Trailing Distance: ", trailing_distance, " points");
        Print("- Breakeven Protection: ", (enable_breakeven ? "ENABLED" : "DISABLED"));
        if(enable_breakeven) {
            Print("  - Breakeven Trigger: ", breakeven_trigger, " points");
            Print("  - Breakeven Buffer: ", breakeven_buffer, " points");
        }

        // Validate parameters
        if(!ValidateTrailingStopParameters()) {
            Print("WARNING: Some trailing stop parameters may need adjustment");
        }
    }

// === VERIFY RISK SETTINGS INTEGRATION ===
    Print("RISK SETTINGS VERIFICATION:");
    Print("- RISKSIZE_TMANAGER Input: ", RISKSIZE_TMANAGER, "%");

// Verify UI synchronization
    if(ObjectFind(0, "BUTXTD1_RISK") >= 0) {
        string uiRisk = ObjectGetString(0, "BUTXTD1_RISK", OBJPROP_TEXT);
        Print("- UI Risk Setting: ", uiRisk, "%");

        // Synchronize if different
        if(StringToDouble(uiRisk) != RISKSIZE_TMANAGER) {
            ObjectSetString(0, "BUTXTD1_RISK", OBJPROP_TEXT, DoubleToString(RISKSIZE_TMANAGER, 1));
            Print("- Risk settings synchronized: UI updated to match input parameter");
        }
    }

// Validate risk percentage range
    if(RISKSIZE_TMANAGER < 0.1 || RISKSIZE_TMANAGER > 10) {
        Print("WARNING: Risk percentage ", RISKSIZE_TMANAGER, "% is outside recommended range (0.1% - 10%)");
    }

// === INITIALIZE DRAWDOWN MONITORING ===
    Print("DRAWDOWN PROTECTION SETTINGS:");
    Print("- Maximum Drawdown Limit: ", MAX_DRAWDOWN_PERCENT, "%");

    if(MAX_DRAWDOWN_PERCENT <= 0) {
        Print("- Status: DISABLED (set MAX_DRAWDOWN_PERCENT > 0 to enable)");
    }
    else {
        InitializeDrawdownMonitoring();
        double currentEquity = AccountEquity();
        double currentDrawdown = CalculateCurrentDrawdown();

        Print("- Status: ENABLED");
        Print("- Current Equity: ", DoubleToString(currentEquity, 2));
        Print("- Current Drawdown: ", DoubleToString(currentDrawdown, 2), "%");

        if(MAX_DRAWDOWN_PERCENT < 5 || MAX_DRAWDOWN_PERCENT > 50) {
            Print("WARNING: Drawdown limit ", MAX_DRAWDOWN_PERCENT,
                  "% is outside recommended range (5%-50%)");
        }
    }

// Initialize trade opening alert system
    InitializeTradeOpeningAlerts();

// Initialize BOS alert system
    InitializeEnhancedBOSAlerts();

    InitializeEnhancedCHoCHAlerts();

// Initialize enhanced SD zone alert system
    InitializeEnhancedSDZoneAlerts();

// Initialize enhanced order block alert system
    InitializeEnhancedOrderBlockAlerts();

// Initialize universal alert toggle controls
    InitializeUniversalAlertToggles();

// Validate universal alert settings
    if(!ValidateUniversalAlertSettings()) {
        Print("Universal Alert validation completed with warnings - review settings if needed");
    }

// Verify timeframe prioritization and flexibility
    if(!VerifyTimeframePrioritization()) {
        Print("CRITICAL: Timeframe prioritization verification failed!");
        Print("EA will continue running but automated trading may not work as expected.");
    }

// Log current automated trading configuration
    int priorityTF = GetPrioritizedAutomatedTimeframe();
    if(priorityTF > 0) {
        LogTimeframePriorityDecision(priorityTF, "Highest priority automated timeframe selected");
    }
    else {
        if(ENABLE_AUTO_TRADING) {
            Print("WARNING: Automated trading enabled but no valid timeframes available");
            Print("- Check M15/H1 timeframe settings and enable required components");
        }
    }

    return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    SYMBOL_CHANGER(0);
    if(DASHBOARD == false) {
        if(METER == true) FORZAVAL(Symbol());
        TIMEFRAMESEL(Symbol(), Period());
    }
    string DOVESONO = "";
    if(GlobalVariableGet(Symbol() + "BARRE") == 0) {
        GlobalVariableSet(Symbol() + "TFBARRE", Period());
        GlobalVariableSet(Symbol() + "BARRE", 0);
        DOVESONO = "Last Candle";
    }
    else DOVESONO = tftransformation((int)GlobalVariableGet(Symbol() + "TFBARRE")) + " : n°" + (string)GlobalVariableGet(Symbol() + "BARRE") + " bars back";
    if((BARRE_DEVIATION != CURRCAND)) EditTextChange(0, "BUTXTD0_LOADING", DOVESONO, clrViolet);
    if((BARRE_DEVIATION == 0)) EditTextChange(0, "BUTXTD0_LOADING", DOVESONO, clrWhite);
    BARRE_DEVIATION = (int)GlobalVariableGet(Symbol() + "BARRE");
    if(M1 == 1) PREMIUMDISCOUNT(Symbol(), 1, CURRCAND);
    if(M5 == 1) PREMIUMDISCOUNT(Symbol(), 5, CURRCAND);
    if(M15 == 1) PREMIUMDISCOUNT(Symbol(), 15, CURRCAND);
    if(M30 == 1) PREMIUMDISCOUNT(Symbol(), 30, CURRCAND);
    if(H1 == 1) PREMIUMDISCOUNT(Symbol(), 60, CURRCAND);
    if(H4 == 1) PREMIUMDISCOUNT(Symbol(), 240, CURRCAND);
    if(D1 == 1) PREMIUMDISCOUNT(Symbol(), 1440, CURRCAND);
    if(W1 == 1) PREMIUMDISCOUNT(Symbol(), PERIOD_W1, CURRCAND);
    if(MN1 == 1) PREMIUMDISCOUNT(Symbol(), PERIOD_MN1, CURRCAND);

// Monitor and close trades that have reached their Take Profit levels
    if(ENABLE_AUTO_TRADING) {
        MonitorAutomatedTradesTP();

        // Optional: Validate TP levels periodically (every 100 ticks)
        static int tpValidationCounter = 0;
        tpValidationCounter++;
        if(tpValidationCounter >= 100) {
            ValidateTPLevels();
            tpValidationCounter = 0;
        }
    }

// STEP PROFIT TRAILING STOP
    if(ENABLE_AUTO_TRADING) {
        // Process trailing stops on every tick for real-time response
        ProcessTrailingStops();

        // Optional: Validate parameters periodically
        static int trailingValidationCounter = 0;
        trailingValidationCounter++;
        if(trailingValidationCounter >= 500) { // Every 500 ticks
            ValidateTrailingStopParameters();
            trailingValidationCounter = 0;
        }
    }

    int TEM = 0;
    TEM = (int)GlobalVariableGet(Symbol() + "TFBARRE");
    string SIM = Symbol();
    if(M1 == 1 && (CHECKnewBar(SIM, 1) || BARRE_DEVIATION != CURRCAND)) {
        if(BARRE_DEVIATION == 0) TEM = 1;
        ORDERBLOCK(Symbol(), 1, iBarShift(Symbol(), 1, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(Symbol(), 1, iBarShift(Symbol(), 1, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, M1SD, M1LQ, M1FV);
        ORDERBLOCKshowliq(Symbol(), 1, iBarShift(Symbol(), 1, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1, M1LQ, 1);
        FVGfunc(M1FV, Symbol(), 1, iBarShift(Symbol(), 1, iTime(Symbol(), TEM, BARRE_DEVIATION)));
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_M1", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_M1", OBJPROP_BGCOLOR, clrOrangeRed);
        if(ALSYS == 1 && Period() == 1) ALERTPOPUP(Symbol(), 1, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);
    }
    if(M5 == 1 && (CHECKnewBar(SIM, 5) || BARRE_DEVIATION != CURRCAND)) {
        if(BARRE_DEVIATION == 0) TEM = 5;
        ORDERBLOCK(Symbol(), 5, iBarShift(Symbol(), 5, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(Symbol(), 5, iBarShift(Symbol(), 5, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, M5SD, M5LQ, M5FV);
        ORDERBLOCKshowliq(Symbol(), 5, iBarShift(Symbol(), 5, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1, M5LQ, 1);
        FVGfunc(M5FV, Symbol(), 5, iBarShift(Symbol(), 5, iTime(Symbol(), TEM, BARRE_DEVIATION)));
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_M5", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_M5", OBJPROP_BGCOLOR, clrOrangeRed);
        if(ALSYS == 1 && Period() == 5) ALERTPOPUP(Symbol(), 5, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);
    }
    if(M15 == 1 && (CHECKnewBar(SIM, 15) || BARRE_DEVIATION != CURRCAND)) {
        if(BARRE_DEVIATION == 0) TEM = 15;

        // Existing SMC/ICT analysis functions
        ORDERBLOCK(Symbol(), 15, iBarShift(Symbol(), 15, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(Symbol(), 15, iBarShift(Symbol(), 15, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, M15SD, M15LQ, M15FV);
        ORDERBLOCKshowliq(Symbol(), 15, iBarShift(Symbol(), 15, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1, M15LQ, 1);
        FVGfunc(M15FV, Symbol(), 15, iBarShift(Symbol(), 15, iTime(Symbol(), TEM, BARRE_DEVIATION)));

        // Existing UI updates
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_M15", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_M15", OBJPROP_BGCOLOR, clrOrangeRed);
        if(ALSYS == 1 && Period() == 15) ALERTPOPUP(Symbol(), 15, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);

        // AUTOMATED TRADING with M15 prioritization
        if(ShouldExecuteAutomatedTrading(15) && ValidateTimeframeConfiguration(15)) {
            LogTimeframePriorityDecision(15, "M15 priority execution");

            // Execute buy signal check
            if(CheckAndExecuteAutomatedBuySignal(15)) {
                if(DebugMode) Print("M15 automated BUY signal executed successfully");
            }

            // Execute sell signal check
            if(CheckAndExecuteAutomatedSellSignal(15)) {
                if(DebugMode) Print("M15 automated SELL signal executed successfully");
            }
        }
    }
    if(M30 == 1 && (CHECKnewBar(SIM, 30) || BARRE_DEVIATION != CURRCAND)) {
        if(BARRE_DEVIATION == 0) TEM = 30;
        ORDERBLOCK(Symbol(), 30, iBarShift(Symbol(), 30, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(Symbol(), 30, iBarShift(Symbol(), 30, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, M30SD, M30LQ, M30FV);
        ORDERBLOCKshowliq(Symbol(), 30, iBarShift(Symbol(), 30, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1, M30LQ, 1);
        FVGfunc(M30FV, Symbol(), 30, iBarShift(Symbol(), 30, iTime(Symbol(), TEM, BARRE_DEVIATION)));
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_M30", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_M30", OBJPROP_BGCOLOR, clrOrangeRed);
        if(ALSYS == 1 && Period() == 30) ALERTPOPUP(Symbol(), 30, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);
    }
    if(H1 == 1 && (CHECKnewBar(SIM, 60) || BARRE_DEVIATION != CURRCAND)) {
        if(BARRE_DEVIATION == 0) TEM = 60;

        // Existing SMC/ICT analysis functions
        ORDERBLOCK(Symbol(), 60, iBarShift(Symbol(), 60, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(Symbol(), 60, iBarShift(Symbol(), 60, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, H1SD, H1LQ, H1FV);
        ORDERBLOCKshowliq(Symbol(), 60, iBarShift(Symbol(), 60, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1, H1LQ, 1);
        FVGfunc(H1FV, Symbol(), 60, iBarShift(Symbol(), 60, iTime(Symbol(), TEM, BARRE_DEVIATION)));

        // Existing UI updates
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_H1", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_H1", OBJPROP_BGCOLOR, clrOrangeRed);
        if(ALSYS == 1 && Period() == 60) ALERTPOPUP(Symbol(), 60, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);

        // AUTOMATED TRADING with H1 execution (lower priority than M15)
        if(ShouldExecuteAutomatedTrading(60) && ValidateTimeframeConfiguration(60)) {
            LogTimeframePriorityDecision(60, "H1 execution (M15 not available)");

            // Execute buy signal check
            if(CheckAndExecuteAutomatedBuySignal(60)) {
                if(DebugMode) Print("H1 automated BUY signal executed successfully");
            }

            // Execute sell signal check
            if(CheckAndExecuteAutomatedSellSignal(60)) {
                if(DebugMode) Print("H1 automated SELL signal executed successfully");
            }
        }
    }
    if(H4 == 1 && (CHECKnewBar(SIM, 240) || BARRE_DEVIATION != CURRCAND)) {
        if(BARRE_DEVIATION == 0) TEM = 240;
        ORDERBLOCK(Symbol(), 240, iBarShift(Symbol(), 240, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(Symbol(), 240, iBarShift(Symbol(), 240, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, H4SD, H4LQ, H4FV);
        ORDERBLOCKshowliq(Symbol(), 240, iBarShift(Symbol(), 240, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1, H4LQ, 1);
        FVGfunc(H4FV, Symbol(), 240, iBarShift(Symbol(), 240, iTime(Symbol(), TEM, BARRE_DEVIATION)));
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_H4", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_H4", OBJPROP_BGCOLOR, clrOrangeRed);
        if(ALSYS == 1 && Period() == 240) ALERTPOPUP(Symbol(), 240, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);
    }
    if(D1 == 1 && (CHECKnewBar(SIM, 1440) || BARRE_DEVIATION != CURRCAND)) {
        if(BARRE_DEVIATION == 0) TEM = 1440;
        ORDERBLOCK(Symbol(), 1440, iBarShift(Symbol(), 1440, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(Symbol(), 1440, iBarShift(Symbol(), 1440, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, D1SD, D1LQ, D1FV);
        ORDERBLOCKshowliq(Symbol(), 1440, iBarShift(Symbol(), 1440, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1, D1LQ, 1);
        FVGfunc(D1FV, Symbol(), 1440, iBarShift(Symbol(), 1440, iTime(Symbol(), TEM, BARRE_DEVIATION)));
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_D1", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_D1", OBJPROP_BGCOLOR, clrOrangeRed);
        if(ALSYS == 1 && Period() == 1440) ALERTPOPUP(Symbol(), 1440, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);
    }
    if(W1 == 1 && (CHECKnewBar(SIM, PERIOD_W1) || BARRE_DEVIATION != CURRCAND)) {
        if(BARRE_DEVIATION == 0) TEM = PERIOD_W1;
        ORDERBLOCK(Symbol(), PERIOD_W1, iBarShift(Symbol(), PERIOD_W1, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(Symbol(), PERIOD_W1, iBarShift(Symbol(), PERIOD_W1, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, W1SD, W1LQ, W1FV);
        ORDERBLOCKshowliq(Symbol(), PERIOD_W1, iBarShift(Symbol(), PERIOD_W1, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1, W1LQ, 1);
        FVGfunc(W1FV, Symbol(), PERIOD_W1, iBarShift(Symbol(), PERIOD_W1, iTime(Symbol(), TEM, BARRE_DEVIATION)));
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_W1", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_W1", OBJPROP_BGCOLOR, clrOrangeRed);
        if(ALSYS == 1 && Period() == PERIOD_W1) ALERTPOPUP(Symbol(), PERIOD_W1, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);
    }
    if(MN1 == 1 && (CHECKnewBar(SIM, PERIOD_MN1) || BARRE_DEVIATION != CURRCAND)) {
        if(BARRE_DEVIATION == 0) TEM = PERIOD_MN1;
        ORDERBLOCK(Symbol(), PERIOD_MN1, iBarShift(Symbol(), PERIOD_MN1, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(Symbol(), PERIOD_MN1, iBarShift(Symbol(), PERIOD_MN1, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, MN1SD, MN1LQ, MN1FV);
        ORDERBLOCKshowliq(Symbol(), PERIOD_MN1, iBarShift(Symbol(), PERIOD_MN1, iTime(Symbol(), TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1, MN1LQ, 1);
        FVGfunc(MN1FV, Symbol(), PERIOD_MN1, iBarShift(Symbol(), PERIOD_MN1, iTime(Symbol(), TEM, BARRE_DEVIATION)));
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_MN1", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_MN1", OBJPROP_BGCOLOR, clrOrangeRed);
        if(ALSYS == 1 && Period() == PERIOD_MN1) ALERTPOPUP(Symbol(), PERIOD_MN1, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);
    }
    if(CLOSE_ALL_AT_EQUITY != 0 && AccountEquity() <= CLOSE_ALL_AT_EQUITY) {
        CloseOrderALL(NULL);
    }
    if(CLOSE_ALL_AT_PROFIT != 0 && AccountProfit() >= CLOSE_ALL_AT_PROFIT) {
        CloseOrderALL(NULL);
    }

// === DRAWDOWN PROTECTION MONITORING ===
    if(MAX_DRAWDOWN_PERCENT > 0) {
        CheckDrawdownLimit();
    }

// Validate risk settings periodically (every new bar)
    static datetime lastRiskValidation = 0;
    if(iTime(Symbol(), Period(), 0) != lastRiskValidation) {
        ValidateAndUpdateRiskSettings();
        MonitorRiskUsage();
        lastRiskValidation = iTime(Symbol(), Period(), 0);
    }

    if(LAST_TF == 0) ObjectSetText("BUTXTD1_FIBO_", "NO FIRE", FONT_SIZE);
    else ObjectSetText("BUTXTD1_FIBO_", "FIRE ON TREND " + tftransformation(LAST_TF), FONT_SIZE);
    if(LAST_TF == 0) ObjectSetText("BUTXTD1_FIBOVS_", "NO FIRE", FONT_SIZE);
    else ObjectSetText("BUTXTD1_FIBOVS_", "FIRE COUNTERTREND " + tftransformation(LAST_TF), FONT_SIZE);
    if(STRA2 == 1) {
        if(ObjectFind(0, "DAILY_CANDLE1") < 0) {
            ObjectCreate(0, "DAILY_CANDLE2", OBJ_RECTANGLE, 0, 0, 0, 0, 0);
            ObjectSetInteger(0, "DAILY_CANDLE2", OBJPROP_BACK, true);
            ObjectSetInteger(0, "DAILY_CANDLE2", OBJPROP_HIDDEN, true);
            ObjectCreate(0, "DAILY_CANDLE2t", OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectSetInteger(0, "DAILY_CANDLE2t", OBJPROP_RAY, false);
            ObjectSetInteger(0, "DAILY_CANDLE2t", OBJPROP_HIDDEN, true);
            ObjectCreate(0, "DAILY_CANDLE1", OBJ_RECTANGLE, 0, 0, 0, 0, 0);
            ObjectSetInteger(0, "DAILY_CANDLE1", OBJPROP_BACK, true);
            ObjectSetInteger(0, "DAILY_CANDLE1", OBJPROP_HIDDEN, true);
            ObjectCreate(0, "DAILY_CANDLE1t", OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectSetInteger(0, "DAILY_CANDLE1t", OBJPROP_RAY, false);
            ObjectSetInteger(0, "DAILY_CANDLE1t", OBJPROP_HIDDEN, true);
            ObjectCreate(0, "DAILY_CANDLE0", OBJ_RECTANGLE, 0, 0, 0, 0, 0);
            ObjectSetInteger(0, "DAILY_CANDLE0", OBJPROP_BACK, true);
            ObjectSetInteger(0, "DAILY_CANDLE0", OBJPROP_HIDDEN, true);
            ObjectCreate(0, "DAILY_CANDLE0t", OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectSetInteger(0, "DAILY_CANDLE0t", OBJPROP_RAY, false);
            ObjectSetInteger(0, "DAILY_CANDLE0t", OBJPROP_HIDDEN, true);
        }
        else {
            double HIGH1 = 0;
            double LOW1 = 0;
            double HIGH0 = 0;
            double LOW0 = 0;
            int ST1 = iBarShift(SIM, 0, iTime(SIM, 1440, iBarShift(SIM, 1440, iTime(SIM, (int)GlobalVariableGet(SIM + "TFBARRE"), (int)GlobalVariableGet(SIM + "BARRE"))) + 1));
            int EN1 = iBarShift(SIM, 0, iTime(SIM, 1440, iBarShift(SIM, 1440, iTime(SIM, (int)GlobalVariableGet(SIM + "TFBARRE"), (int)GlobalVariableGet(SIM + "BARRE")))));
            if(iOpen(SIM, 1440, 2) < iClose(SIM, 1440, 2)) {
                ObjectSetInteger(0, "DAILY_CANDLE2", OBJPROP_COLOR, clrLimeGreen);
                ObjectSetInteger(0, "DAILY_CANDLE2t", OBJPROP_COLOR, clrLimeGreen);
            }
            if(iOpen(SIM, 1440, 2) > iClose(SIM, 1440, 2)) {
                ObjectSetInteger(0, "DAILY_CANDLE2", OBJPROP_COLOR, clrRed);
                ObjectSetInteger(0, "DAILY_CANDLE2t", OBJPROP_COLOR, clrRed);
            }
            if(iOpen(SIM, 1440, 1) < iClose(SIM, 1440, 1)) {
                ObjectSetInteger(0, "DAILY_CANDLE1", OBJPROP_COLOR, clrLimeGreen);
                ObjectSetInteger(0, "DAILY_CANDLE1t", OBJPROP_COLOR, clrLimeGreen);
            }
            if(iOpen(SIM, 1440, 1) > iClose(SIM, 1440, 1)) {
                ObjectSetInteger(0, "DAILY_CANDLE1", OBJPROP_COLOR, clrRed);
                ObjectSetInteger(0, "DAILY_CANDLE1t", OBJPROP_COLOR, clrRed);
            }
            if(iOpen(SIM, 1440, 0) < iClose(SIM, 1440, 0)) {
                ObjectSetInteger(0, "DAILY_CANDLE0", OBJPROP_COLOR, clrLimeGreen);
                ObjectSetInteger(0, "DAILY_CANDLE0t", OBJPROP_COLOR, clrLimeGreen);
            }
            if(iOpen(SIM, 1440, 0) > iClose(SIM, 1440, 0)) {
                ObjectSetInteger(0, "DAILY_CANDLE0", OBJPROP_COLOR, clrRed);
                ObjectSetInteger(0, "DAILY_CANDLE0t", OBJPROP_COLOR, clrRed);
            }
            datetime start2 = iTime(SIM, 0, 1) + 5 * PeriodSeconds();
            datetime end2 = iTime(SIM, 0, 1) + 7 * PeriodSeconds();
            ObjectMove(0, "DAILY_CANDLE2", 0, start2, iOpen(SIM, 1440, 2));
            ObjectMove(0, "DAILY_CANDLE2", 1, end2, iClose(SIM, 1440, 2));
            ObjectMove(0, "DAILY_CANDLE2t", 0, (start2 + end2) / 2, iHigh(SIM, 1440, 2));
            ObjectMove(0, "DAILY_CANDLE2t", 1, (start2 + end2) / 2, iLow(SIM, 1440, 2));
            datetime start1 = iTime(SIM, 0, 1) + 8 * PeriodSeconds();
            datetime end1 = iTime(SIM, 0, 1) + 10 * PeriodSeconds();
            ObjectMove(0, "DAILY_CANDLE1", 0, start1, iOpen(SIM, 1440, 1));
            ObjectMove(0, "DAILY_CANDLE1", 1, end1, iClose(SIM, 1440, 1));
            ObjectMove(0, "DAILY_CANDLE1t", 0, (start1 + end1) / 2, iHigh(SIM, 1440, 1));
            ObjectMove(0, "DAILY_CANDLE1t", 1, (start1 + end1) / 2, iLow(SIM, 1440, 1));
            datetime start0 = iTime(SIM, 0, 1) + 11 * PeriodSeconds();
            datetime end0 = iTime(SIM, 0, 1) + 13 * PeriodSeconds();
            ObjectMove(0, "DAILY_CANDLE0", 0, start0, iOpen(SIM, 1440, 0));
            ObjectMove(0, "DAILY_CANDLE0", 1, end0, iClose(SIM, 1440, 0));
            ObjectMove(0, "DAILY_CANDLE0t", 0, (start0 + end0) / 2, iHigh(SIM, 1440, 0));
            ObjectMove(0, "DAILY_CANDLE0t", 1, (start0 + end0) / 2, iLow(SIM, 1440, 0));
        }
    }
    else {
        if(ObjectFind(0, "DAILY_CANDLE1") >= 0) {
            ObjectDelete(0, "DAILY_CANDLE2");
            ObjectDelete(0, "DAILY_CANDLE2t");
            ObjectDelete(0, "DAILY_CANDLE1");
            ObjectDelete(0, "DAILY_CANDLE1t");
            ObjectDelete(0, "DAILY_CANDLE0");
            ObjectDelete(0, "DAILY_CANDLE0t");
        }
    }
    if(DASHBOARD == false) {
        if(ObjectFind(0, "PRICELINE") < 0) {
            ObjectCreate(0, "PRICELINE", OBJ_HLINE, 0, 0, 0);
            ObjectSetInteger(0, "PRICELINE", OBJPROP_HIDDEN, true);
        }
        ObjectMove(0, "PRICELINE", 0, 0, MarketInfo(Symbol(), MODE_BID));
        ObjectSetInteger(0, "PRICELINE", OBJPROP_COLOR, COLOR_BID);
        if(BARRE_DEVIATION != 0) {
            if(ObjectFind("START_CANDLE") != 0) {
                ObjectCreate(0, "START_CANDLE", OBJ_VLINE, 0, iTime(Symbol(), (int)GlobalVariableGet(Symbol() + "TFBARRE"), (int)GlobalVariableGet(Symbol() + "BARRE")), 0);
            }
            else {
                ObjectMove(0, "START_CANDLE", 0, iTime(Symbol(), (int)GlobalVariableGet(Symbol() + "TFBARRE"), (int)GlobalVariableGet(Symbol() + "BARRE")), 0);
                ObjectSetInteger(0, "START_CANDLE", OBJPROP_STYLE, STYLE_DOT);
                ObjectSetInteger(0, "START_CANDLE", OBJPROP_COLOR, clrViolet);
            }
        }
        else
            ObjectDelete("START_CANDLE");
    }
    if(BARRE_DEVIATION == 0) CURRCAND = 0;
    else CURRCAND = iBars(SIM, 0) - (iBars(SIM, 0) - iBarShift(SIM, 0, iTime(Symbol(), (int)GlobalVariableGet(Symbol() + "TFBARRE"), (int)GlobalVariableGet(Symbol() + "BARRE"))));
/// POPOLARE ORDERFLOW TABELLA
////////////// TP VALUE
    if(VEDILIVELLI != 0) {
        if(NOT(SIM, OP_SELL) != 0) {
            TAKEPROFIT_signature(SIM, OP_SELL);
            STOPLOSS_signature(SIM, OP_SELL);
            if(TAKEPROFIT_signature(SIM, OP_SELL) == 0) {
                int totalObjects = ObjectsTotal(0, 0, -1);
                for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                    if(StringSubstr(ObjectName(i), 0, 4) == "TPT" + (string)OP_SELL && IsTesting() == false) ObjectDelete(ObjectName(i));
                }
            }
            if(STOPLOSS_signature(SIM, OP_SELL) == 0) {
                int totalObjects = ObjectsTotal(0, 0, -1);
                for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                    if(StringSubstr(ObjectName(i), 0, 4) == "TPS" + (string)OP_SELL && IsTesting() == false) ObjectDelete(ObjectName(i));
                }
            }
        }
        else {
            int totalObjects = ObjectsTotal(0, 0, -1);
            for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                if(StringSubstr(ObjectName(i), 0, 4) == "TPT" + (string)OP_SELL && IsTesting() == false) ObjectDelete(ObjectName(i));
                if(StringSubstr(ObjectName(i), 0, 4) == "TPS" + (string)OP_SELL && IsTesting() == false) ObjectDelete(ObjectName(i));
            }
        }
        if(NOT(SIM, OP_BUY) != 0) {
            TAKEPROFIT_signature(SIM, OP_BUY);
            STOPLOSS_signature(SIM, OP_BUY);
            if(TAKEPROFIT_signature(SIM, OP_BUY) == 0) {
                int totalObjects = ObjectsTotal(0, 0, -1);
                for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                    if(StringSubstr(ObjectName(i), 0, 4) == "TPT" + (string)OP_BUY && IsTesting() == false) ObjectDelete(ObjectName(i));
                }
            }
            if(STOPLOSS_signature(SIM, OP_BUY) == 0) {
                int totalObjects = ObjectsTotal(0, 0, -1);
                for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                    if(StringSubstr(ObjectName(i), 0, 4) == "TPS" + (string)OP_BUY && IsTesting() == false) ObjectDelete(ObjectName(i));
                }
            }
        }
        else {
            int totalObjects = ObjectsTotal(0, 0, -1);
            for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                if(StringSubstr(ObjectName(i), 0, 4) == "TPT" + (string)OP_BUY && IsTesting() == false) ObjectDelete(ObjectName(i));
                if(StringSubstr(ObjectName(i), 0, 4) == "TPS" + (string)OP_BUY && IsTesting() == false) ObjectDelete(ObjectName(i));
            }
        }
///////////// END TP VALUE
/////////////  BEP LINE
        if(DASHBOARD == false) {
            if(NOT(SIM, OP_BUY) != 0) {
                ObjectCreate(0, "BEP_buy", OBJ_TREND, 0, 0, 0, 0, 0);
                ObjectSetInteger(0, "BEP_buy", OBJPROP_RAY, false);
                ObjectSetInteger(0, "BEP_buy", OBJPROP_COLOR, clrLightGray);
                ObjectSetInteger(0, "BEP_buy", OBJPROP_STYLE, STYLE_DOT);
                ObjectMove(0, "BEP_buy", 0, iTime(SIM, TFF, 1) + 60 * Period() * 2, TakeProfitUtilBUY(SIM));
                ObjectMove(0, "BEP_buy", 1, iTime(SIM, TFF, 1) + 60 * 60 * 24, TakeProfitUtilBUY(SIM));
            }
            else {
                if(ObjectFind(0, "BEP_buy") >= 0) ObjectDelete(0, "BEP_buy");
            }
            if(NOT(SIM, OP_SELL) != 0) {
                ObjectCreate(0, "BEP_sell", OBJ_TREND, 0, 0, 0, 0, 0);
                ObjectSetInteger(0, "BEP_sell", OBJPROP_RAY, false);
                ObjectSetInteger(0, "BEP_sell", OBJPROP_COLOR, clrLightGray);
                ObjectSetInteger(0, "BEP_sell", OBJPROP_STYLE, STYLE_DOT);
                ObjectMove(0, "BEP_sell", 0, iTime(SIM, TFF, 1) + 60 * Period() * 2, TakeProfitUtilSELL(SIM));
                ObjectMove(0, "BEP_sell", 1, iTime(SIM, TFF, 1) + 60 * 60 * 24, TakeProfitUtilSELL(SIM));
            }
            else {
                if(ObjectFind(0, "BEP_sell") >= 0) ObjectDelete(0, "BEP_sell");
            }
        }
///////////  END BEP LINE
    }
//ALERT
    if(ALERT_SYSTEMING == false && OWF == 9) {
        ALERT_SYSTEMING = GlobalVariableGet("ADMIN_ALERT_SYSTEM");
    }
    if(ALERT_SYSTEMING == true && AccountNumber() == 533674 && VOL > iVolume(SIM, SIGNAL_ENTRY, 0)) {
        if(HIDE_TD0 + HIDE_TD1 + HIDE_TD2 > 0) {
            HIDE_TD0 = 0;
            HIDE_TD1 = 0;
            HIDE_TD2 = 0;
            ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, 0);
            M1 = 0;
            M1SD = 0;
            M5 = 0;
            M5SD = 0;
            M15 = 0;
            M15SD = 0;
            M30 = 0;
            M30SD = 0;
            H1 = 0;
            H1SD = 0;
            H4 = 0;
            H4SD = 0;
            D1 = 0;
            D1SD = 0;
            W1 = 0;
            W1SD = 0;
            MN1 = 0;
            MN1SD = 0;
            GlobalVariableSet(Symbol() + "TD0", HIDE_TD0);
            GlobalVariableSet(Symbol() + "TD1", HIDE_TD1);
            GlobalVariableSet(Symbol() + "TD2", HIDE_TD2);
            SHOWHIDE(HIDE_TD0, "TD0");
            SHOWHIDE(HIDE_TD1, "TD1");
            SHOWHIDE(HIDE_TD2, "TD2");
            RILANCIAfun(0, SIM);
            STRA0 = 1;
            STRA5 = 1;
            GlobalVariableSet(Symbol() + "STRA0", STRA0);
            GlobalVariableSet(Symbol() + "STRA5", STRA5);
        }
        ORDERBLOCK(Symbol(), Period(), 0, 1, 0, 1);
        ORDERBLOCKshow(Symbol(), Period(), 0, 1, 0, 1, 0, 0);
        int FLUX = 0;
        FLUX = ALERT_PUSH(SIM, Period(), 0, 0, SIGNAL_ENTRY, 0, 0);
    }
//END ALERT
    if(DASHBOARD == true) {
        if(GlobalVariableGet("SCANNERHTF") != 0) HTF = (int)GlobalVariableGet("SCANNERHTF");
        else GlobalVariableSet("SCANNERHTF", HTF);
        int LTF = SIGNAL_ENTRY;
        if(GlobalVariableGet("SCANNERTFL") != 0) TFL = (int)GlobalVariableGet("SCANNERTFL");
        else GlobalVariableSet("SCANNERTFL", TFL);
        int BSSCHOCH = 0;
        if(GlobalVariableGet("SCANNERBSSCHOCH") != 0) BSSCHOCH = (int)GlobalVariableGet("SCANNERBSSCHOCH");
        else GlobalVariableSet("SCANNERBSSCHOCH", BSSCHOCH);
        int totalObjects = ObjectsTotal(0, 0, -1);
        for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
            if(StringSubstr(ObjectName(i), 0, 13) == "BUTT_SCANNER_") {
                if(tftransformation(HTF) == StringSubstr(ObjectName(i), 13, 0)) {
                    ObjectSetInteger(0, ObjectName(i), OBJPROP_STATE, true);
                    ObjectSetInteger(0, ObjectName(i), OBJPROP_BGCOLOR, clrYellow);
                }
                else {
                    ObjectSetInteger(0, ObjectName(i), OBJPROP_STATE, false);
                    ObjectSetInteger(0, ObjectName(i), OBJPROP_BGCOLOR, clrLightGray);
                }
            }
            if(StringSubstr(ObjectName(i), 0, 16) == "BUTT_SCANNER_LTF") {
                if(tftransformation(TFL) == StringSubstr(ObjectName(i), 16, 0)) {
                    ObjectSetInteger(0, ObjectName(i), OBJPROP_STATE, true);
                    ObjectSetInteger(0, ObjectName(i), OBJPROP_BGCOLOR, clrYellow);
                }
                else {
                    ObjectSetInteger(0, ObjectName(i), OBJPROP_STATE, false);
                    ObjectSetInteger(0, ObjectName(i), OBJPROP_BGCOLOR, clrLightGray);
                }
            }
            if(ObjectName(i) == "BUTT_SCANNER_BSSCHOCH") {
                if(BSSCHOCH != 0) {
                    ObjectSetInteger(0, ObjectName(i), OBJPROP_STATE, true);
                    ObjectSetInteger(0, ObjectName(i), OBJPROP_BGCOLOR, clrYellow);
                }
                else {
                    ObjectSetInteger(0, ObjectName(i), OBJPROP_STATE, false);
                    ObjectSetInteger(0, ObjectName(i), OBJPROP_BGCOLOR, clrLightGray);
                }
            }
        }
        VEDILIVELLI = 0;
        ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, VEDILIVELLI);
        string VETTORE = PAIRS;
        string PAIR[];
        while(VETTORE != "") {
            ArrayResize(PAIR, ArraySize(PAIR) + 1);
            int POS = 0;
            POS = StringFind(VETTORE, ",", 0);
            if(StringFind(VETTORE, ",", 0) != -1) {
                POS = StringFind(VETTORE, ",", 0);
                PAIR[ArraySize(PAIR) - 1] = PREFIX + StringSubstr(VETTORE, 0, POS) + SUFFIX;
                VETTORE = StringSubstr(VETTORE, POS + 1, 0);
            }
            else if (VETTORE != "") {
                POS = StringLen(VETTORE);
                PAIR[ArraySize(PAIR) - 1] = PREFIX + StringSubstr(VETTORE, 0, 0) + SUFFIX;
                VETTORE = "";
            }
        }
        static int LARGHEZZA = (int)(ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0));
        int COLONNA = LARGHEZZA / 8;
        int RIGA = FONT_SIZE * 2;
        string VALUTE[];
        ArrayCopy(VALUTE, PAIR, 0, 0, WHOLE_ARRAY);
        int MAXVAL = ArraySize(PAIR);
        if(Period() != LTF) {
            Alert("Please use the timeframe you choose on SIGNAL_ENTRY settings : " + tftransformation(SIGNAL_ENTRY));
            MAXVAL = 0;
        }
//INTESTAZIONE
        Create_Button(0, "REFRESH", 0, 10, 0, 100, 20, CORNER_LEFT_UPPER, "REFRESH", clrWhite);
        Create_Button(0, "SYMBOL", 0, 10, 20, 100, 40, CORNER_LEFT_UPPER, "SYMBOLS", clrWhite);
        EditCreate(0, "BIAS_label", 0, DASHDISTX("SYMBOL"), 20 * ZOOM_PIXEL, 200 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "DIRECTIONAL BIAS " + tftransformation(HTF), "Arial", FONT_SIZE, ALIGN_CENTER, true);
        EditCreate(0, "FOOTER", 0, (int)ObjectGetInteger(0, "SYMBOL", OBJPROP_XDISTANCE), 40 + 20 * (MAXVAL + 2)*ZOOM_PIXEL, 200 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "", "Arial", FONT_SIZE, ALIGN_LEFT, false);
        EditTextChange(0, "FOOTER", vers, clrWhite, clrBlack);
        EditCreate(0, "FOOTERexp", 0, (int)ObjectGetInteger(0, "FOOTER", OBJPROP_XDISTANCE), 40 + 20 * (MAXVAL + 3)*ZOOM_PIXEL, 200 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "", "Arial", FONT_SIZE, ALIGN_LEFT, false);
        EditTextChange(0, "FOOTERexp", "Scanner License ends on ", clrWhite, clrBlack);
        if(ObjectFind("BUTT_SCANNER_M15") < 0) {
            GlobalVariableSet("SCANNERALERT", 0);
            GlobalVariableSet("SCANNERALERTMOBILE", 0);
            Create_Button(0, "BUTT_ALERTSCANNER_MT", 0, (int)ObjectGetInteger(0, "FOOTER", OBJPROP_XDISTANCE) + (int)ObjectGetInteger(0, "FOOTER", OBJPROP_XSIZE) / ZOOM_PIXEL, (int)ObjectGetInteger(0, "FOOTER", OBJPROP_YDISTANCE) / ZOOM_PIXEL, 100, 20, CORNER_LEFT_UPPER, "Alert Scanner off", clrLightGray);
            Create_Button(0, "BUTT_ALERTSCANNER_MOBILE", 0, (int)ObjectGetInteger(0, "BUTT_ALERTSCANNER_MT", OBJPROP_XDISTANCE) / ZOOM_PIXEL + (int)ObjectGetInteger(0, "BUTT_ALERTSCANNER_MT", OBJPROP_XSIZE) / ZOOM_PIXEL, (int)ObjectGetInteger(0, "BUTT_ALERTSCANNER_MT", OBJPROP_YDISTANCE) / ZOOM_PIXEL, 100, 20, CORNER_LEFT_UPPER, "Alert Mobile off", clrLightGray);
            Create_Button(0, "BUTT_SCANNER_M15", 0, (int)ObjectGetInteger(0, "BIAS_label", OBJPROP_XDISTANCE) / ZOOM_PIXEL, 0, 56, 20, CORNER_LEFT_UPPER, "M15", clrLightGray);
            Create_Button(0, "BUTT_SCANNER_M30", 0, DASHDISTX("BUTT_SCANNER_M15") / ZOOM_PIXEL, 0, 56, 20, CORNER_LEFT_UPPER, "M30", clrLightGray);
            Create_Button(0, "BUTT_SCANNER_H1", 0, DASHDISTX("BUTT_SCANNER_M30") / ZOOM_PIXEL, 0, 56, 20, CORNER_LEFT_UPPER, "H1", clrLightGray);
            Create_Button(0, "BUTT_SCANNER_H4", 0, DASHDISTX("BUTT_SCANNER_H1") / ZOOM_PIXEL, 0, 56, 20, CORNER_LEFT_UPPER, "H4", clrLightGray);
            Create_Button(0, "BUTT_SCANNER_D1", 0, DASHDISTX("BUTT_SCANNER_H4") / ZOOM_PIXEL, 0, 56, 20, CORNER_LEFT_UPPER, "D1", clrLightGray);
        }
        EditTextChange(0, "BIAS_label", "DIRECTIONAL BIAS " + tftransformation(HTF), clrBlack, clrWhite);
        EditCreate(0, "AGE_label", 0, DASHDISTX("SYMBOL"), 40 * ZOOM_PIXEL, 40 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "S", "Arial", FONT_SIZE, ALIGN_CENTER, true);
        EditCreate(0, "AGEok_label", 0, DASHDISTX("AGE_label"), 40 * ZOOM_PIXEL, 40 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "V", "Arial", FONT_SIZE, ALIGN_CENTER, true);
        EditCreate(0, "LEG_label", 0, DASHDISTX("AGEok_label"), 40 * ZOOM_PIXEL, 120 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "LEG INFO", "Arial", FONT_SIZE, ALIGN_CENTER, true);
        EditCreate(0, "TREND_label", 0, DASHDISTX("BIAS_label"), 20 * ZOOM_PIXEL, 500 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "ON TREND", "Arial", FONT_SIZE, ALIGN_CENTER, true);
        EditCreate(0, "SS_label", 0, DASHDISTX("BIAS_label"), 40 * ZOOM_PIXEL, 250 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "SS", "Arial", FONT_SIZE, ALIGN_CENTER, true);
        EditCreate(0, "SSperc_label", 0, DASHDISTX("SS_label"), 40 * ZOOM_PIXEL, 50 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "%", "Arial", FONT_SIZE, ALIGN_CENTER, true);
        EditCreate(0, "SOB_label", 0, DASHDISTX("SSperc_label"), 40 * ZOOM_PIXEL, 120 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "POI", "Arial", FONT_SIZE, ALIGN_LEFT, true);
        EditCreate(0, "EQUO_label", 0, DASHDISTX("SOB_label"), 40 * ZOOM_PIXEL, 80 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "EQUILIBRIUM", "Arial", FONT_SIZE, ALIGN_CENTER, true);
        EditCreate(0, "BSS_LTF", 0, DASHDISTX("EQUO_label"), 20 * ZOOM_PIXEL, 120 * ZOOM_PIXEL, 40 * ZOOM_PIXEL, "LTF " + tftransformation(LTF), "Arial", FONT_SIZE, ALIGN_CENTER, true);
        EditCreate(0, "COUNTERTREND_label", 0, DASHDISTX("BSS_LTF"), 20 * ZOOM_PIXEL, 200 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "VS TREND", "Arial", FONT_SIZE, ALIGN_CENTER, true);
        EditCreate(0, "SOBrev_label", 0, DASHDISTX("BSS_LTF"), 40 * ZOOM_PIXEL, 120 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "POI", "Arial", FONT_SIZE, ALIGN_LEFT, true);
        EditCreate(0, "EQUOVS_label", 0, DASHDISTX("SOBrev_label"), 40 * ZOOM_PIXEL, 80 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "EQUILIBRIUM", "Arial", FONT_SIZE, ALIGN_CENTER, true);
        EditCreate(0, "VSBSS_LTF", 0, DASHDISTX("EQUOVS_label"), 20 * ZOOM_PIXEL, 120 * ZOOM_PIXEL, 40 * ZOOM_PIXEL, "VS LTF " + tftransformation(LTF), "Arial", FONT_SIZE, ALIGN_CENTER, true);
        EditCreate(0, "AI_label", 0, DASHDISTX("VSBSS_LTF"), 20 * ZOOM_PIXEL, 400 * ZOOM_PIXEL, 40 * ZOOM_PIXEL, "AI", "Arial", FONT_SIZE, ALIGN_CENTER, true);
        if(ObjectFind("BUTT_SCANNER_LTFM1") < 0) {
            Create_Button(0, "BUTT_SCANNER_LTFM1", 0, DASHDISTX("TREND_label"), 0, 30, 20, CORNER_LEFT_UPPER, "M1", clrLightGray);
            Create_Button(0, "BUTT_SCANNER_LTFM5", 0, DASHDISTX("BUTT_SCANNER_LTFM1") / ZOOM_PIXEL, 0, 30, 20, CORNER_LEFT_UPPER, "M5", clrLightGray);
            Create_Button(0, "BUTT_SCANNER_LTFM15", 0, DASHDISTX("BUTT_SCANNER_LTFM5") / ZOOM_PIXEL, 0, 30, 20, CORNER_LEFT_UPPER, "M15", clrLightGray);
            Create_Button(0, "BUTT_SCANNER_BSSCHOCH", 0, DASHDISTX("BUTT_SCANNER_LTFM15") / ZOOM_PIXEL, 0, 30, 20, CORNER_LEFT_UPPER, "X", clrLightGray);
        }
        string cosasei = " BSS";
        if(BSSCHOCH != 0) cosasei = " CHoCH";
        EditTextChange(0, "BSS_LTF", "LTF " + tftransformation(TFL) + cosasei, clrBlack, clrWhite);
        EditTextChange(0, "VSBSS_LTF", "VS LTF " + tftransformation(TFL) + cosasei, clrBlack, clrWhite);
//FINE INTESTAZIONE
        int STAVOLTA = 0;
        if(PRIMOAVVIO == 1) STAVOLTA = 1;
        for(int VOLTA = 0; VOLTA <= STAVOLTA; VOLTA++) {
            for(int i = 0; i < MAXVAL; i++) {
                string SIMBA = VALUTE[i];
                if(ObjectFind(0, "OPEN_" + SIMBA) < 0) Create_Button(0, "OPEN_" + SIMBA, 0, 10, 40 + 20 * (i + 1), 100, 20, CORNER_LEFT_UPPER, SIMBA, clrLightGray);
                if(ObjectFind(0, "UPDATE") < 0) RectLabelCreate(0, "UPDATE", 0, 0, 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL, 10 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, clrLimeGreen, BORDER_FLAT, CORNER_LEFT_UPPER, clrLimeGreen, STYLE_SOLID);
                EditCreate(0, "AIg" + (string)i, 0, (int)ObjectGetInteger(0, "AI_label", OBJPROP_XDISTANCE), 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL, 60 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "", "Wingdings", FONT_SIZE, ALIGN_CENTER, true);
                EditCreate(0, "AI" + (string)i, 0, DASHDISTX("AIg" + (string)i), 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL, (int)(ObjectGetInteger(0, "AI_label", OBJPROP_XSIZE) - ObjectGetInteger(0, "AIg" + (string)i, OBJPROP_XSIZE)), 20 * ZOOM_PIXEL, "", "Arial", FONT_SIZE, ALIGN_LEFT, true);
                EditCreate(0, "AGE" + (string)i, 0, (int)ObjectGetInteger(0, "AGE_label", OBJPROP_XDISTANCE), 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL, (int)ObjectGetInteger(0, "AGE_label", OBJPROP_XSIZE), 20 * ZOOM_PIXEL, "", "Arial", FONT_SIZE, ALIGN_CENTER, true);
                EditCreate(0, "AGEok" + (string)i, 0, (int)ObjectGetInteger(0, "AGEok_label", OBJPROP_XDISTANCE), 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL, (int)ObjectGetInteger(0, "AGE_label", OBJPROP_XSIZE), 20 * ZOOM_PIXEL, "", "Arial", FONT_SIZE, ALIGN_CENTER, true);
                EditCreate(0, "LEG" + (string)i, 0, (int)ObjectGetInteger(0, "LEG_label", OBJPROP_XDISTANCE), 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL, (int)ObjectGetInteger(0, "LEG_label", OBJPROP_XSIZE), 20 * ZOOM_PIXEL, "", "Arial", FONT_SIZE, ALIGN_LEFT, true);
                EditCreate(0, "SOB" + (string)i, 0, (int)ObjectGetInteger(0, "SOB_label", OBJPROP_XDISTANCE), 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL, (int)ObjectGetInteger(0, "SOB_label", OBJPROP_XSIZE), 20 * ZOOM_PIXEL, "", "Arial", FONT_SIZE, ALIGN_LEFT, true);
                EditCreate(0, "SS" + (string)i, 0, (int)ObjectGetInteger(0, "SS_label", OBJPROP_XDISTANCE), 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL, (int)ObjectGetInteger(0, "SS_label", OBJPROP_XSIZE), 20 * ZOOM_PIXEL, "", "Arial", FONT_SIZE, ALIGN_LEFT, true);
                EditCreate(0, "SSperc" + (string)i, 0, (int)ObjectGetInteger(0, "SSperc_label", OBJPROP_XDISTANCE), 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL, (int)ObjectGetInteger(0, "SSperc_label", OBJPROP_XSIZE), 20 * ZOOM_PIXEL, "", "Arial", FONT_SIZE, ALIGN_CENTER, true);
                EditCreate(0, "SOBrev" + (string)i, 0, (int)ObjectGetInteger(0, "SOBrev_label", OBJPROP_XDISTANCE), 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL, (int)ObjectGetInteger(0, "SOBrev_label", OBJPROP_XSIZE), 20 * ZOOM_PIXEL, "", "Arial", FONT_SIZE, ALIGN_LEFT, true);
                EditCreate(0, "EQUO" + (string)i, 0, (int)ObjectGetInteger(0, "EQUO_label", OBJPROP_XDISTANCE), 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL, (int)ObjectGetInteger(0, "EQUO_label", OBJPROP_XSIZE), 20 * ZOOM_PIXEL, "", "Arial", FONT_SIZE, ALIGN_CENTER, true);
                EditCreate(0, "BSS_LTF" + (string)i, 0, (int)ObjectGetInteger(0, "BSS_LTF", OBJPROP_XDISTANCE), 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL, 120 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "", "Arial", FONT_SIZE, ALIGN_CENTER, true);
                EditCreate(0, "EQUOVS" + (string)i, 0, (int)ObjectGetInteger(0, "EQUOVS_label", OBJPROP_XDISTANCE), 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL, (int)ObjectGetInteger(0, "EQUOVS_label", OBJPROP_XSIZE), 20 * ZOOM_PIXEL, "", "Arial", FONT_SIZE, ALIGN_CENTER, true);
                EditCreate(0, "VSBSS_LTF" + (string)i, 0, (int)ObjectGetInteger(0, "VSBSS_LTF", OBJPROP_XDISTANCE), 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL, 120 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, "", "Arial", FONT_SIZE, ALIGN_CENTER, true);
                if(DASHBOARD == true && (VOL > iVolume(SIM, SIGNAL_ENTRY, 0) || PRIMOAVVIO == 1)) {
                    if(i == (MAXVAL - 1) && VOLTA == STAVOLTA) PRIMOAVVIO = 0;
                    RectLabelMove(0, "UPDATE", 0, 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL);
                    GlobalVariableSet(SIMBA + "BREAK_AT_EXTREME", 0);
                    GlobalVariableSet(SIMBA + "STRA5", 1);
                    ORDERBLOCK(SIMBA, HTF, 0, 0, 0, 1);
                    ORDERBLOCKshow(SIMBA, HTF, 0, 0, 0, 1, 0, 0);
                    int FLOWK = LAST_FLOW;
                    RectLabelMove(0, "UPDATE", 0, 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL);
                    if(VOLTA == STAVOLTA) {
                        int BREAKERLEG = 0;
                        int CHOCHorBOS = 0;
                        int LSBSUBSTRUCTURE = 0;
                        string LSBPREMDIS = "";
                        int SUPDEM_mitigated = 0;
                        int SUPDEMOPP_mitigated = 0;
                        string SOURCE = "";
                        string AGE = "";
                        string AGEok = "";
                        int SOURCE_colour = clrWhite;
                        int AGE_colour = clrWhite;
                        int AGEok_colour = clrWhite;
                        if(FLOWK == 1) {
                            SOURCE = "Bullish";
                            AGE = (string)(iBars(SIMBA, HTF) - LAST_LL);
                            AGE_colour = clrGreen;
                            if(LAST_LEG0flow > 1) AGE_colour = clrWhite;
                            AGEok = iBars(SIMBA, HTF) - LAST_BREAKER;
                            if(AGEok == 1) {
                                AGE_colour = clrBlack;
                                AGEok_colour = clrYellow;
                                BREAKERLEG = 1;
                            }
                        }
                        if(FLOWK == 2) {
                            SOURCE = "Bearish";
                            AGE = (iBars(SIMBA, HTF) - LAST_HH);
                            AGE_colour = clrRed;
                            if(LAST_LEG0flow > 1) AGE_colour = clrWhite;
                            AGEok = iBars(SIMBA, HTF) - LAST_BREAKER;
                            if(AGEok == 1) {
                                AGE_colour = clrBlack;
                                AGEok_colour = clrYellow;
                                BREAKERLEG = 1;
                            }
                        }
// CONTEGGIO LEG
                        string LEG = "CHoCH";
                        string MINOR = "";
                        int LEG_colour = clrBlack;
                        int LEG_colour_bg = clrLightYellow;
                        CHOCHorBOS = 1;
                        if(LAST_LEG0flow > 1) {
                            LEG = "BOS n°" + (LAST_LEG0flow - 1);
                            CHOCHorBOS = 2;
                        }
                        if(FLOWK == 1) {
                            LEG_colour = clrGreen;
                            LEG = "Bullish " + LEG;
                        }
                        if(FLOWK == 2) {
                            LEG_colour = clrRed;
                            LEG = "Bearish " + LEG;
                        }
                        if(FLOWK == 1 && LAST_LEG0flow > 1) {
                            LEG_colour = clrWhite;
                            LEG_colour_bg = clrGreen;
                            if(iLow(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_LL) > LAST_EQ) MINOR = "Minor ";
                        }
                        if(FLOWK == 2 && LAST_LEG0flow > 1) {
                            LEG_colour = clrWhite;
                            LEG_colour_bg = clrRed;
                            if(iHigh(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_HH) < LAST_EQ) MINOR = "Minor ";
                        }
                        LEG = MINOR + LEG;
                        EditTextChange(0, "LEG" + i, LEG, LEG_colour, LEG_colour_bg);
// FINE CONTEGGIO LEG
// SOURCE O POI MITIGATO
                        int eqmit = -1;
                        if(LAST_RTO != -1) eqmit = iBars(SIMBA, HTF) - LAST_RTO;
                        if(eqmit != -1) EditTextChange(0, "EQUO" + i, (string)eqmit, clrBlack, clrYellow);
                        else EditTextChange(0, "EQUO" + i, "", clrBlack, clrWhite);
                        string SOURCE_mitigated = "";
                        int SOURCE_mitigated_colour = clrWhite;
                        int SOURCE_mitigated_colour_bg = clrWhite;
                        if(LAST_RTS != -1) {
                            SOURCE_mitigated = "Mitigated " + (iBars(SIMBA, HTF) - LAST_RTS);
                            if(iBars(SIMBA, HTF) - LAST_RTS != -1) {
                                if(FLOWK == 1) SOURCE_mitigated_colour_bg = clrGreen;
                                else if(FLOWK == 2) SOURCE_mitigated_colour_bg = clrRed;
                                if(iBars(SIMBA, HTF) - LAST_RTS <= 1) {
                                    SOURCE_mitigated_colour_bg = clrYellow;
                                    SOURCE_mitigated_colour = clrBlack;
                                    SUPDEM_mitigated = 1;
                                }
                            }
                        }
                        EditTextChange(0, "AGE" + i, AGE, AGE_colour, LEG_colour_bg);
                        if(BREAKERLEG == 1) {
                            if(LAST_LEG0flow > 1) EditTextChange(0, "AGEok" + i, AGEok, AGE_colour, AGEok_colour);
                            else EditTextChange(0, "AGEok" + i, AGEok, AGE_colour, clrYellow);
                        }
                        else EditTextChange(0, "AGEok" + i, AGEok, AGE_colour, LEG_colour_bg);
                        if(LAST_LEG0flow > 1) {
                            ObjectSetInteger(0, "OPEN_" + SIMBA, OBJPROP_BGCOLOR, LEG_colour_bg);
                            ObjectSetInteger(0, "OPEN_" + SIMBA, OBJPROP_COLOR, clrWhite);
                        }
                        else {
                            ObjectSetInteger(0, "OPEN_" + SIMBA, OBJPROP_BGCOLOR, LEG_colour_bg);
                            ObjectSetInteger(0, "OPEN_" + SIMBA, OBJPROP_COLOR, clrBlack);
                        }
                        EditTextChange(0, "SOB" + i, SOURCE_mitigated, SOURCE_mitigated_colour, SOURCE_mitigated_colour_bg);
// END SOURCE O POI MITIGATO
// MITIGATI OPPOSTI
                        int ESISTO = 0;
                        if(FLOWK == 1 && LAST_HH_SUPPLY != 0) ESISTO = 1;
                        if(FLOWK == 2 && LAST_LL_DEMAND != 0) ESISTO = 1;
                        string SOBopp_mitigated = "";
                        int SOBopp_mitigated_colour_bg = clrWhite;
                        int SOBopp_mitigated_colour = clrWhite;
                        int vseqmit = -1;
                        if(ESISTO == 1) {
                            if(FLOWK == 1 && LAST_RTO_CHECK > LAST_LL) vseqmit = iBars(SIMBA, HTF) - LAST_RTO_CHECK;
                            if(FLOWK == 2 && LAST_RTO_CHECK > LAST_HH) vseqmit = iBars(SIMBA, HTF) - LAST_RTO_CHECK;
                        }
                        if(vseqmit != -1) EditTextChange(0, "EQUOVS" + i, vseqmit, clrBlack, clrYellow);
                        else EditTextChange(0, "EQUOVS" + i, "", clrBlack, clrWhite);
                        if(LAST_RTS_CHECK != -1 && ESISTO == 1) {
                            SOBopp_mitigated = "Mitigated " + (iBars(SIMBA, HTF) - LAST_RTS_CHECK);
                            if(LAST_LEG0flow == 1) SOBopp_mitigated = "LiqPool - Mitigated " + (iBars(SIMBA, HTF) - LAST_RTS_CHECK);
                            if(FLOWK == 1) SOBopp_mitigated_colour_bg = clrRed;
                            if(FLOWK == 2) SOBopp_mitigated_colour_bg = clrGreen;
                            if(iBars(SIMBA, HTF) - LAST_RTS_CHECK <= 1) {
                                SOBopp_mitigated_colour = clrBlack;
                                SOBopp_mitigated_colour_bg = clrYellow;
                                SUPDEMOPP_mitigated = 1;
                            }
                        }
                        EditTextChange(0, "SOBrev" + i, SOBopp_mitigated, SOBopp_mitigated_colour, SOBopp_mitigated_colour_bg);
// FINE MITIGATI OPPOSTI
// BSS
                        string BSSstatus = "";
                        if(LSBBROKENYES == 0 && LSBSOURCEMITIGATED == 0) {
                            int SS_colour = clrWhite;
                            BSSstatus = "";
                            EditTextChange(0, "SS" + i, BSSstatus, clrBlack, SS_colour);
                        }
                        if(LSBBROKENYES == 0 && LSBSOURCEMITIGATED != 0) {
                            int SS_colour = clrWhite;
                            int SS_colour_bg = clrWhite;
                            if(FLOWK == 1) {
                                SS_colour = clrRed;
                                BSSstatus = "SubSupply Mitigated " + LSBSOURCEMITIGATED;
                            }
                            if(FLOWK == 2) {
                                SS_colour = clrGreen;
                                BSSstatus = "SubDemand Mitigated " + LSBSOURCEMITIGATED;
                            }
                            if(LSBSOURCEMITIGATED <= 1) {
                                SS_colour = clrBlack;
                                SS_colour_bg = clrYellow;
                                SS_colour = clrBlack;
                            }
                            EditTextChange(0, "SS" + i, BSSstatus, SS_colour, SS_colour_bg);
                            if(LSBSOURCEMITIGATED <= 1) LSBSUBSTRUCTURE = 1;
                        }
                        if(LSBBROKENYES != 0 && LSBSOURCEMITIGATED == 0) {
                            int SS_colour = clrWhite;
                            int SS_colour_bg = clrWhite;
                            if(FLOWK == 1) {
                                BSSstatus = "SubSupply broken " + LSBBROKENYES;
                                SS_colour_bg = clrGreen;
                            }
                            if(FLOWK == 2) {
                                BSSstatus = "SubDemand broken " + LSBBROKENYES;
                                SS_colour_bg = clrRed;
                            }
                            EditTextChange(0, "SS" + i, BSSstatus, SS_colour, SS_colour_bg);
                            double WHERE = 0;
                            if(FLOWK == 1) WHERE = 100 * (1 - (iHigh(SIMBA, HTF, iBars(SIMBA, HTF) - LSBSOURCE) - iLow(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_LL)) / (iHigh(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_HH) - iLow(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_LL)));
                            if(FLOWK == 2) WHERE = 100 * (iHigh(SIMBA, HTF, iBars(SIMBA, HTF) - LSBSOURCE) - iLow(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_LL)) / (iHigh(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_HH) - iLow(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_LL));
                            string WHEREtext = DoubleToStr(WHERE, 0);
                            EditTextChange(0, "SSperc" + i, WHEREtext + "%", SS_colour, SS_colour_bg);
                            if(LSBBROKENYES == 1) {
                                LSBSUBSTRUCTURE = 2;
                                LSBPREMDIS = WHEREtext;
                            }
                        }
                        if(LSBBROKENYES != 0 && LSBSOURCEMITIGATED != 0) {
                            int SS_colour = clrWhite;
                            int SS_colour_bg = clrWhite;
                            if(FLOWK == 1) {
                                BSSstatus = "SubSup broken " + LSBBROKENYES + " + SubDem Mitigated " + LSBSOURCEMITIGATED;
                                SS_colour_bg = clrGreen;
                            }
                            if(FLOWK == 2) {
                                BSSstatus = "SubDem broken " + LSBBROKENYES + " + SubSup Mitigated " + LSBSOURCEMITIGATED;
                                SS_colour_bg = clrRed;
                            }
                            EditTextChange(0, "SS" + i, BSSstatus, SS_colour, SS_colour_bg);
                            double WHERE = 0;
                            if(FLOWK == 1) WHERE = 100 * (1 - (iHigh(SIMBA, HTF, iBars(SIMBA, HTF) - LSBSOURCE) - iLow(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_LL)) / (iHigh(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_HH) - iLow(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_LL)));
                            if(FLOWK == 2) WHERE = 100 * (iHigh(SIMBA, HTF, iBars(SIMBA, HTF) - LSBSOURCE) - iLow(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_LL)) / (iHigh(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_HH) - iLow(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_LL));
                            string WHEREtext = DoubleToStr(WHERE, 0);
                            EditTextChange(0, "SSperc" + i, WHEREtext + "%", SS_colour, SS_colour_bg);
                            if(LSBSOURCEMITIGATED <= 1) {
                                LSBSUBSTRUCTURE = 3;
                                LSBPREMDIS = WHEREtext;
                            }
                        }
// END BSS
/// GESTIONE SECOND TF
                        double EQUO = EQUILIBRIUM(SIMBA, HTF, LAST_HH, LAST_LL);
                        int HHH = iBars(SIMBA, TFL) - iBarShift(SIMBA, TFL, iTime(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_HH));
                        int LLL = iBars(SIMBA, TFL) - iBarShift(SIMBA, TFL, iTime(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_LL));
                        int BMSSS = LAST_BMS;
                        int BMSSSbreak = LAST_BMSbreak;
                        double WHERElevel = 0;
                        WHERElevel = iHigh(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_HH) - iLow(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_LL);
                        string ALLARMATOLTF = "";
                        int TOSENDLTF = 0;
                        int M1LSB = LSBfuncBSS(SIMBA, TFL, HHH, LLL, BMSSS, BMSSSbreak, FLOWK, 0, 0, BSSCHOCH);
                        if(BSSLSBBROKENYES != 0) {
                            if(FLOWK == 1) {
                                if(iLow(SIMBA, TFL, iBars(SIMBA, TFL) - BSSLSBSOURCE) < EQUO) {
                                    double BARRAlevel = 100 * ((iHigh(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_HH) - iLow(SIMBA, TFL, iBars(SIMBA, TFL) - BSSLSBSOURCE)) / WHERElevel);
                                    string BARRAleveltxt = " [" + DoubleToStr(BARRAlevel, 0) + "%]";
                                    if(BARRAlevel > 100) BARRAleveltxt = " [100+%]";
                                    if(BSSLSBSOURCEMITIGATED == 0) {
                                        int BARRA = iBarShift(SIMBA, HTF, iTime(SIMBA, TFL, BSSLSBBROKENYES));
                                        string BARRAtext = BARRA + BARRAleveltxt;
                                        EditTextChange(0, "BSS_LTF" + i, BARRAtext, clrBlack, clrLightYellow);
                                        ALLARMATOLTF = tftransformation(HTF) + " " + LEG + " : " + tftransformation(TFL) + " BSS+ " + cosasei + " " + BARRAtext;
                                        if(iBarShift(SIMBA, SIGNAL_ENTRY, iTime(SIMBA, TFL, BSSLSBBROKENYES)) == 1) TOSENDLTF = 1;
                                    }
                                    else {
                                        int BARRA = iBarShift(SIMBA, HTF, iTime(SIMBA, TFL, BSSLSBSOURCEMITIGATED));
                                        string BARRAtext = BARRA + BARRAleveltxt;
                                        EditTextChange(0, "BSS_LTF" + i, BARRAtext, clrWhite, clrGreen);
                                        ALLARMATOLTF = tftransformation(HTF) + " " + LEG + " : " + tftransformation(TFL) + " BSS+ " + cosasei + " mitigated " + BARRAtext;
                                        if(iBarShift(SIMBA, SIGNAL_ENTRY, iTime(SIMBA, TFL, BSSLSBSOURCEMITIGATED)) == 1) TOSENDLTF = 1;
                                    }
                                }
                            }
                            if(FLOWK == 2) {
                                if(iHigh(SIMBA, TFL, iBars(SIMBA, TFL) - BSSLSBSOURCE) > EQUO) {
                                    double BARRAlevel = 100 * ((iHigh(SIMBA, TFL, iBars(SIMBA, TFL) - BSSLSBSOURCE) - iLow(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_LL)) / WHERElevel);
                                    if(BARRAlevel > 100) BARRAlevel = 100;
                                    string BARRAleveltxt = " [" + DoubleToStr(BARRAlevel, 0) + "%]";
                                    if(BARRAlevel > 100) BARRAleveltxt = " [100+%]";
                                    if(BSSLSBSOURCEMITIGATED == 0) {
                                        int BARRA = iBarShift(SIMBA, HTF, iTime(SIMBA, TFL, BSSLSBBROKENYES));
                                        string BARRAtext = BARRA + BARRAleveltxt;
                                        EditTextChange(0, "BSS_LTF" + i, BARRAtext, clrBlack, clrLightYellow);
                                        ALLARMATOLTF = tftransformation(HTF) + " " + LEG + " : " + tftransformation(TFL) + " BSS- " + cosasei + " " + BARRAtext;
                                        if(iBarShift(SIMBA, SIGNAL_ENTRY, iTime(SIMBA, TFL, BSSLSBBROKENYES)) == 1) TOSENDLTF = 1;
                                    }
                                    else {
                                        int BARRA = iBarShift(SIMBA, HTF, iTime(SIMBA, TFL, BSSLSBSOURCEMITIGATED));
                                        string BARRAtext = BARRA + BARRAleveltxt;
                                        EditTextChange(0, "BSS_LTF" + i, BARRAtext, clrWhite, clrRed);
                                        ALLARMATOLTF = tftransformation(HTF) + " " + LEG + " : " + tftransformation(TFL) + " BSS- " + cosasei + " mitigated " + BARRAtext;
                                        if(iBarShift(SIMBA, SIGNAL_ENTRY, iTime(SIMBA, TFL, BSSLSBSOURCEMITIGATED)) == 1) TOSENDLTF = 1;
                                    }
                                }
                            }
                        }
                        else  EditTextChange(0, "BSS_LTF" + i, "", clrBlack, clrWhite);
// END GESTIONE SECOND TF
                        string VSALLARMATOLTF = "";
                        int VSTOSENDLTF = 0;
                        int VSM1LSB = LSBfuncBSS(SIMBA, TFL, HHH, LLL, BMSSS, BMSSSbreak, FLOWK, 1, 0, BSSCHOCH);
                        if(BSSLSBBROKENYES != 0) {
                            if(FLOWK == 2) {
                                if(iLow(SIMBA, TFL, iBars(SIMBA, TFL) - BSSLSBSOURCE) < EQUO) {
                                    double BARRAlevel = 100 * ((iHigh(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_HH) - iLow(SIMBA, TFL, iBars(SIMBA, TFL) - BSSLSBSOURCE)) / WHERElevel);
                                    string BARRAleveltxt = " [" + DoubleToStr(BARRAlevel, 0) + "%]";
                                    if(BARRAlevel > 100) BARRAleveltxt = " [100+%]";
                                    if(BSSLSBSOURCEMITIGATED == 0) {
                                        int BARRA = iBarShift(SIMBA, HTF, iTime(SIMBA, TFL, BSSLSBBROKENYES));
                                        string BARRAtext = BARRA + BARRAleveltxt;
                                        EditTextChange(0, "VSBSS_LTF" + i, BARRAtext, clrBlack, clrLightYellow);
                                        VSALLARMATOLTF = tftransformation(HTF) + " " + LEG + " : " + tftransformation(TFL) + " BSS+ " + tftransformation(TFL) + " " + cosasei + " " + BARRAtext;
                                        if(iBarShift(SIMBA, SIGNAL_ENTRY, iTime(SIMBA, TFL, BSSLSBBROKENYES)) == 1) VSTOSENDLTF = 1;
                                    }
                                    else {
                                        int BARRA = iBarShift(SIMBA, HTF, iTime(SIMBA, TFL, BSSLSBSOURCEMITIGATED));
                                        string BARRAtext = BARRA + BARRAleveltxt;
                                        EditTextChange(0, "VSBSS_LTF" + i, BARRAtext, clrWhite, clrGreen);
                                        VSALLARMATOLTF = tftransformation(HTF) + " " + LEG + " : " + tftransformation(TFL) + " BSS+ " + cosasei + " mitigated " + BARRAtext;
                                        if(iBarShift(SIMBA, SIGNAL_ENTRY, iTime(SIMBA, TFL, BSSLSBSOURCEMITIGATED)) == 1) VSTOSENDLTF = 1;
                                    }
                                }
                            }
                            if(FLOWK == 1) {
                                if(iHigh(SIMBA, TFL, iBars(SIMBA, TFL) - BSSLSBSOURCE) > EQUO) {
                                    double BARRAlevel = 100 * ((iHigh(SIMBA, TFL, iBars(SIMBA, TFL) - BSSLSBSOURCE) - iLow(SIMBA, HTF, iBars(SIMBA, HTF) - LAST_LL)) / WHERElevel);
                                    if(BARRAlevel > 100) BARRAlevel = 100;
                                    string BARRAleveltxt = " [" + DoubleToStr(BARRAlevel, 0) + "%]";
                                    if(BARRAlevel > 100) BARRAleveltxt = " [100+%]";
                                    if(BSSLSBSOURCEMITIGATED == 0) {
                                        int BARRA = iBarShift(SIMBA, HTF, iTime(SIMBA, TFL, BSSLSBBROKENYES));
                                        string BARRAtext = BARRA + BARRAleveltxt;
                                        EditTextChange(0, "VSBSS_LTF" + i, BARRAtext, clrBlack, clrLightYellow);
                                        VSALLARMATOLTF = tftransformation(HTF) + " " + LEG + " : " + tftransformation(TFL) + " BSS- " + cosasei + " " + BARRAtext;
                                        if(iBarShift(SIMBA, SIGNAL_ENTRY, iTime(SIMBA, TFL, BSSLSBBROKENYES)) == 1) VSTOSENDLTF = 1;
                                    }
                                    else {
                                        int BARRA = iBarShift(SIMBA, HTF, iTime(SIMBA, TFL, BSSLSBSOURCEMITIGATED));
                                        string BARRAtext = BARRA + BARRAleveltxt;
                                        EditTextChange(0, "VSBSS_LTF" + i, BARRAtext, clrWhite, clrRed);
                                        VSALLARMATOLTF = tftransformation(HTF) + " " + LEG + " : " + tftransformation(TFL) + " BSS- " + cosasei + " mitigated " + BARRAtext;
                                        if(iBarShift(SIMBA, SIGNAL_ENTRY, iTime(SIMBA, TFL, BSSLSBSOURCEMITIGATED)) == 1) VSTOSENDLTF = 1;
                                    }
                                }
                            }
                        }
                        else  EditTextChange(0, "VSBSS_LTF" + i, "", clrBlack, clrWhite);
                        EditTextChange(0, "AI" + i, "", clrBlack, clrWhite);
                        EditTextChange(0, "AIg" + i, "", clrBlack, clrWhite);
                        string ALLARMATO = "";
                        int TOSEND = 0;
// GESTIONE DEGLI ALERT
                        if(FLOWK == 1 && BREAKERLEG == 1) {
                            if(CHOCHorBOS == 1) {
                                TOSEND = 1;
                                ALLARMATO = "1a.New Bullish CHoCH - Trend Change Intention";
                                EditTextChange(0, "AI" + i, ALLARMATO, clrBlack, clrWhite);
                                EditTextChange(0, "AIg" + i, CharToString(248) + CharToString(236), clrBlack, clrWhite);
                            }
                            if(CHOCHorBOS == 2) {
                                TOSEND = 1;
                                ALLARMATO = "1b.New Bullish BOS - HLH formation";
                                EditTextChange(0, "AI" + i, ALLARMATO, clrBlack, clrWhite);
                                EditTextChange(0, "AIg" + i, CharToString(246) + CharToString(248) + CharToString(236), clrBlack, clrWhite);
                            }
                            if(TOSEND == 1) {
                                if(GlobalVariableGet(SIMBA + HTF + "SD_bleg") != iBars(SIMBA, HTF)) {
                                    TOSEND = 1;
                                    GlobalVariableSet(SIMBA + HTF + "SD_bleg", iBars(SIMBA, HTF));
                                }
                                else TOSEND = 0;
                            }
                        }
                        if(FLOWK == 2 && BREAKERLEG == 1) {
                            if(CHOCHorBOS == 1) {
                                TOSEND = 1;
                                ALLARMATO = "1c.New Bearish CHoCH - Trend Change Intention";
                                EditTextChange(0, "AI" + i, ALLARMATO, clrBlack, clrWhite);
                                EditTextChange(0, "AIg" + i, CharToString(246) + CharToString(238), clrBlack, clrWhite);
                            }
                            if(CHOCHorBOS == 2) {
                                TOSEND = 1;
                                ALLARMATO = "1d.New Bearish BOS - LHL formation";
                                EditTextChange(0, "AI" + i, ALLARMATO, clrBlack, clrWhite);
                                EditTextChange(0, "AIg" + i, CharToString(248) + CharToString(246) + CharToString(238), clrBlack, clrWhite);
                            }
                            if(TOSEND == 1) {
                                if(GlobalVariableGet(SIMBA + HTF + "SD_bleg") != iBars(SIMBA, HTF)) {
                                    TOSEND = 1;
                                    GlobalVariableSet(SIMBA + HTF + "SD_bleg", iBars(SIMBA, HTF));
                                }
                                else TOSEND = 0;
                            }
                        }
                        if(FLOWK == 1 && SUPDEM_mitigated == 1) {
                            ALLARMATO = "2a.Bullish Flow - Pullback met the Demand";
                            EditTextChange(0, "AIg" + i, CharToString(236) + CharToString(248) + CharToString(254) + CharToString(236), clrBlack, clrPaleGreen);
                            EditTextChange(0, "AI" + i, ALLARMATO, clrBlack, clrPaleGreen);
                            if(GlobalVariableGet(SIMBA + HTF + "SD_mit") != LAST_RTS) {
                                TOSEND = 1;
                                GlobalVariableSet(SIMBA + HTF + "SD_mit", LAST_RTS);
                            }
                        }
                        if(FLOWK == 2 && SUPDEM_mitigated == 1) {
                            ALLARMATO = "2b.Bearish Flow - Pullback met the Supply";
                            EditTextChange(0, "AIg" + i, CharToString(238) + CharToString(246) + CharToString(254) + CharToString(238), clrBlack, clrPink);
                            EditTextChange(0, "AI" + i, ALLARMATO, clrBlack, clrPink);
                            if(GlobalVariableGet(SIMBA + HTF + "SD_mit") != LAST_RTS) {
                                TOSEND = 1;
                                GlobalVariableSet(SIMBA + HTF + "SD_mit", LAST_RTS);
                            }
                        }
                        if(FLOWK == 1 && SUPDEMOPP_mitigated == 1) {
                            ALLARMATO = "3a.Price met an old Supply zone - Potential flip zone";
                            EditTextChange(0, "AIg" + i, CharToString(236) + CharToString(254), clrBlack, clrLightGray);
                            EditTextChange(0, "AI" + i, ALLARMATO, clrBlack, clrLightGray);
                            if(GlobalVariableGet(SIMBA + HTF + "SDopp_mit") != LAST_RTS_CHECK) {
                                TOSEND = 1;
                                GlobalVariableSet(SIMBA + "SD_mit", LAST_RTS_CHECK);
                            }
                        }
                        if(FLOWK == 2 && SUPDEMOPP_mitigated == 1) {
                            ALLARMATO = "3b.Price met an old Demand zone - Potential flip zone";
                            EditTextChange(0, "AIg" + i, CharToString(238) + CharToString(254), clrBlack, clrLightGray);
                            EditTextChange(0, "AI" + i, ALLARMATO, clrBlack, clrLightGray);
                            if(GlobalVariableGet(SIMBA + HTF + "SDopp_mit") != LAST_RTS_CHECK) {
                                TOSEND = 1;
                                GlobalVariableSet(SIMBA + HTF + "SD_mit", LAST_RTS_CHECK);
                            }
                        }
                        if(LSBSUBSTRUCTURE == 1) {
                            if(FLOWK == 2) {
                                ALLARMATO = "4a.SubDemand mitigated - Pullback continuation (counter trend)";
                                EditTextChange(0, "AI" + i, ALLARMATO, clrBlack, clrYellow);
                                EditTextChange(0, "AIg" + i, CharToString(238) + CharToString(246) + CharToString(254) + CharToString(236), clrBlack, clrYellow);
                            }
                            if(FLOWK == 1) {
                                ALLARMATO = "4b.SubSupply mitigated - Pullback continuation (counter trend)";
                                EditTextChange(0, "AI" + i, ALLARMATO, clrBlack, clrYellow);
                                EditTextChange(0, "AIg" + i, CharToString(236) + CharToString(248) + CharToString(254) + CharToString(238), clrBlack, clrYellow);
                            }
                            if(GlobalVariableGet(SIMBA + HTF + "LSBST") != iBars(SIMBA, HTF) - LSBSOURCEMITIGATED) {
                                TOSEND = 1;
                                GlobalVariableSet(SIMBA + HTF + "LSBST", iBars(SIMBA, HTF) - LSBSOURCEMITIGATED);
                            }
                        }
                        if(LSBSUBSTRUCTURE == 2) {
                            if(FLOWK == 2) {
                                ALLARMATO = "5a.SubDemand broken at " + LSBPREMDIS + "%Fibo - Trend continuation";
                                EditTextChange(0, "AI" + i, ALLARMATO, clrWhite, clrRed);
                                EditTextChange(0, "AIg" + i, CharToString(238) + CharToString(228) + CharToString(230), clrWhite, clrRed);
                            }
                            if(FLOWK == 1) {
                                ALLARMATO = "5b.SubSupply broken at " + LSBPREMDIS + "%Fibo - Trend continuation";
                                EditTextChange(0, "AI" + i, ALLARMATO, clrWhite, clrGreen);
                                EditTextChange(0, "AIg" + i, CharToString(236) + CharToString(230) + CharToString(228), clrWhite, clrGreen);
                            }
                            if(GlobalVariableGet(SIMBA + HTF + "LSBSTOK") != iBars(SIMBA, HTF) - LSBBROKENYES) {
                                TOSEND = 1;
                                GlobalVariableSet(SIMBA + HTF + "LSBSTOK", iBars(SIMBA, HTF) - LSBBROKENYES);
                            }
                        }
                        if(LSBSUBSTRUCTURE == 3) {
                            if(FLOWK == 2) {
                                ALLARMATO = "6a.SubSupply Mitigated at " + LSBPREMDIS + "%Fibo - Trend continuation";
                                EditTextChange(0, "AI" + i, ALLARMATO, clrBlack, clrYellow);
                                EditTextChange(0, "AIg" + i, CharToString(238) + CharToString(228) + CharToString(230) + CharToString(228) + CharToString(254) + CharToString(238), clrBlack, clrYellow);
                            }
                            if(FLOWK == 1) {
                                ALLARMATO = "6b.SubDemand Mitigated at " + LSBPREMDIS + "%Fibo - Trend continuation";
                                EditTextChange(0, "AI" + i, ALLARMATO, clrBlack, clrYellow);
                                EditTextChange(0, "AIg" + i, CharToString(236) + CharToString(230) + CharToString(228) + CharToString(230) + CharToString(254) + CharToString(236), clrBlack, clrYellow);
                            }
                            if(GlobalVariableGet(SIMBA + HTF + "LSBSTOKMIT") != iBars(SIMBA, HTF) - LSBSOURCEMITIGATED) {
                                TOSEND = 1;
                                GlobalVariableSet(SIMBA + HTF + "LSBSTOKMIT", iBars(SIMBA, HTF) - LSBSOURCEMITIGATED);
                            }
                        }
// FINE GESTIONE DEGLI ALERT
                        if(GlobalVariableGet("SCANNERALERT") == 1 && ALLARMATO != "" && VOLTA == STAVOLTA && TOSEND == 1) Alert(SIMBA + " " + tftransformation(HTF) + " : " + ALLARMATO);
                        if(GlobalVariableGet("SCANNERALERTMOBILE") == 1 && ALLARMATO != "" && VOLTA == STAVOLTA && TOSEND == 1) SendNotification(SIMBA + " " + tftransformation(HTF) + " : " + ALLARMATO);
                        if(TOSENDLTF == 1) {
                            if(GlobalVariableGet("SCANNERALERT") == 1 && ALLARMATOLTF != "" && VOLTA == STAVOLTA) Alert(SIMBA + " : " + ALLARMATOLTF);
                            if(GlobalVariableGet("SCANNERALERTMOBILE") == 1 && ALLARMATOLTF != "" && VOLTA == STAVOLTA) SendNotification(SIMBA + " : " + ALLARMATOLTF);
                        }
                    }
                }
                if(PRIMOAVVIO == 0) {
                }
                if(ObjectFind(0, SIMBA + "_POS") < 0) {
                    if(SOMMASIZE(SIMBA, OP_BUY) + SOMMASIZE(SIMBA, OP_SELL) > 0) {
                        RectLabelCreate(0, SIMBA + "_POS", 0, 0, 40 * ZOOM_PIXEL + 20 * (i + 1)*ZOOM_PIXEL, 10 * ZOOM_PIXEL, 20 * ZOOM_PIXEL, clrLightCyan, BORDER_FLAT, CORNER_LEFT_UPPER, clrLightCyan, STYLE_SOLID);
                    }
                }
                else {
                    if(SOMMASIZE(SIMBA, OP_BUY) + SOMMASIZE(SIMBA, OP_SELL) == 0) ObjectDelete(0, SIMBA + "_POS");
                }
            }
            ObjectDelete(0, "UPDATE");
        }
    }
    VOL = iVolume(SIM, SIGNAL_ENTRY, 0);
//// AUTOTRADING
    if(OWF == 9 && IsTesting() == true) {
        if(Volume[0] == 1) {
            int goo = ORDERBLOCK(Symbol(), 60, 0, 1, 0, 1);
            goo = ORDERBLOCKshow(Symbol(), 60, 0, 1, 0, 1, 1, 0);
            if(iBars(SIM, 60) - LAST_RTO_CHECK == 1) {
            }
        }
    }
//// END AUTOTRADING
    if(DASHBOARD == false) {
        if(IsTesting() == false) CREATETEXTPRICEprice("BUTX_TIMER", timergiu(), TimeCurrent() + 2 * PeriodSeconds(), iClose(Symbol(), 0, 0), clrWhite, ANCHOR_LEFT_UPPER);
    }
    if(HIDE_TD1 == 1 && ObjectGetInteger(0, "BUTXTD1_DRAW", OBJPROP_STATE) == 1) TDMNG();
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
    ResetLastError();
    RefreshRates();
    static bool keyPressed = false;
    if(id == CHARTEVENT_KEYDOWN) {
        switch(int(lparam)) {
        case KEY_V: {
            if(VPROFILE == 1) {
                VPROFILE = 0;
                int totalObjects = ObjectsTotal(0, 0, -1);
                for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                    if(StringSubstr(ObjectName(i), 0, 4) == "PROF") ObjectDelete(ObjectName(i));
                }
            }
            else {
                VPROFILE = 1;
                VOLPROF(Symbol(), 0);
            }
        }
        break;
        case KEY_BACKTONOW: {
            BARRE_DEVIATION = 0;
            GlobalVariableSet(Symbol() + "TFBARRE", Period());
            GlobalVariableSet(Symbol() + "BARRE", BARRE_DEVIATION);
            if(DASHBOARD == true) PRIMOAVVIO = 1;
            RILANCIAfun(0, Symbol());
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            OnTick();
        }
        break;
        case KEY_STARTINDIETRO: {
            if(GlobalVariableGet(Symbol() + "TFBARRE") != Period() && GlobalVariableGet(Symbol() + "BARRE") != 0) BARRE_DEVIATION = iBarShift(Symbol(), Period(), iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
            BARRE_DEVIATION = BARRE_DEVIATION + 1;
            GlobalVariableSet(Symbol() + "TFBARRE", Period());
            GlobalVariableSet(Symbol() + "BARRE", BARRE_DEVIATION);
            int totalObjects = ObjectsTotal(0, 0, -1);
            for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                if(StringSubstr(ObjectName(i), 0, 7) == "TRADEON" || StringSubstr(ObjectName(i), 0, 3) == "FVG")
                    ObjectDelete(ObjectName(i));
                if(StringSubstr(ObjectName(i), 0, 6) == "SOURCE" || StringSubstr(ObjectName(i), 0, 6) == "PREZZO" || StringSubstr(ObjectName(i), 0, 3) == "OBb")
                    ObjectDelete(ObjectName(i));
            }
            RILANCIAfun(0, Symbol());
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            OnTick();
        }
        break;
        case KEY_STARTINDIETROfast: {
            if(GlobalVariableGet(Symbol() + "TFBARRE") != Period() && GlobalVariableGet(Symbol() + "BARRE") != 0) BARRE_DEVIATION = iBarShift(Symbol(), Period(), iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
            if(Period() == PERIOD_M1)
                BARRE_DEVIATION = BARRE_DEVIATION + 60;
            if(Period() == PERIOD_M5)
                BARRE_DEVIATION = BARRE_DEVIATION + 24;
            if(Period() == PERIOD_M15)
                BARRE_DEVIATION = BARRE_DEVIATION + 48;
            if(Period() == PERIOD_M30)
                BARRE_DEVIATION = BARRE_DEVIATION + 24;
            if(Period() == PERIOD_H1)
                BARRE_DEVIATION = BARRE_DEVIATION + 12;
            if(Period() == PERIOD_H4)
                BARRE_DEVIATION = BARRE_DEVIATION + 15;
            if(Period() == PERIOD_D1)
                BARRE_DEVIATION = BARRE_DEVIATION + 11;
            if(Period() == PERIOD_W1)
                BARRE_DEVIATION = BARRE_DEVIATION + 26;
            if(Period() == PERIOD_MN1)
                BARRE_DEVIATION = BARRE_DEVIATION + 6;
            GlobalVariableSet(Symbol() + "TFBARRE", Period());
            GlobalVariableSet(Symbol() + "BARRE", BARRE_DEVIATION);
            int totalObjects = ObjectsTotal(0, 0, -1);
            for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                if(StringSubstr(ObjectName(i), 0, 7) == "TRADEON" || StringSubstr(ObjectName(i), 0, 3) == "FVG")
                    ObjectDelete(ObjectName(i));
                if(StringSubstr(ObjectName(i), 0, 6) == "SOURCE" || StringSubstr(ObjectName(i), 0, 6) == "PREZZO" || StringSubstr(ObjectName(i), 0, 3) == "OBb")
                    ObjectDelete(ObjectName(i));
            }
            RILANCIAfun(0, Symbol());
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            OnTick();
        }
        break;
        case KEY_STARTAVANTIfast: {
            if(GlobalVariableGet(Symbol() + "TFBARRE") != Period() && GlobalVariableGet(Symbol() + "BARRE") != 0) BARRE_DEVIATION = iBarShift(Symbol(), Period(), iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
            if(Period() == PERIOD_M1)
                BARRE_DEVIATION = BARRE_DEVIATION - 60;
            if(Period() == PERIOD_M5)
                BARRE_DEVIATION = BARRE_DEVIATION - 24;
            if(Period() == PERIOD_M15)
                BARRE_DEVIATION = BARRE_DEVIATION - 48;
            if(Period() == PERIOD_M30)
                BARRE_DEVIATION = BARRE_DEVIATION - 24;
            if(Period() == PERIOD_H1)
                BARRE_DEVIATION = BARRE_DEVIATION - 12;
            if(Period() == PERIOD_H4)
                BARRE_DEVIATION = BARRE_DEVIATION - 15;
            if(Period() == PERIOD_D1)
                BARRE_DEVIATION = BARRE_DEVIATION - 11;
            if(Period() == PERIOD_W1)
                BARRE_DEVIATION = BARRE_DEVIATION - 26;
            if(Period() == PERIOD_MN1)
                BARRE_DEVIATION = BARRE_DEVIATION - 6;
            GlobalVariableSet(Symbol() + "TFBARRE", Period());
            GlobalVariableSet(Symbol() + "BARRE", BARRE_DEVIATION);
            int totalObjects = ObjectsTotal(0, 0, -1);
            for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                if(StringSubstr(ObjectName(i), 0, 7) == "TRADEON" || StringSubstr(ObjectName(i), 0, 3) == "FVG")
                    ObjectDelete(ObjectName(i));
                if(StringSubstr(ObjectName(i), 0, 6) == "SOURCE" || StringSubstr(ObjectName(i), 0, 6) == "PREZZO" || StringSubstr(ObjectName(i), 0, 3) == "OBb")
                    ObjectDelete(ObjectName(i));
            }
            if(BARRE_DEVIATION < 0) {
                GlobalVariableSet(Symbol() + "TFBARRE", Period());
                GlobalVariableSet(Symbol() + "BARRE", 0);
                BARRE_DEVIATION = 0;
            }
            RILANCIAfun(0, Symbol());
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            OnTick();
        }
        break;
        case KEY_STARTAVANTI: {
            if(GlobalVariableGet(Symbol() + "TFBARRE") != Period() && GlobalVariableGet(Symbol() + "BARRE") != 0) BARRE_DEVIATION = iBarShift(Symbol(), Period(), iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
            if(BARRE_DEVIATION != 0)
                BARRE_DEVIATION = BARRE_DEVIATION - 1;
            GlobalVariableSet(Symbol() + "TFBARRE", Period());
            GlobalVariableSet(Symbol() + "BARRE", BARRE_DEVIATION);
            int totalObjects = ObjectsTotal(0, 0, -1);
            for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                if(StringSubstr(ObjectName(i), 0, 7) == "TRADEON" || StringSubstr(ObjectName(i), 0, 3) == "FVG")
                    ObjectDelete(ObjectName(i));
                if(StringSubstr(ObjectName(i), 0, 6) == "SOURCE" || StringSubstr(ObjectName(i), 0, 6) == "PREZZO" || StringSubstr(ObjectName(i), 0, 3) == "OBb")
                    ObjectDelete(ObjectName(i));
            }
            if(BARRE_DEVIATION < 0) {
                GlobalVariableSet(Symbol() + "TFBARRE", Period());
                GlobalVariableSet(Symbol() + "BARRE", 0);
                BARRE_DEVIATION = 0;
            }
            RILANCIAfun(0, Symbol());
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            OnTick();
        }
        break;
        case KEY_L: {
            if(VEDILIVELLI == 0) VEDILIVELLI = 1;
            else VEDILIVELLI = 0;
            ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, VEDILIVELLI);
            int totalObjects = ObjectsTotal(0, 0, -1);
            for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                if(StringSubstr(ObjectName(i), 0, 3) == "BEP") ObjectDelete(ObjectName(i));
            }
            if(VEDILIVELLI == 1) {
                OnInit();
            }
            OnTick();
        }
        break;
        case KEY_T: {
            if(SPECIALBOLLVALUE == 0) SPECIALBOLLVALUE = 1;
            else SPECIALBOLLVALUE = 0;
            SPECIALBOLL(Symbol(), 0, SPECIALBOLLVALUE);
        }
        break;
        case KEY_I: {
            if(ICHI == 0) ICHI = 1;
            else ICHI = 0;
            VEDIICHI(Symbol(), 0, ICHI);
        }
        break;
        case KEY_E: {
        }
        break;
        case KEY_Q: {
            int count = 0;
            long chartid = ChartFirst();
            do {
                chartid = ChartNext(chartid);
                count++;
            }
            while(chartid != -1);
            if(count > 1 && AccountNumber() == 533674) {
                long chartID = ChartFirst();
                while(chartID >= 0) {
                    if(chartID != ChartID()) ChartClose(chartID);
                    chartID = ChartNext(chartID);
                }
                GlobalVariableSet("ADMIN_ALERT_SYSTEM", 0);
                break;
            }
            string VETTORE = PAIRS;
            string PAIR[];
            while(VETTORE != "") {
                ArrayResize(PAIR, ArraySize(PAIR) + 1);
                int POS = 0;
                POS = StringFind(VETTORE, ",", 0);
                if(StringFind(VETTORE, ",", 0) != -1) {
                    POS = StringFind(VETTORE, ",", 0);
                    PAIR[ArraySize(PAIR) - 1] = StringSubstr(VETTORE, 0, POS);
                    VETTORE = StringSubstr(VETTORE, POS + 1, 0);
                }
                else if (VETTORE != "") {
                    POS = StringLen(VETTORE);
                    PAIR[ArraySize(PAIR) - 1] = StringSubstr(VETTORE, 0, 0);
                    VETTORE = "";
                }
            }
            long DDD = ChartID();
            STRA1 = 0;
            STRA2 = 0;
            GlobalVariableSet("STRA1", STRA1);
            GlobalVariableSet("STRA2", STRA2);
            for(int i = 0; i < ArraySize(PAIR); i++) {
                if(AccountNumber() == 533674) {
                    ChartOpen(PAIR[i], POI_TF);
                    GlobalVariableSet("ADMIN_ALERT_SYSTEM", 1);
                }
            }
            Sleep(2000 + MathRand() % 10000);
            long cart = ChartFirst();
            while(cart != -1) {
                if(cart != DDD) {
                    ChartApplyTemplate(cart, "FXOB_SD_alert.tpl");
                    Sleep(1000);
                }
                cart = ChartNext(cart);
            }
        }
        break;
        case KEY_F: {
        }
        break;
        case KEY_H: {
        }
        break;
        case KEY_A: {
            if(DASHBOARD == false) {
            }
        }
        break;
        }
    }
    if(id == CHARTEVENT_OBJECT_CLICK) {
        if(sparam == "REFRESH") {
            if(DASHBOARD == true) PRIMOAVVIO = 1;
            RILANCIAfun(0, Symbol());
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            OnTick();
        }
        if(StringSubstr(sparam, 0, 13) == "BUTT_SCANNER_") {
            for(int n = 0; n < 5; n++) {
                switch(n) {
                case 0:
                    if(sparam == "BUTT_SCANNER_M15") GlobalVariableSet("SCANNERHTF", PERIOD_M15);
                    PRIMOAVVIO = 1;
                    break;
                case 1:
                    if(sparam == "BUTT_SCANNER_M30") GlobalVariableSet("SCANNERHTF", PERIOD_M30);
                    PRIMOAVVIO = 1;
                    break;
                case 2:
                    if(sparam == "BUTT_SCANNER_H1") GlobalVariableSet("SCANNERHTF", PERIOD_H1);
                    PRIMOAVVIO = 1;
                    break;
                case 3:
                    if(sparam == "BUTT_SCANNER_H4") GlobalVariableSet("SCANNERHTF", PERIOD_H4);
                    PRIMOAVVIO = 1;
                    break;
                case 4:
                    if(sparam == "BUTT_SCANNER_D1") GlobalVariableSet("SCANNERHTF", PERIOD_D1);
                    PRIMOAVVIO = 1;
                    break;
                }
            }
            OnTick();
        }
        if(StringSubstr(sparam, 0, 16) == "BUTT_SCANNER_LTF") {
            for(int n = 0; n < 3; n++) {
                switch(n) {
                case 0:
                    if(sparam == "BUTT_SCANNER_LTFM1") GlobalVariableSet("SCANNERTFL", PERIOD_M1);
                    PRIMOAVVIO = 1;
                    break;
                case 1:
                    if(sparam == "BUTT_SCANNER_LTFM5") GlobalVariableSet("SCANNERTFL", PERIOD_M5);
                    PRIMOAVVIO = 1;
                    break;
                case 2:
                    if(sparam == "BUTT_SCANNER_LTFM15") GlobalVariableSet("SCANNERTFL", PERIOD_M15);
                    PRIMOAVVIO = 1;
                    break;
                }
            }
            OnTick();
        }
        if(sparam == "BUTT_SCANNER_BSSCHOCH") {
            if(GlobalVariableGet("SCANNERBSSCHOCH") == 0) {
                GlobalVariableSet("SCANNERBSSCHOCH", 1);
            }
            else GlobalVariableSet("SCANNERBSSCHOCH", 0);
            PRIMOAVVIO = 1;
            OnTick();
        }
        if(sparam == "BUTT_ALERTSCANNER_MT") {
            if(GlobalVariableGet("SCANNERALERT") == 0) {
                GlobalVariableSet("SCANNERALERT", 1);
            }
            else {
                GlobalVariableSet("SCANNERALERT", 0);
            }
            if(GlobalVariableGet("SCANNERALERT") == 1) {
                ObjectSetInteger(0, sparam, OBJPROP_STATE, 1);
                ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrYellow);
                ObjectSetString(0, sparam, OBJPROP_TEXT, "Alert Scanner ON");
            }
            else {
                ObjectSetInteger(0, sparam, OBJPROP_STATE, 0);
                ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetString(0, sparam, OBJPROP_TEXT, "Alert Scanner off");
            }
        }
        if(sparam == "BUTT_ALERTSCANNER_MOBILE") {
            if(GlobalVariableGet("SCANNERALERTMOBILE") == 0) {
                GlobalVariableSet("SCANNERALERTMOBILE", 1);
            }
            else {
                GlobalVariableSet("SCANNERALERTMOBILE", 0);
            }
            if(GlobalVariableGet("SCANNERALERTMOBILE") == 1) {
                ObjectSetInteger(0, sparam, OBJPROP_STATE, 1);
                ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrYellow);
                ObjectSetString(0, sparam, OBJPROP_TEXT, "Alert Mobile ON");
            }
            else {
                ObjectSetInteger(0, sparam, OBJPROP_STATE, 0);
                ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetString(0, sparam, OBJPROP_TEXT, "Alert Mobile off");
            }
        }
        if(sparam == "BUTXTD2_FIX_CHART") {
            if(borderhidden == 0) borderhidden = 1;
            else borderhidden = 0;
            GlobalVariableSet("BORD", borderhidden);
            ObjectSetString(0, "BUTXTD2_FIX_CHART", OBJPROP_TEXT, GlobalVariableGet("BORD") ? "ON" : "X");
            ObjectSetInteger(0, "BUTXTD2_FIX_CHART", OBJPROP_BGCOLOR, GlobalVariableGet("BORD") ? clrYellow : clrLightGray);
            manageWindows(GlobalVariableGet("BORD"));
        }
        if(sparam == "BUTXTD0_NOW") {
            BARRE_DEVIATION = 0;
            GlobalVariableSet(Symbol() + "TFBARRE", Period());
            GlobalVariableSet(Symbol() + "BARRE", BARRE_DEVIATION);
            if(DASHBOARD == true) PRIMOAVVIO = 1;
            RILANCIAfun(0, Symbol());
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            OnTick();
        }
        if(sparam == "BUTXTD0_BACK") {
            if(GlobalVariableGet(Symbol() + "TFBARRE") != Period() && GlobalVariableGet(Symbol() + "BARRE") != 0) BARRE_DEVIATION = iBarShift(Symbol(), Period(), iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
            BARRE_DEVIATION = BARRE_DEVIATION + 1;
            GlobalVariableSet(Symbol() + "TFBARRE", Period());
            GlobalVariableSet(Symbol() + "BARRE", BARRE_DEVIATION);
            int totalObjects = ObjectsTotal(0, 0, -1);
            for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                if(StringSubstr(ObjectName(i), 0, 7) == "TRADEON" || StringSubstr(ObjectName(i), 0, 3) == "FVG")
                    ObjectDelete(ObjectName(i));
                if(StringSubstr(ObjectName(i), 0, 6) == "SOURCE" || StringSubstr(ObjectName(i), 0, 6) == "PREZZO" || StringSubstr(ObjectName(i), 0, 3) == "OBb")
                    ObjectDelete(ObjectName(i));
            }
            RILANCIAfun(0, Symbol());
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            OnTick();
        }
        if(sparam == "BUTXTD0_BACKBACK") {
            if(GlobalVariableGet(Symbol() + "TFBARRE") != Period() && GlobalVariableGet(Symbol() + "BARRE") != 0) BARRE_DEVIATION = iBarShift(Symbol(), Period(), iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
            if(Period() == PERIOD_M1)
                BARRE_DEVIATION = BARRE_DEVIATION + 60;
            if(Period() == PERIOD_M5)
                BARRE_DEVIATION = BARRE_DEVIATION + 24;
            if(Period() == PERIOD_M15)
                BARRE_DEVIATION = BARRE_DEVIATION + 48;
            if(Period() == PERIOD_M30)
                BARRE_DEVIATION = BARRE_DEVIATION + 24;
            if(Period() == PERIOD_H1)
                BARRE_DEVIATION = BARRE_DEVIATION + 12;
            if(Period() == PERIOD_H4)
                BARRE_DEVIATION = BARRE_DEVIATION + 15;
            if(Period() == PERIOD_D1)
                BARRE_DEVIATION = BARRE_DEVIATION + 11;
            if(Period() == PERIOD_W1)
                BARRE_DEVIATION = BARRE_DEVIATION + 26;
            if(Period() == PERIOD_MN1)
                BARRE_DEVIATION = BARRE_DEVIATION + 6;
            GlobalVariableSet(Symbol() + "TFBARRE", Period());
            GlobalVariableSet(Symbol() + "BARRE", BARRE_DEVIATION);
            int totalObjects = ObjectsTotal(0, 0, -1);
            for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                if(StringSubstr(ObjectName(i), 0, 7) == "TRADEON" || StringSubstr(ObjectName(i), 0, 3) == "FVG")
                    ObjectDelete(ObjectName(i));
                if(StringSubstr(ObjectName(i), 0, 6) == "SOURCE" || StringSubstr(ObjectName(i), 0, 6) == "PREZZO" || StringSubstr(ObjectName(i), 0, 3) == "OBb")
                    ObjectDelete(ObjectName(i));
            }
            RILANCIAfun(0, Symbol());
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            OnTick();
        }
        if(sparam == "BUTXTD0_NEXTNEXT") {
            if(GlobalVariableGet(Symbol() + "TFBARRE") != Period() && GlobalVariableGet(Symbol() + "BARRE") != 0) BARRE_DEVIATION = iBarShift(Symbol(), Period(), iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
            if(Period() == PERIOD_M1)
                BARRE_DEVIATION = BARRE_DEVIATION - 60;
            if(Period() == PERIOD_M5)
                BARRE_DEVIATION = BARRE_DEVIATION - 24;
            if(Period() == PERIOD_M15)
                BARRE_DEVIATION = BARRE_DEVIATION - 48;
            if(Period() == PERIOD_M30)
                BARRE_DEVIATION = BARRE_DEVIATION - 24;
            if(Period() == PERIOD_H1)
                BARRE_DEVIATION = BARRE_DEVIATION - 12;
            if(Period() == PERIOD_H4)
                BARRE_DEVIATION = BARRE_DEVIATION - 15;
            if(Period() == PERIOD_D1)
                BARRE_DEVIATION = BARRE_DEVIATION - 11;
            if(Period() == PERIOD_W1)
                BARRE_DEVIATION = BARRE_DEVIATION - 26;
            if(Period() == PERIOD_MN1)
                BARRE_DEVIATION = BARRE_DEVIATION - 6;
            GlobalVariableSet(Symbol() + "TFBARRE", Period());
            GlobalVariableSet(Symbol() + "BARRE", BARRE_DEVIATION);
            int totalObjects = ObjectsTotal(0, 0, -1);
            for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                if(StringSubstr(ObjectName(i), 0, 7) == "TRADEON" || StringSubstr(ObjectName(i), 0, 3) == "FVG")
                    ObjectDelete(ObjectName(i));
                if(StringSubstr(ObjectName(i), 0, 6) == "SOURCE" || StringSubstr(ObjectName(i), 0, 6) == "PREZZO" || StringSubstr(ObjectName(i), 0, 3) == "OBb")
                    ObjectDelete(ObjectName(i));
            }
            if(BARRE_DEVIATION < 0) {
                GlobalVariableSet(Symbol() + "TFBARRE", Period());
                GlobalVariableSet(Symbol() + "BARRE", 0);
                BARRE_DEVIATION = 0;
            }
            RILANCIAfun(0, Symbol());
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            OnTick();
        }
        if(sparam == "BUTXTD0_NEXT") {
            if(GlobalVariableGet(Symbol() + "TFBARRE") != Period() && GlobalVariableGet(Symbol() + "BARRE") != 0) BARRE_DEVIATION = iBarShift(Symbol(), Period(), iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
            if(BARRE_DEVIATION != 0)
                BARRE_DEVIATION = BARRE_DEVIATION - 1;
            GlobalVariableSet(Symbol() + "TFBARRE", Period());
            GlobalVariableSet(Symbol() + "BARRE", BARRE_DEVIATION);
            int totalObjects = ObjectsTotal(0, 0, -1);
            for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                if(StringSubstr(ObjectName(i), 0, 7) == "TRADEON" || StringSubstr(ObjectName(i), 0, 3) == "FVG")
                    ObjectDelete(ObjectName(i));
                if(StringSubstr(ObjectName(i), 0, 6) == "SOURCE" || StringSubstr(ObjectName(i), 0, 6) == "PREZZO" || StringSubstr(ObjectName(i), 0, 3) == "OBb")
                    ObjectDelete(ObjectName(i));
            }
            if(BARRE_DEVIATION < 0) {
                GlobalVariableSet(Symbol() + "TFBARRE", Period());
                GlobalVariableSet(Symbol() + "BARRE", 0);
                BARRE_DEVIATION = 0;
            }
            RILANCIAfun(0, Symbol());
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            OnTick();
        }
        if(sparam == "BUTXTDM_PROTECT") {
            protect(Symbol());
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
        }
        if(sparam == "BUTXTDM_COPYTPSL") {
            copytpsl(Symbol());
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
        }
        if(sparam == "BUTXTDM_MOVETPSL") {
            protect_new(Symbol(), iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 1), 0, OP_BUY);
            protect_new(Symbol(), iIchimoku(Symbol(), 0, 9, 26, 52, MODE_KIJUNSEN, 1), 0, OP_SELL);
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
        }
        if(sparam == "BUTXTDM_CANCELTPSL") {
            canceltpsl(Symbol());
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
        }
        if(sparam == "BUTXTDM_CLOSEALL") {
            int ret = MessageBox("Close all Orders " + Symbol(), "Confirm Yes if ok to close all orders", MB_YESNO); // Message box
            if(ret == IDYES) CloseOrderALL(Symbol());
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
        }
        if(sparam == "BUTXTDM_COPYORDER") {
            int ret = MessageBox("COPY ORDER", "COPY ORDER", MB_YESNO); // Message box
            if(ret == IDYES) copytrades();
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
        }
        if(sparam == "BUTXTD0_YHYL") {
            if(VEDIPD == 0) VEDIPD = 1;
            else VEDIPD = 0;
            int PER = PERIOD_D1;
            GlobalVariableSet(Symbol() + "PD", VEDIPD);
            VEDIPDHL(Symbol(), PER, VEDIPD);
        }
        if(sparam == "BUTXTD0_WHWL") {
            if(VEDIPW == 0) VEDIPW = 1;
            else VEDIPW = 0;
            int PER = PERIOD_W1;
            GlobalVariableSet(Symbol() + "PW", VEDIPW);
            VEDIPDHL(Symbol(), PER, VEDIPW);
        }
        if(sparam == "BUTXTD0_MHML") {
            if(VEDIPM == 0) VEDIPM = 1;
            else VEDIPM = 0;
            int PER = PERIOD_MN1;
            GlobalVariableSet(Symbol() + "PM", VEDIPM);
            VEDIPDHL(Symbol(), PER, VEDIPM);
        }
        if(sparam == "BUTXTD1_CLOUDS") {
            if(ICHI == 0) ICHI = 1;
            else ICHI = 0;
            VEDIICHI(Symbol(), 0, ICHI);
        }
        if(sparam == "BUTXTD1_BOLLTREND") {
            if(SPECIALBOLLVALUE == 0) SPECIALBOLLVALUE = 1;
            else SPECIALBOLLVALUE = 0;
            SPECIALBOLL(Symbol(), 0, SPECIALBOLLVALUE);
        }
        if(sparam == "BUTXTD1_LIQUIDITY") {
        }
        if(sparam == "BUTXTD0_SESS") {
            if(SESSION == 1 && SESSIONtype == 2) {
                SESSION = 0;
                SESSIONtype = 1;
            }
            else if(SESSION == 1 && SESSIONtype == 1) {
                SESSION = 1;
                SESSIONtype = 2;
            }
            else if(SESSION == 0) {
                SESSION = 1;
                SESSIONtype = 1;
            }
            int totalObjects = ObjectsTotal(0, 0, -1);
            for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                if(StringSubstr(ObjectName(i), 0, 4) == "SESS") ObjectDelete(ObjectName(i));
            }
            if(SESSION == 0) ObjectSetInteger(0, "BUTXTD0_SESS", OBJPROP_STATE, false);
            SESSIONfunct(Symbol(), 5, SESSIONtype);
        }
        if(sparam == "BUTXTD0_PROF") {
            if(VPROFILE == 1) {
                VPROFILE = 0;
                int totalObjects = ObjectsTotal(0, 0, -1);
                for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                    if(StringSubstr(ObjectName(i), 0, 4) == "PROF") ObjectDelete(ObjectName(i));
                }
            }
            else {
                VPROFILE = 1;
                VOLPROF(Symbol(), 0);
            }
        }
        if(sparam == "BUTT_TD2") {
            if(HIDE_TD2 == 0) {
                ObjectSetText("BUTT_TD2", ">");
                ObjectSetInteger(0, "BUTT_TD2", OBJPROP_STATE, 0);
                HIDE_TD2 = 1;
                GlobalVariableSet(Symbol() + "TD2", HIDE_TD2);
                SHOWHIDE(HIDE_TD2, "TD2");
            }
            else {
                ObjectSetText("BUTT_TD2", "<");
                ObjectSetInteger(0, "BUTT_TD2", OBJPROP_STATE, 0);
                HIDE_TD2 = 0;
                GlobalVariableSet(Symbol() + "TD2", HIDE_TD2);
                SHOWHIDE(HIDE_TD2, "TD2");
            }
        }
        if(sparam == "BUTT_TD1") {
            if(HIDE_TD1 == 0) {
                ObjectSetText("BUTT_TD1", ">");
                ObjectSetInteger(0, "BUTT_TD1", OBJPROP_STATE, 0);
                HIDE_TD1 = 1;
                GlobalVariableSet(Symbol() + "TD1", HIDE_TD1);
                SHOWHIDE(HIDE_TD1, "TD1");
            }
            else {
                ObjectSetText("BUTT_TD1", "<");
                ObjectSetInteger(0, "BUTT_TD1", OBJPROP_STATE, 0);
                HIDE_TD1 = 0;
                GlobalVariableSet(Symbol() + "TD1", HIDE_TD1);
                SHOWHIDE(HIDE_TD1, "TD1");
            }
        }
        if(sparam == "BUTT_TD0") {
            if(HIDE_TD0 == 0) {
                ObjectSetText("BUTT_TD0", ">");
                ObjectSetInteger(0, "BUTT_TD0", OBJPROP_STATE, 0);
                HIDE_TD0 = 1;
                GlobalVariableSet(Symbol() + "TD0", HIDE_TD0);
                SHOWHIDE(HIDE_TD0, "TD0");
            }
            else {
                ObjectSetText("BUTT_TD0", "<");
                ObjectSetInteger(0, "BUTT_TD0", OBJPROP_STATE, 0);
                HIDE_TD0 = 0;
                GlobalVariableSet(Symbol() + "TD0", HIDE_TD0);
                SHOWHIDE(HIDE_TD0, "TD0");
            }
        }
        if(sparam == "BUTT_TDM") {
            if(HIDE_TDM == 0) {
                ObjectSetText("BUTT_TDM", ">");
                ObjectSetInteger(0, "BUTT_TDM", OBJPROP_STATE, 0);
                HIDE_TDM = 1;
                GlobalVariableSet(Symbol() + "TDM", HIDE_TDM);
                SHOWHIDE_TDM(HIDE_TDM);
            }
            else {
                ObjectSetText("BUTT_TDM", "<");
                ObjectSetInteger(0, "BUTT_TDM", OBJPROP_STATE, 0);
                HIDE_TDM = 0;
                GlobalVariableSet(Symbol() + "TDM", HIDE_TDM);
                SHOWHIDE_TDM(HIDE_TDM);
            }
        }
        if(sparam == "BUTXTD1_DRAW") {
            if(TRADEMODE == 0) TRADEMODE = 1;
            else TRADEMODE = 0;
            if(ObjectGetInteger(0, "BUTXTD1_DRAW", OBJPROP_STATE) == 0) {
                int totalObjects = ObjectsTotal(0, 0, -1);
                for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                    if(StringSubstr(ObjectName(i), 0, 15) == "BUTXTD1_MANAGER") ObjectDelete(ObjectName(i));
                }
                PENDINGMODE = 0;
                ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
                ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
            }
            else {
                ObjectCreate(0, "BUTXTD1_MANAGER_OPEN", OBJ_HLINE, 0, 0, iClose(Symbol(), 0, 0));
                ObjectCreate(0, "BUTXTD1_MANAGER_SL", OBJ_HLINE, 0, 0, iClose(Symbol(), 0, 0) - iATR(Symbol(), 0, 14, 1));
                ObjectCreate(0, "BUTXTD1_MANAGER_TP", OBJ_HLINE, 0, 0, iClose(Symbol(), 0, 0) + iATR(Symbol(), 0, 14, 1));
                ObjectSetInteger(0, "BUTXTD1_MANAGER_OPEN", OBJPROP_COLOR, clrAqua);
                ObjectSetInteger(0, "BUTXTD1_MANAGER_SL", OBJPROP_COLOR, clrRed);
                ObjectSetInteger(0, "BUTXTD1_MANAGER_TP", OBJPROP_COLOR, clrLimeGreen);
                if(TRADEMODE == 1) {
                    ObjectSetInteger(0, sparam, OBJPROP_STATE, true);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                }
                else {
                    ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                }
            }
        }
        if(sparam == "BUTXTD1_PENDING") {
            if(PENDINGMODE == 0) PENDINGMODE = 1;
            else PENDINGMODE = 0;
            if(PENDINGMODE == 1) {
                ObjectSetInteger(0, sparam, OBJPROP_STATE, true);
                ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                ObjectSetString(0, "BUTXTD1_OPEN", OBJPROP_TEXT, "PLACE TRADE");
            }
            else {
                ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
                ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetString(0, "BUTXTD1_OPEN", OBJPROP_TEXT, "OPEN TRADE");
            }
        }
        if(sparam == "BUTXTD1_OPEN") {
            if(TRADEMODE == 1) {
                if(OPENTRADE == 0) OPENTRADE = 1;
                else OPENTRADE = 0;
                ObjectSetInteger(0, "BUTXTD1_OPEN", OBJPROP_STATE, true);
                ObjectSetInteger(0, "BUTXTD1_OPEN", OBJPROP_BGCOLOR, clrLimeGreen);
            }
            else {
                ObjectSetInteger(0, "BUTXTD1_OPEN", OBJPROP_STATE, false);
            }
        }
        if(sparam == "BUTXTD2_NEW_CHART") {
            if(ObjectGetInteger(0, sparam, OBJPROP_STATE) == true) ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrYellow);
            if(ObjectGetInteger(0, sparam, OBJPROP_STATE) == false) ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
        }
        if(sparam == "BUTXTD2S_" + StringSubstr(sparam, 9, 0)) {
            GlobalVariablesDeleteAll();
            GlobalVariableSet(StringSubstr(sparam, 9, 0) + "TD2", 1);
            string CURPER = Symbol();
            long cart = ChartFirst();
            while(cart != -1) {
                if(ChartSymbol(cart) == CURPER) {
                    int PER = ChartPeriod(cart);
                    ChartSetInteger(0, CHART_SCALEFIX, false);
                    if(ALSYS == 0) {
                        if(ObjectGet("BUTXTD2_NEW_CHART", OBJPROP_STATE) == 0)  {
                            ChartSetSymbolPeriod(cart, PREFIX + StringSubstr(sparam, 9, 0) + SUFFIX, PER);
                            int totalObjects = ObjectsTotal(0, 0, -1);
                            for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                                if(StringSubstr(ObjectName(i), 0, 5) == "NODEL") ObjectDelete(ObjectName(i));
                            }
                        }
                        else {
                            string EXP = WindowExpertName() + "_default";
                            ChartSaveTemplate(0, EXP);
                            ObjectSet(sparam, OBJPROP_STATE, false);
                            ObjectSet("BUTXTD2_NEW_CHART", OBJPROP_STATE, false);
                            long ACCA = ChartOpen(PREFIX + StringSubstr(sparam, 9, 0) + SUFFIX, PER);
                            ChartApplyTemplate(ACCA, EXP + ".tpl");
                        }
                    }
                }
                cart = ChartNext(cart);
            }
            if(ALSYS != 0) {
                MessageBox("Disable Alerts to change the use Symbol Changer", "Web24hub EA", MB_ICONEXCLAMATION | MB_OK);
                ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            }
            SYMBOL_CHANGER(1);
        }
        if(sparam == "BUTXTD0_Z" + StringSubstr(sparam, 9, 0)) {
            if(ALSYS == 0) {
                int PERIODO = 0;
                if(StringSubstr(sparam, 9, 0) == "M1") PERIODO = PERIOD_M1;
                else if(StringSubstr(sparam, 9, 0) == "M5") PERIODO = PERIOD_M5;
                else if(StringSubstr(sparam, 9, 0) == "M15") PERIODO = PERIOD_M15;
                else if(StringSubstr(sparam, 9, 0) == "M30") PERIODO = PERIOD_M30;
                else if(StringSubstr(sparam, 9, 0) == "H1") PERIODO = PERIOD_H1;
                else if(StringSubstr(sparam, 9, 0) == "H4") PERIODO = PERIOD_H4;
                else if(StringSubstr(sparam, 9, 0) == "D1") PERIODO = PERIOD_D1;
                else if(StringSubstr(sparam, 9, 0) == "W1") PERIODO = PERIOD_W1;
                else if(StringSubstr(sparam, 9, 0) == "MN1") PERIODO = PERIOD_MN1;
                ChartSetInteger(0, CHART_SCALEFIX, false);
                ChartSetSymbolPeriod(0, Symbol(), PERIODO);
            }
            else {
                ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            }
        }
        if(sparam == "OPEN_" + StringSubstr(sparam, 5, 0)) {
            ChartOpen(StringSubstr(sparam, 5, 0), GlobalVariableGet("SCANNERTFL"));
            ObjectSetInteger(0, "OPEN_" + StringSubstr(sparam, 5, 0), OBJPROP_STATE, false);
            GlobalVariableSet(StringSubstr(sparam, 5, 0) + tftransformation(GlobalVariableGet("SCANNERHTF")), 1);
            GlobalVariableSet(StringSubstr(sparam, 5, 0) + tftransformation(GlobalVariableGet("SCANNERTFL")), 1);
            GlobalVariableSet(StringSubstr(sparam, 5, 0) + tftransformation(GlobalVariableGet("SCANNERHTF")) + "SD", 1);
            GlobalVariableSet(StringSubstr(sparam, 5, 0) + tftransformation(GlobalVariableGet("SCANNERTFL")) + "SD", 1);
            long chartID = ChartFirst();
            while(chartID >= 0) {
                if(ChartSymbol(chartID) == StringSubstr(sparam, 5, 0) && chartID != ChartID()) {
                    ChartApplyTemplate(chartID, "FXOB_SD.tpl");
                }
                chartID = ChartNext(chartID);
            }
        }
        if(sparam == "SYMBOL") {
            long chartID = ChartFirst();
            while(chartID >= 0) {
                if(chartID != ChartID()) ChartClose(chartID);
                chartID = ChartNext(chartID);
            }
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
        }
        if(sparam == "BUTXTD2_CLOSE_CHART") {
            long chartID = ChartFirst();
            while(chartID >= 0) {
                if(chartID != ChartID()) ChartClose(chartID);
                chartID = ChartNext(chartID);
            }
            ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
        }
        if(sparam == "BUTXTD0_TYPEBMS") {
            if(DASHBOARD == false) {
                if(USE_LSB_SIGNAL_ENTRY == 1) USE_LSB_SIGNAL_ENTRY = 0;
                else USE_LSB_SIGNAL_ENTRY = 1;
                RILANCIAfun(0, Symbol());
            }
        }
        if(sparam == "BUTXTD0_TYPELSB") {
            if(DASHBOARD == false) {
                if(USE_LSB_SIGNAL_ENTRY == 1) USE_LSB_SIGNAL_ENTRY = 0;
                else USE_LSB_SIGNAL_ENTRY = 1;
                RILANCIAfun(0, Symbol());
            }
        }
        if(sparam == "BUTXTD0_CLEAR") {
            if(DASHBOARD == false) {
                GlobalVariableSet("ADMIN_ALERT_SYSTEM", 0);
                USE_LSB_SIGNAL_ENTRY = 1;
                int totalObjects = ObjectsTotal(0, 0, -1);
                for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                    if(StringSubstr(ObjectName(i), 0, 3) != "BUT" &&
                            StringSubstr(ObjectName(i), 0, 2) != "PD"
                            && StringSubstr(ObjectName(i), 0, 5) != "NODEL"
                      )  ObjectDelete(ObjectName(i));
                    if(StringSubstr(ObjectName(i), 0, 12) == "BUTXTD0_FIBO")  ObjectDelete(ObjectName(i));
                }
                STRA0 = 0;
                STRA1 = 0;
                STRA2 = 0;
                STRA3 = 0;
                STRA4 = 0;
                STRA5 = 1;
                USE_LSB_SIGNAL_ENTRY = 0;
                ObjectSetInteger(0, "BUTXTD0_STRA0", OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, "BUTXTD0_STRA0", OBJPROP_STATE, false);
                ObjectSetInteger(0, "BUTXTD0_STRA1", OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, "BUTXTD0_STRA1", OBJPROP_STATE, false);
                ObjectSetInteger(0, "BUTXTD0_STRA2", OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, "BUTXTD0_STRA2", OBJPROP_STATE, false);
                ObjectSetInteger(0, "BUTXTD0_STRA3", OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, "BUTXTD0_STRA3", OBJPROP_STATE, false);
                ObjectSetInteger(0, "BUTXTD0_STRA4", OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, "BUTXTD0_STRA4", OBJPROP_STATE, false);
                ObjectSetInteger(0, "BUTXTD0_STRA5", OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, "BUTXTD0_STRA5", OBJPROP_STATE, false);
                ObjectSetInteger(0, "BUTXTD0_BREAK_AT_EXTREME", OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, "BUTXTD0_BREAK_AT_EXTREME", OBJPROP_STATE, false);
                GlobalVariableSet("STRA0", STRA0);
                GlobalVariableSet("STRA1", STRA1);
                GlobalVariableSet("STRA2", STRA2);
                GlobalVariableSet("STRA3", STRA3);
                GlobalVariableSet(Symbol() + "STRA5", STRA5);
                GlobalVariableSet(Symbol() + "STRA4", STRA4);
                M1 = 0;
                M5 = 0;
                M15 = 0;
                M30 = 0;
                H1 = 0;
                H4 = 0;
                D1 = 0;
                W1 = 0;
                MN1 = 0;
                GlobalVariableSet(Symbol() + "M1", M1);
                GlobalVariableSet(Symbol() + "M5", M5);
                GlobalVariableSet(Symbol() + "M15", M15);
                GlobalVariableSet(Symbol() + "M30", M30);
                GlobalVariableSet(Symbol() + "H1", H1);
                GlobalVariableSet(Symbol() + "H4", H4);
                GlobalVariableSet(Symbol() + "D1", D1);
                GlobalVariableSet(Symbol() + "W1", W1);
                GlobalVariableSet(Symbol() + "MN1", MN1);
                M1SD = 0;
                M5SD = 0;
                M15SD = 0;
                M30SD = 0;
                H1SD = 0;
                H4SD = 0;
                D1SD = 0;
                W1SD = 0;
                MN1SD = 0;
                GlobalVariableSet(Symbol() + "M1SD", M1SD);
                GlobalVariableSet(Symbol() + "M5SD", M5SD);
                GlobalVariableSet(Symbol() + "M15SD", M15SD);
                GlobalVariableSet(Symbol() + "M30SD", M30SD);
                GlobalVariableSet(Symbol() + "H1SD", H1SD);
                GlobalVariableSet(Symbol() + "H4SD", H4SD);
                GlobalVariableSet(Symbol() + "D1SD", D1SD);
                GlobalVariableSet(Symbol() + "W1SD", W1SD);
                GlobalVariableSet(Symbol() + "MN1SD", MN1SD);
                M1LQ = 0;
                M5LQ = 0;
                M15LQ = 0;
                M30LQ = 0;
                H1LQ = 0;
                H4LQ = 0;
                D1LQ = 0;
                W1LQ = 0;
                MN1LQ = 0;
                GlobalVariableSet(Symbol() + "M1LQ", M1LQ);
                GlobalVariableSet(Symbol() + "M5LQ", M5LQ);
                GlobalVariableSet(Symbol() + "M15LQ", M15LQ);
                GlobalVariableSet(Symbol() + "M30LQ", M30LQ);
                GlobalVariableSet(Symbol() + "H1LQ", H1LQ);
                GlobalVariableSet(Symbol() + "H4LQ", H4LQ);
                GlobalVariableSet(Symbol() + "D1LQ", D1LQ);
                GlobalVariableSet(Symbol() + "W1LQ", W1LQ);
                GlobalVariableSet(Symbol() + "MN1LQ", MN1LQ);
                M1FV = 0;
                M5FV = 0;
                M15FV = 0;
                M30FV = 0;
                H1FV = 0;
                H4FV = 0;
                D1FV = 0;
                W1FV = 0;
                MN1FV = 0;
                GlobalVariableSet(Symbol() + "M1FVG", M1FV);
                GlobalVariableSet(Symbol() + "M5FVG", M5FV);
                GlobalVariableSet(Symbol() + "M15FVG", M15FV);
                GlobalVariableSet(Symbol() + "M30FVG", M30FV);
                GlobalVariableSet(Symbol() + "H1FVG", H1FV);
                GlobalVariableSet(Symbol() + "H4FVG", H4FV);
                GlobalVariableSet(Symbol() + "D1FVG", D1FV);
                GlobalVariableSet(Symbol() + "W1FVG", W1FV);
                GlobalVariableSet(Symbol() + "MN1FVG", MN1FV);
                ObjectSetInteger(0, "BUTXTD0_M1", OBJPROP_COLOR, clrBlack);
                ObjectSetInteger(0, "BUTXTD0_M5", OBJPROP_COLOR, clrBlack);
                ObjectSetInteger(0, "BUTXTD0_M15", OBJPROP_COLOR, clrBlack);
                ObjectSetInteger(0, "BUTXTD0_M30", OBJPROP_COLOR, clrBlack);
                ObjectSetInteger(0, "BUTXTD0_H1", OBJPROP_COLOR, clrBlack);
                ObjectSetInteger(0, "BUTXTD0_H4", OBJPROP_COLOR, clrBlack);
                ObjectSetInteger(0, "BUTXTD0_D1", OBJPROP_COLOR, clrBlack);
                ObjectSetInteger(0, "BUTXTD0_W1", OBJPROP_COLOR, clrBlack);
                ObjectSetInteger(0, "BUTXTD0_MN1", OBJPROP_COLOR, clrBlack);
                ObjectSetInteger(0, "BUTXTD0_M1", OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, "BUTXTD0_M1", OBJPROP_STATE, false);
                ObjectSetInteger(0, "BUTXTD0_M5", OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, "BUTXTD0_M5", OBJPROP_STATE, false);
                ObjectSetInteger(0, "BUTXTD0_M15", OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, "BUTXTD0_M15", OBJPROP_STATE, false);
                ObjectSetInteger(0, "BUTXTD0_M30", OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, "BUTXTD0_M30", OBJPROP_STATE, false);
                ObjectSetInteger(0, "BUTXTD0_H1", OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, "BUTXTD0_H1", OBJPROP_STATE, false);
                ObjectSetInteger(0, "BUTXTD0_H4", OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, "BUTXTD0_H4", OBJPROP_STATE, false);
                ObjectSetInteger(0, "BUTXTD0_D1", OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, "BUTXTD0_D1", OBJPROP_STATE, false);
                ObjectSetInteger(0, "BUTXTD0_W1", OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, "BUTXTD0_W1", OBJPROP_STATE, false);
                ObjectSetInteger(0, "BUTXTD0_MN1", OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, "BUTXTD0_MN1", OBJPROP_STATE, false);
                OnTick();
                GESTIONESD("SD", 0, "BUTXTD0_M1");
                GESTIONESD("SD", 0, "BUTXTD0_M5");
                GESTIONESD("SD", 0, "BUTXTD0_M15");
                GESTIONESD("SD", 0, "BUTXTD0_M30");
                GESTIONESD("SD", 0, "BUTXTD0_H1");
                GESTIONESD("SD", 0, "BUTXTD0_H4");
                GESTIONESD("SD", 0, "BUTXTD0_D1");
                GESTIONESD("SD", 0, "BUTXTD0_W1");
                GESTIONESD("SD", 0, "BUTXTD0_MN1");
                GESTIONELQ("LQ", 0, "BUTXTD0_M1");
                GESTIONELQ("LQ", 0, "BUTXTD0_M5");
                GESTIONELQ("LQ", 0, "BUTXTD0_M15");
                GESTIONELQ("LQ", 0, "BUTXTD0_M30");
                GESTIONELQ("LQ", 0, "BUTXTD0_H1");
                GESTIONELQ("LQ", 0, "BUTXTD0_H4");
                GESTIONELQ("LQ", 0, "BUTXTD0_D1");
                GESTIONELQ("LQ", 0, "BUTXTD0_W1");
                GESTIONELQ("LQ", 0, "BUTXTD0_MN1");
                GESTIONEFV("FVG", 0, "BUTXTD0_M1");
                GESTIONEFV("FVG", 0, "BUTXTD0_M5");
                GESTIONEFV("FVG", 0, "BUTXTD0_M15");
                GESTIONEFV("FVG", 0, "BUTXTD0_M30");
                GESTIONEFV("FVG", 0, "BUTXTD0_H1");
                GESTIONEFV("FVG", 0, "BUTXTD0_H4");
                GESTIONEFV("FVG", 0, "BUTXTD0_D1");
                GESTIONEFV("FVG", 0, "BUTXTD0_W1");
                GESTIONEFV("FVG", 0, "BUTXTD0_MN1");
                RILANCIAfun(0, Symbol());
                ObjectSetInteger(0, "BUTXTD0_CLEAR", OBJPROP_STATE, FALSE);
                VPROFILE = 0;
                ObjectSetInteger(0, "BUTXTD0_PROF", OBJPROP_STATE, false);
                totalObjects = ObjectsTotal(0, 0, -1);
                for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                    if(StringSubstr(ObjectName(i), 0, 4) == "PROF")  ObjectDelete(ObjectName(i));
                }
            }
        }
        if(sparam == "BUTXTD0_ALERT") {
            if(DASHBOARD == false) {
                if(ALSYS == 0) {
                    ALSYS = 1;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrAquamarine);
                }
                else {
                    ObjectDelete(0, "LOCKED2");
                    ObjectDelete(0, "LOCKED0");
                    ObjectDelete(0, "LOCKED1");
                    ALSYS = 0;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                }
                GlobalVariableSet(Symbol() + "ALSYS", ALSYS);
                if(ALSYS == 1) {
                    int ver = 0;
                    string BUTT = "";
                    switch(Period()) {
                    case 1:
                        BUTT = "M1";
                        ver = M1SD;
                        break;
                    case 5 :
                        BUTT = "M5";
                        ver = M5SD;
                        break;
                    case 15 :
                        BUTT = "M15";
                        ver = M15SD;
                        break;
                    case 30 :
                        BUTT = "M30";
                        ver = M30SD;
                        break;
                    case 60 :
                        BUTT = "H1";
                        ver = H1SD;
                        break;
                    case 240 :
                        BUTT = "H4";
                        ver = H4SD;
                        break;
                    case 1440 :
                        BUTT = "D1";
                        ver = D1SD;
                        break;
                    case PERIOD_W1 :
                        BUTT = "W1";
                        ver = W1SD;
                        break;
                    case PERIOD_MN1 :
                        BUTT = "MN1";
                        ver = MN1SD;
                        break;
                    }
                    if(ver == 0) {
                        ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
                        ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                        ALSYS = 0;
                        GlobalVariableSet(Symbol() + "ALSYS", ALSYS);
                        MessageBox("Please enable the current " + tftransformation(Period()) + " SOURCE and SD analysis to use the ALERT ENGINE for scanning new " + tftransformation(Period()) + " CHoCH and BOS!", "Web24hub EA", MB_ICONEXCLAMATION | MB_OK);
                    }
                    else {
                    }
                }
            }
        }
        if(sparam == "BUTXTD0_STRA1") {
            if(DASHBOARD == false) {
                if(STRA1 == 0) {
                    STRA1 = 1;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    ObjectSetInteger(0, sparam, OBJPROP_STATE, true);
                }
                else {
                    STRA1 = 0;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
                }
                GlobalVariableSet("STRA1", STRA1);
                if(STRA1 == 1) {
                    if(M1SD + M5SD + M15SD + M30SD + H1SD + H4SD + D1SD + W1SD + MN1SD == 1) {
                        RILANCIAfun(0, Symbol());
                        VEDIFIBO(Symbol(), LAST_TF, STRA1, LAST_LL, LAST_HH, LAST_FLOW);
                    }
                    else {
                        ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
                        ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                        STRA1 = 0;
                        MessageBox("Please enable one of the SD's timeframe analysis that you can find on the bottom left side, to use the FIBO analysis properly for the timeframe selected!", "Web24hub EA", MB_ICONEXCLAMATION | MB_OK);
                    }
                }
                if(STRA1 == 0) VEDIFIBO(Symbol(), LAST_TF, STRA1, 0, 0, 0);
            }
        }
        if(sparam == "BUTXTD0_STRA2") {
            if(DASHBOARD == false) {
                if(STRA2 == 0) {
                    STRA2 = 1;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                }
                else {
                    STRA2 = 0;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                }
                GlobalVariableSet("STRA2", STRA2);
                RILANCIAfun(0, Symbol());
                OnTick();
            }
        }
        if(sparam == "BUTXTD0_STRA3") {
            if(DASHBOARD == false) {
                if(STRA3 == 0) {
                    STRA3 = 1;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                }
                if(STRA3 == 1) {
                    string SIM = Symbol();
                    if(ObjectFind(0, "LOADING") < 0) {
                        EditCreate(0, "LOADING", 0, (int)ObjectGetInteger(0, "BUTXTD0_STRA1", OBJPROP_XDISTANCE) + 100, 60, 500, 30, "", "Arial", FONT_SIZE, ALIGN_CENTER, false, CORNER_LEFT_LOWER, clrGray, clrBlack, clrBlack, false);
                    }
                    GlobalVariableSet(Symbol() + "STRA4", 0);
                    int BARRA = iBarShift(SIM, POI_TF, iTime(SIM, GlobalVariableGet(SIM + "TFBARRE"), GlobalVariableGet(SIM + "BARRE") + 1));
                    BARRE_DEVIATION = 0;
                    GlobalVariableSet(Symbol() + "TFBARRE", Period());
                    GlobalVariableSet(Symbol() + "BARRE", 0);
                    for(int b = BARRA; b >= 0; b--) {
                        EditTextChange(0, "LOADING", "CHECKING " + tftransformation(POI_TF) + " BIAS..." + b, clrRed, clrBlack);
                        // bias
                        int DONE = ORDERBLOCK(SIM, POI_TF, b, 0, 0, 1);
                        DONE = ORDERBLOCKshow(SIM, POI_TF, b, 0, 0, 1, 0, 0);
                        int BIAS = 0;
                        BIAS = LAST_FLOW;
                        int MTF = 60;
                        for(int r = iBarShift(SIM, MTF, iTime(SIM, POI_TF, b - 1)); r > iBarShift(SIM, MTF, iTime(SIM, POI_TF, b - 2)); r--) {
                            DONE = ORDERBLOCK(SIM, MTF, r, 0, 0, 1);
                            DONE = ORDERBLOCKshow(SIM, MTF, r, 0, 0, 1, 0, 0);
                            int RT = iBars(SIM, MTF) - LAST_BMS;
                            int SR = iBars(SIM, MTF) - MathMax(LAST_HH, LAST_LL);
                            int LR = iBars(SIM, MTF) - MathMin(LAST_HH, LAST_LL);
                            double RAN;
                            if(ObjectFind(0, "LINEh") < 0) {
                                ObjectCreate(0, "LINEh", OBJ_VLINE, 0, iTime(SIM, MTF, r), 0);
                                ObjectSetInteger(0, "LINEh", OBJPROP_COLOR, clrAqua);
                            }
                            ObjectMove(0, "LINEh", 0, iTime(SIM, MTF, r), 0);
                            int MITIGATO = 0;
                            int DIREZIONE = 0;
                            if(iBars(SIM, MTF) - LAST_RTO == r + 1 && LAST_FLOW == BIAS) {
                                ObjectCreate(0, "ZOB" + b, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                                ObjectSetInteger(0, "ZOB" + b, OBJPROP_BACK, false);
                                ObjectMove(0, "ZOB" + r, 0, iTime(SIM, MTF, RT), iHigh(SIM, MTF, RT));
                                ObjectMove(0, "ZOB" + r, 1, iTime(SIM, MTF, r), iLow(SIM, MTF, RT));
                                if(LAST_FLOW == 1) ObjectSetInteger(0, "ZOB" + r, OBJPROP_COLOR, clrLimeGreen);
                                if(LAST_FLOW == 2) ObjectSetInteger(0, "ZOB" + r, OBJPROP_COLOR, clrRed);
                                MITIGATO = 1;
                                DIREZIONE = LAST_FLOW;
                                if(LAST_FLOW == 1) RAN = iHigh(SIM, MTF, SR) - iLow(SIM, MTF, LR);
                                if(LAST_FLOW == 2) RAN = iHigh(SIM, MTF, LR) - iLow(SIM, MTF, SR);
                            }
                        }
                    }
                    ObjectDelete(0, "LOADING");
                    ObjectDelete(0, "LOADING1");
                    ObjectDelete(0, "LINE");
                    ObjectDelete(0, "LINEh");
                }
                int totalObjects = ObjectsTotal(0, 0, -1);
                for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                }
                STRA3 = 0;
                ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
            }
        }
        if(sparam == "BUTXTD0_STRA4") {
            if(DASHBOARD == false) {
                if(STRA4 == 0) {
                    STRA4 = 1;
                    H4 = 1;
                    H4SD = 0;
                    H4FV = 1;
                    H4LQ = 0;
                    M15 = 1;
                    M15SD = 1;
                    M15LQ = 0;
                    M15FV = 1;
                }
                else {
                    STRA4 = 0;
                    H4 = 0;
                    H4SD = 0;
                    H4LQ = 0;
                    H4FV = 0;
                    M15 = 0;
                    M15SD = 0;
                    M15LQ = 0;
                    M15FV = 0;
                }
                GlobalVariableSet(Symbol() + "H4", H4);
                GlobalVariableSet(Symbol() + "H4SD", H4SD);
                GlobalVariableSet(Symbol() + "H4SD", H4FV);
                GlobalVariableSet(Symbol() + "H4SD", H4LQ);
                GlobalVariableSet(Symbol() + "M15", M15);
                GlobalVariableSet(Symbol() + "M15SD", M15SD);
                GlobalVariableSet(Symbol() + "M15LQ", M15LQ);
                GlobalVariableSet(Symbol() + "STRA4", STRA4);
                RILANCIAfun(0, Symbol());
            }
        }
        if(sparam == "BUTXTD0_STRA0") {
            if(DASHBOARD == false) {
                if(STRA0_MANUAL == 0) {
                    STRA0_MANUAL = 1;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                }
                else {
                    STRA0_MANUAL = 0;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
                }
                RILANCIAfun(0, Symbol());
            }
        }
        if(sparam == "BUTXTD0_STRA5") {
            if(DASHBOARD == false) {
                if(STRA5 == 0) {
                    STRA5 = 1;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                }
                else {
                    STRA5 = 0;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
                }
                GlobalVariableSet(Symbol() + "STRA5", STRA5);
                RILANCIAfun(0, Symbol());
            }
        }
        if(sparam == "BUTXTD0_M1") {
            if(DASHBOARD == false) {
                if(M1 == 0) {
                    ORDERBLOCK(Symbol(), 1, iBarShift(Symbol(), 1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1);
                    M1 = 1;
                    if(LAST_FLOW == 1)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLimeGreen);
                    if(LAST_FLOW == 2)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrOrangeRed);
                }
                else {
                    ORDERBLOCK(Symbol(), 1, iBarShift(Symbol(), 1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0);
                    M1 = 0;
                    M1SD = 0;
                    M1LQ = 0;
                    M1FV = 0;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    ObjectSetInteger(0, sparam, OBJPROP_COLOR, clrBlack);
                }
                GlobalVariableSet(Symbol() + "M1", M1);
                GESTIONESD("SD", M1, sparam);
                GESTIONELQ("LQ", M1, sparam);
                GESTIONEFV("FVG", M1, sparam);
                FIBOON("BUTXTD0_FIBO", sparam, M1);
            }
        }
        if(sparam == "BUTXTD0_M5") {
            if(DASHBOARD == false) {
                if(M5 == 0) {
                    ORDERBLOCK(Symbol(), 5, iBarShift(Symbol(), 5, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1);
                    M5 = 1;
                    if(LAST_FLOW == 1)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLimeGreen);
                    if(LAST_FLOW == 2)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrOrangeRed);
                }
                else {
                    ORDERBLOCK(Symbol(), 5, iBarShift(Symbol(), 5, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0);
                    M5 = 0;
                    M5SD = 0;
                    M5LQ = 0;
                    M5FV = 0;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    ObjectSetInteger(0, sparam, OBJPROP_COLOR, clrBlack);
                }
                GlobalVariableSet(Symbol() + "M5", M5);
                GESTIONESD("SD", M5, sparam);
                GESTIONELQ("LQ", M5, sparam);
                GESTIONEFV("FVG", M5, sparam);
                FIBOON("BUTXTD0_FIBO", sparam, M5);
            }
        }
        if(sparam == "BUTXTD0_M15") {
            if(DASHBOARD == false) {
                if(M15 == 0) {
                    ORDERBLOCK(Symbol(), 15, iBarShift(Symbol(), 15, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1);
                    M15 = 1;
                    if(LAST_FLOW == 1)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLimeGreen);
                    if(LAST_FLOW == 2)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrOrangeRed);
                }
                else {
                    ORDERBLOCK(Symbol(), 15, iBarShift(Symbol(), 15, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0);
                    M15 = 0;
                    M15SD = 0;
                    M15LQ = 0;
                    M15FV = 0;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    ObjectSetInteger(0, sparam, OBJPROP_COLOR, clrBlack);
                }
                GlobalVariableSet(Symbol() + "M15", M15);
                GESTIONESD("SD", M15, sparam);
                GESTIONELQ("LQ", M15, sparam);
                GESTIONEFV("FVG", M15, sparam);
                FIBOON("BUTXTD0_FIBO", sparam, M15);
            }
        }
        if(sparam == "BUTXTD0_M30") {
            if(DASHBOARD == false) {
                if(M30 == 0) {
                    ORDERBLOCK(Symbol(), 30, iBarShift(Symbol(), 30, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1);
                    M30 = 1;
                    if(LAST_FLOW == 1)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLimeGreen);
                    if(LAST_FLOW == 2)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrOrangeRed);
                }
                else {
                    ORDERBLOCK(Symbol(), 30, iBarShift(Symbol(), 30, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0);
                    M30 = 0;
                    M30SD = 0;
                    M30LQ = 0;
                    M30FV = 0;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    ObjectSetInteger(0, sparam, OBJPROP_COLOR, clrBlack);
                }
                GlobalVariableSet(Symbol() + "M30", M30);
                GESTIONESD("SD", M30, sparam);
                GESTIONELQ("LQ", M30, sparam);
                GESTIONEFV("FVG", M30, sparam);
                FIBOON("BUTXTD0_FIBO", sparam, M30);
            }
        }
        if(sparam == "BUTXTD0_H1") {
            if(DASHBOARD == false) {
                if(H1 == 0) {
                    ORDERBLOCK(Symbol(), 60, iBarShift(Symbol(), 60, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1);
                    H1 = 1;
                    if(LAST_FLOW == 1)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLimeGreen);
                    if(LAST_FLOW == 2)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrOrangeRed);
                }
                else {
                    ORDERBLOCK(Symbol(), 60, iBarShift(Symbol(), 60, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0);
                    H1 = 0;
                    H1SD = 0;
                    H1LQ = 0;
                    H1FV = 0;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    ObjectSetInteger(0, sparam, OBJPROP_COLOR, clrBlack);
                }
                GlobalVariableSet(Symbol() + "H1", H1);
                GESTIONESD("SD", H1, sparam);
                GESTIONELQ("LQ", H1, sparam);
                GESTIONEFV("FVG", H1, sparam);
                FIBOON("BUTXTD0_FIBO", sparam, H1);
            }
        }
        if(sparam == "BUTXTD0_H4") {
            if(DASHBOARD == false) {
                if(H4 == 0) {
                    ORDERBLOCK(Symbol(), 240, iBarShift(Symbol(), 240, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1);
                    H4 = 1;
                    if(LAST_FLOW == 1)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLimeGreen);
                    if(LAST_FLOW == 2)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrOrangeRed);
                }
                else {
                    ORDERBLOCK(Symbol(), 240, iBarShift(Symbol(), 240, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0);
                    H4 = 0;
                    H4SD = 0;
                    H4LQ = 0;
                    H4FV = 0;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    ObjectSetInteger(0, sparam, OBJPROP_COLOR, clrBlack);
                }
                GlobalVariableSet(Symbol() + "H4", H4);
                GESTIONESD("SD", H4, sparam);
                GESTIONELQ("LQ", H4, sparam);
                GESTIONEFV("FVG", H4, sparam);
                FIBOON("BUTXTD0_FIBO", sparam, H4);
            }
        }
        if(sparam == "BUTXTD0_D1") {
            if(DASHBOARD == false) {
                if(D1 == 0) {
                    ORDERBLOCK(Symbol(), 1440, iBarShift(Symbol(), 1440, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1);
                    D1 = 1;
                    if(LAST_FLOW == 1)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLimeGreen);
                    if(LAST_FLOW == 2)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrOrangeRed);
                }
                else {
                    ORDERBLOCK(Symbol(), 1440, iBarShift(Symbol(), 1440, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0);
                    D1 = 0;
                    D1SD = 0;
                    D1LQ = 0;
                    D1FV = 0;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    ObjectSetInteger(0, sparam, OBJPROP_COLOR, clrBlack);
                }
                GlobalVariableSet(Symbol() + "D1", D1);
                GESTIONESD("SD", D1, sparam);
                GESTIONELQ("LQ", D1, sparam);
                GESTIONEFV("FVG", D1, sparam);
                FIBOON("BUTXTD0_FIBO", sparam, D1);
            }
        }
        if(sparam == "BUTXTD0_W1") {
            if(DASHBOARD == false) {
                if(W1 == 0) {
                    ORDERBLOCK(Symbol(), PERIOD_W1, iBarShift(Symbol(), PERIOD_W1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1);
                    W1 = 1;
                    if(LAST_FLOW == 1)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLimeGreen);
                    if(LAST_FLOW == 2)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrOrangeRed);
                }
                else {
                    ORDERBLOCK(Symbol(), PERIOD_W1, iBarShift(Symbol(), PERIOD_W1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0);
                    W1 = 0;
                    W1SD = 0;
                    W1LQ = 0;
                    W1FV = 0;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    ObjectSetInteger(0, sparam, OBJPROP_COLOR, clrBlack);
                }
                GlobalVariableSet(Symbol() + "W1", W1);
                GESTIONESD("SD", W1, sparam);
                GESTIONELQ("LQ", W1, sparam);
                GESTIONEFV("FVG", W1, sparam);
                FIBOON("BUTXTD0_FIBO", sparam, W1);
            }
        }
        if(sparam == "BUTXTD0_MN1") {
            if(DASHBOARD == false) {
                if(MN1 == 0) {
                    ORDERBLOCK(Symbol(), PERIOD_MN1, iBarShift(Symbol(), PERIOD_MN1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1);
                    MN1 = 1;
                    if(LAST_FLOW == 1)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLimeGreen);
                    if(LAST_FLOW == 2)ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrOrangeRed);
                }
                else {
                    ORDERBLOCK(Symbol(), PERIOD_MN1, iBarShift(Symbol(), PERIOD_MN1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0);
                    MN1 = 0;
                    MN1SD = 0;
                    MN1LQ = 0;
                    MN1FV = 0;
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    ObjectSetInteger(0, sparam, OBJPROP_COLOR, clrBlack);
                }
                GlobalVariableSet(Symbol() + "MN1", MN1);
                GESTIONESD("SD", MN1, sparam);
                GESTIONELQ("LQ", MN1, sparam);
                GESTIONEFV("FVG", MN1, sparam);
                FIBOON("BUTXTD0_FIBO", sparam, MN1);
            }
        }
        if(sparam == "BUTXTD0_M1SD") {
            if(DASHBOARD == false) {
                if(M1SD == 0) {
                    ORDERBLOCKshow(Symbol(), 1, iBarShift(Symbol(), 1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, M1FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    M1SD = 1;
                }
                else {
                    ORDERBLOCKshow(Symbol(), 1, iBarShift(Symbol(), 1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 1, M1FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    M1SD = 0;
                }
                GlobalVariableSet(Symbol() + "M1SD", M1SD);
            }
        }
        if(sparam == "BUTXTD0_M5SD") {
            if(DASHBOARD == false) {
                if(M5SD == 0) {
                    ORDERBLOCKshow(Symbol(), 5, iBarShift(Symbol(), 5, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, M5FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    M5SD = 1;
                }
                else {
                    ORDERBLOCKshow(Symbol(), 5, iBarShift(Symbol(), 5, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 1, M5FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    M5SD = 0;
                }
                GlobalVariableSet(Symbol() + "M5SD", M5SD);
            }
        }
        if(sparam == "BUTXTD0_M15SD") {
            if(DASHBOARD == false) {
                if(M15SD == 0) {
                    ORDERBLOCKshow(Symbol(), 15, iBarShift(Symbol(), 15, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, M15FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    M15SD = 1;
                }
                else {
                    ORDERBLOCKshow(Symbol(), 15, iBarShift(Symbol(), 15, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 1, M15FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    M15SD = 0;
                }
                GlobalVariableSet(Symbol() + "M15SD", M15SD);
            }
        }
        if(sparam == "BUTXTD0_M30SD") {
            if(DASHBOARD == false) {
                if(M30SD == 0) {
                    ORDERBLOCKshow(Symbol(), 30, iBarShift(Symbol(), 30, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, M30FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    M30SD = 1;
                }
                else {
                    ORDERBLOCKshow(Symbol(), 30, iBarShift(Symbol(), 30, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 1, M30FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    M30SD = 0;
                }
                GlobalVariableSet(Symbol() + "M30SD", M30SD);
            }
        }
        if(sparam == "BUTXTD0_H1SD") {
            if(DASHBOARD == false) {
                if(H1SD == 0) {
                    ORDERBLOCKshow(Symbol(), 60, iBarShift(Symbol(), 60, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, H1FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    H1SD = 1;
                }
                else {
                    ORDERBLOCKshow(Symbol(), 60, iBarShift(Symbol(), 60, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 1, H1FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    H1SD = 0;
                }
                GlobalVariableSet(Symbol() + "H1SD", H1SD);
            }
        }
        if(sparam == "BUTXTD0_H4SD") {
            if(DASHBOARD == false) {
                if(H4SD == 0) {
                    ORDERBLOCKshow(Symbol(), 240, iBarShift(Symbol(), 240, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, H4FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    H4SD = 1;
                }
                else {
                    ORDERBLOCKshow(Symbol(), 240, iBarShift(Symbol(), 240, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 1, H4FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    H4SD = 0;
                }
                GlobalVariableSet(Symbol() + "H4SD", H4SD);
            }
        }
        if(sparam == "BUTXTD0_D1SD") {
            if(DASHBOARD == false) {
                if(D1SD == 0) {
                    ORDERBLOCKshow(Symbol(), 1440, iBarShift(Symbol(), 1440, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, D1FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    D1SD = 1;
                }
                else {
                    ORDERBLOCKshow(Symbol(), 1440, iBarShift(Symbol(), 1440, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 1, D1FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    D1SD = 0;
                }
                GlobalVariableSet(Symbol() + "D1SD", D1SD);
            }
        }
        if(sparam == "BUTXTD0_W1SD") {
            if(DASHBOARD == false) {
                if(W1SD == 0) {
                    ORDERBLOCKshow(Symbol(), PERIOD_W1, iBarShift(Symbol(), PERIOD_W1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, W1FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    W1SD = 1;
                }
                else {
                    ORDERBLOCKshow(Symbol(), PERIOD_W1, iBarShift(Symbol(), PERIOD_W1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 1, W1FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    W1SD = 0;
                }
                GlobalVariableSet(Symbol() + "W1SD", W1SD);
            }
        }
        if(sparam == "BUTXTD0_MN1SD") {
            if(DASHBOARD == false) {
                if(MN1SD == 0) {
                    ORDERBLOCKshow(Symbol(), PERIOD_MN1, iBarShift(Symbol(), PERIOD_MN1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, MN1FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    MN1SD = 1;
                }
                else {
                    ORDERBLOCKshow(Symbol(), PERIOD_MN1, iBarShift(Symbol(), PERIOD_MN1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 1, MN1FV);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    MN1SD = 0;
                }
                GlobalVariableSet(Symbol() + "MN1SD", MN1SD);
            }
        }
        if(sparam == "BUTXTD0_M1LQ") {
            if(DASHBOARD == false) {
                if(M1LQ == 0) {
                    ORDERBLOCKshowliq(Symbol(), 1, iBarShift(Symbol(), 1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    M1LQ = 1;
                }
                else {
                    ORDERBLOCKshowliq(Symbol(), 1, iBarShift(Symbol(), 1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 0, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    M1LQ = 0;
                }
                GlobalVariableSet(Symbol() + "M1LQ", M1LQ);
            }
        }
        if(sparam == "BUTXTD0_M5LQ") {
            if(DASHBOARD == false) {
                if(M5LQ == 0) {
                    ORDERBLOCKshowliq(Symbol(), 5, iBarShift(Symbol(), 5, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    M5LQ = 1;
                }
                else {
                    ORDERBLOCKshowliq(Symbol(), 5, iBarShift(Symbol(), 5, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 0, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    M5LQ = 0;
                }
                GlobalVariableSet(Symbol() + "M5LQ", M5LQ);
            }
        }
        if(sparam == "BUTXTD0_M15LQ") {
            if(DASHBOARD == false) {
                if(M15LQ == 0) {
                    ORDERBLOCKshowliq(Symbol(), 15, iBarShift(Symbol(), 15, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    M15LQ = 1;
                }
                else {
                    ORDERBLOCKshowliq(Symbol(), 15, iBarShift(Symbol(), 15, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 0, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    M15LQ = 0;
                }
                GlobalVariableSet(Symbol() + "M15LQ", M15LQ);
            }
        }
        if(sparam == "BUTXTD0_M30LQ") {
            if(DASHBOARD == false) {
                if(M30LQ == 0) {
                    ORDERBLOCKshowliq(Symbol(), 30, iBarShift(Symbol(), 30, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    M30LQ = 1;
                }
                else {
                    ORDERBLOCKshowliq(Symbol(), 30, iBarShift(Symbol(), 30, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 0, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    M30LQ = 0;
                }
                GlobalVariableSet(Symbol() + "M30LQ", M30LQ);
            }
        }
        if(sparam == "BUTXTD0_H1LQ") {
            if(DASHBOARD == false) {
                if(H1LQ == 0) {
                    ORDERBLOCKshowliq(Symbol(), 60, iBarShift(Symbol(), 60, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    H1LQ = 1;
                }
                else {
                    ORDERBLOCKshowliq(Symbol(), 60, iBarShift(Symbol(), 60, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 0, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    H1LQ = 0;
                }
                GlobalVariableSet(Symbol() + "H1LQ", H1LQ);
            }
        }
        if(sparam == "BUTXTD0_H4LQ") {
            if(DASHBOARD == false) {
                if(H4LQ == 0) {
                    ORDERBLOCKshowliq(Symbol(), 240, iBarShift(Symbol(), 240, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    H4LQ = 1;
                }
                else {
                    ORDERBLOCKshowliq(Symbol(), 240, iBarShift(Symbol(), 240, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 0, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    H4LQ = 0;
                }
                GlobalVariableSet(Symbol() + "H4LQ", H4LQ);
            }
        }
        if(sparam == "BUTXTD0_D1LQ") {
            if(DASHBOARD == false) {
                if(D1LQ == 0) {
                    ORDERBLOCKshowliq(Symbol(), 1440, iBarShift(Symbol(), 1440, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    D1LQ = 1;
                }
                else {
                    ORDERBLOCKshowliq(Symbol(), 1440, iBarShift(Symbol(), 1440, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 0, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    D1LQ = 0;
                }
                GlobalVariableSet(Symbol() + "D1LQ", D1LQ);
            }
        }
        if(sparam == "BUTXTD0_W1LQ") {
            if(DASHBOARD == false) {
                if(W1LQ == 0) {
                    ORDERBLOCKshowliq(Symbol(), PERIOD_W1, iBarShift(Symbol(), PERIOD_W1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    W1LQ = 1;
                }
                else {
                    ORDERBLOCKshowliq(Symbol(), PERIOD_W1, iBarShift(Symbol(), PERIOD_W1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 0, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    W1LQ = 0;
                }
                GlobalVariableSet(Symbol() + "W1LQ", W1LQ);
            }
        }
        if(sparam == "BUTXTD0_MN1LQ") {
            if(DASHBOARD == false) {
                if(MN1LQ == 0) {
                    ORDERBLOCKshowliq(Symbol(), PERIOD_MN1, iBarShift(Symbol(), PERIOD_MN1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 1, 1, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    MN1LQ = 1;
                }
                else {
                    ORDERBLOCKshowliq(Symbol(), PERIOD_MN1, iBarShift(Symbol(), PERIOD_MN1, iTime(Symbol(), 0, CURRCAND)), 1, USE_LSB_SIGNAL_ENTRY, 0, 0, 1);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    MN1LQ = 0;
                }
                GlobalVariableSet(Symbol() + "MN1LQ", MN1LQ);
            }
        }
        if(sparam == "BUTXTD0_M1FVG") {
            if(DASHBOARD == false) {
                if(M1FV == 0) {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    M1FV = 1;
                    int CANDELABRO = 0;
                    if(GlobalVariableGet(Symbol() + "BARRE") != 0) CANDELABRO = iBarShift(Symbol(), 1, iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
                    FVGfunc(M1FV, Symbol(), 1, CANDELABRO);
                }
                else {
                    M1FV = 0;
                    FVGfunc(M1FV, Symbol(), 1, 0);
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                }
                GlobalVariableSet(Symbol() + "M1FVG", M1FV);
            }
        }
        if(sparam == "BUTXTD0_M5FVG") {
            if(DASHBOARD == false) {
                if(M5FV == 0) {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    M5FV = 1;
                    int CANDELABRO = 0;
                    if(GlobalVariableGet(Symbol() + "BARRE") != 0) CANDELABRO = iBarShift(Symbol(), 5, iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
                    FVGfunc(M5FV, Symbol(), 5, CANDELABRO);
                }
                else {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    M5FV = 0;
                    FVGfunc(M5FV, Symbol(), 5, 0);
                }
                GlobalVariableSet(Symbol() + "M5FVG", M5FV);
            }
        }
        if(sparam == "BUTXTD0_M15FVG") {
            if(DASHBOARD == false) {
                if(M15FV == 0) {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    M15FV = 1;
                    int CANDELABRO = 0;
                    if(GlobalVariableGet(Symbol() + "BARRE") != 0) CANDELABRO = iBarShift(Symbol(), 15, iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
                    FVGfunc(M15FV, Symbol(), 15, CANDELABRO);
                }
                else {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    M15FV = 0;
                    FVGfunc(M15FV, Symbol(), 15, 0);
                }
                GlobalVariableSet(Symbol() + "M15FVG", M15FV);
            }
        }
        if(sparam == "BUTXTD0_M30FVG") {
            if(DASHBOARD == false) {
                if(M30FV == 0) {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    M30FV = 1;
                    int CANDELABRO = 0;
                    if(GlobalVariableGet(Symbol() + "BARRE") != 0) CANDELABRO = iBarShift(Symbol(), 30, iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
                    FVGfunc(M30FV, Symbol(), 30, CANDELABRO);
                }
                else {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    M30FV = 0;
                    FVGfunc(M30FV, Symbol(), 30, 0);
                }
                GlobalVariableSet(Symbol() + "M30FVG", M30FV);
            }
        }
        if(sparam == "BUTXTD0_H1FVG") {
            if(DASHBOARD == false) {
                if(H1FV == 0) {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    H1FV = 1;
                    int CANDELABRO = 0;
                    if(GlobalVariableGet(Symbol() + "BARRE") != 0) CANDELABRO = iBarShift(Symbol(), 60, iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
                    FVGfunc(H1FV, Symbol(), 60, CANDELABRO);
                }
                else {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    H1FV = 0;
                    FVGfunc(H1FV, Symbol(), 60, 0);
                }
                GlobalVariableSet(Symbol() + "H1FVG", H1FV);
            }
        }
        if(sparam == "BUTXTD0_H4FVG") {
            if(DASHBOARD == false) {
                if(H4FV == 0) {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    H4FV = 1;
                    int CANDELABRO = 0;
                    if(GlobalVariableGet(Symbol() + "BARRE") != 0) CANDELABRO = iBarShift(Symbol(), 240, iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
                    FVGfunc(H4FV, Symbol(), 240, CANDELABRO);
                }
                else {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    H4FV = 0;
                    FVGfunc(H4FV, Symbol(), 240, 0);
                }
                GlobalVariableSet(Symbol() + "H4FVG", H4FV);
            }
        }
        if(sparam == "BUTXTD0_D1FVG") {
            if(DASHBOARD == false) {
                if(D1FV == 0) {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    D1FV = 1;
                    int CANDELABRO = 0;
                    if(GlobalVariableGet(Symbol() + "BARRE") != 0) CANDELABRO = iBarShift(Symbol(), 1440, iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
                    FVGfunc(D1FV, Symbol(), 1440, CANDELABRO);
                }
                else {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    D1FV = 0;
                    FVGfunc(D1FV, Symbol(), 1440, 0);
                }
                GlobalVariableSet(Symbol() + "D1FVG", D1FV);
            }
        }
        if(sparam == "BUTXTD0_W1FVG") {
            if(DASHBOARD == false) {
                if(W1FV == 0) {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    W1FV = 1;
                    int CANDELABRO = 0;
                    if(GlobalVariableGet(Symbol() + "BARRE") != 0) CANDELABRO = iBarShift(Symbol(), PERIOD_W1, iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
                    FVGfunc(W1FV, Symbol(), PERIOD_W1, CANDELABRO);
                }
                else {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    W1FV = 0;
                    FVGfunc(W1FV, Symbol(), PERIOD_W1, 0);
                }
                GlobalVariableSet(Symbol() + "W1FVG", W1FV);
            }
        }
        if(sparam == "BUTXTD0_MN1FVG") {
            if(DASHBOARD == false) {
                if(MN1FV == 0) {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightSeaGreen);
                    MN1FV = 1;
                    int CANDELABRO = 0;
                    if(GlobalVariableGet(Symbol() + "BARRE") != 0) CANDELABRO = iBarShift(Symbol(), PERIOD_MN1, iTime(Symbol(), GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
                    FVGfunc(MN1FV, Symbol(), PERIOD_MN1, CANDELABRO);
                }
                else {
                    ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, clrLightGray);
                    MN1FV = 0;
                    FVGfunc(MN1FV, Symbol(), PERIOD_MN1, 0);
                }
                GlobalVariableSet(Symbol() + "MN1FVG", MN1FV);
            }
        }
        if(ALSYS != 0) {
            int ver = 0;
            string BUTT = "";
            switch(Period()) {
            case 1:
                BUTT = "M1";
                ver = M1SD;
                break;
            case 5 :
                BUTT = "M5";
                ver = M5SD;
                break;
            case 15 :
                BUTT = "M15";
                ver = M15SD;
                break;
            case 30 :
                BUTT = "M30";
                ver = M30SD;
                break;
            case 60 :
                BUTT = "H1";
                ver = H1SD;
                break;
            case 240 :
                BUTT = "H4";
                ver = H4SD;
                break;
            case 1440 :
                BUTT = "D1";
                ver = D1SD;
                break;
            case PERIOD_W1 :
                BUTT = "W1";
                ver = W1SD;
                break;
            case PERIOD_MN1 :
                BUTT = "MN1";
                ver = MN1SD;
                break;
            }
            if(ObjectFind(0, "LOCKED0") < 0) {
                RectLabelCreate(0, "LOCKED2", 0, 0, (int)ObjectGetInteger(0, "BUTT_TD0", OBJPROP_YDISTANCE), (int)ObjectGetInteger(0, "BUTT_TD0", OBJPROP_XSIZE), (int)ObjectGetInteger(0, "BUTT_TD0", OBJPROP_YSIZE), clrBlack, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1);
                RectLabelCreate(0, "LOCKED0", 0, 0, (int)ObjectGetInteger(0, "BUTT_TD0", OBJPROP_YDISTANCE) - (int)ObjectGetInteger(0, "BUTXTD0_ALERT", OBJPROP_YSIZE), 0, (int)ObjectGetInteger(0, "BUTT_TD0", OBJPROP_YSIZE), clrBlack, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1);
                RectLabelCreate(0, "LOCKED1", 0, 0, (int)ObjectGetInteger(0, "BUTT_TD0", OBJPROP_YDISTANCE) - (int)ObjectGetInteger(0, "BUTXTD0_ALERT", OBJPROP_YSIZE), 0, (int)ObjectGetInteger(0, "BUTT_TD0", OBJPROP_YSIZE), clrBlack, BORDER_FLAT, CORNER_LEFT_LOWER, clrBlack, STYLE_SOLID, 1);
                RectLabelChangeSize(0, "LOCKED0", (int)ObjectGetInteger(0, "BUTXTD0_" + BUTT, OBJPROP_XDISTANCE), (int)ObjectGetInteger(0, "BUTT_TD0", OBJPROP_YDISTANCE) - (int)ObjectGetInteger(0, "BUTXTD0_ALERT", OBJPROP_YSIZE));
                RectLabelMove(0, "LOCKED1", (int)ObjectGetInteger(0, "BUTXTD0_" + BUTT, OBJPROP_XDISTANCE) + (int)ObjectGetInteger(0, "BUTXTD0_" + BUTT, OBJPROP_XSIZE), (int)ObjectGetInteger(0, "BUTT_TD0", OBJPROP_YDISTANCE) - (int)ObjectGetInteger(0, "BUTXTD0_ALERT", OBJPROP_YSIZE));
                RectLabelChangeSize(0, "LOCKED1", ((int)ObjectGetInteger(0, "BUTXTD0_STRA1", OBJPROP_XDISTANCE) + (int)ObjectGetInteger(0, "BUTXTD0_STRA1", OBJPROP_XSIZE)) - ((int)ObjectGetInteger(0, "BUTXTD0_" + BUTT, OBJPROP_XDISTANCE) + (int)ObjectGetInteger(0, "BUTXTD0_" + BUTT, OBJPROP_XSIZE)), (int)ObjectGetInteger(0, "BUTT_TD0", OBJPROP_YDISTANCE) - (int)ObjectGetInteger(0, "BUTXTD0_ALERT", OBJPROP_YSIZE));
            }
        }
    }
}
//+------------------------------------------------------------------+
//| Get Automated Trading Statistics                                |
//+------------------------------------------------------------------+
string GetAutoTradingStats()
{
    int totalAutoTrades = 0;
    int autoBuyTrades = 0;
    int autoSellTrades = 0;
    double totalProfit = 0.0;

// Count current automated trades
    for(int i = OrdersTotal() - 1; i >= 0; i--) {
        if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if(OrderSymbol() != Symbol()) continue;

            string comment = OrderComment();
            if(StringFind(comment, "AUTO_BUY_") == 0) {
                autoBuyTrades++;
                totalAutoTrades++;
                totalProfit += OrderProfit() + OrderSwap() + OrderCommission();
            }
            else if(StringFind(comment, "AUTO_SELL_") == 0) {
                autoSellTrades++;
                totalAutoTrades++;
                totalProfit += OrderProfit() + OrderSwap() + OrderCommission();
            }
        }
    }

    string stats = "AUTO TRADES: " + IntegerToString(totalAutoTrades) +
                   " | BUY: " + IntegerToString(autoBuyTrades) +
                   " | SELL: " + IntegerToString(autoSellTrades) +
                   " | P&L: " + DoubleToString(totalProfit, 2);

    return stats;
}

//+------------------------------------------------------------------+
//| Enhanced Trade Validation with Market Conditions               |
//+------------------------------------------------------------------+
bool ValidateMarketConditions(int orderType)
{
// Check spread conditions
    double spread = MarketInfo(Symbol(), MODE_SPREAD) * Point;
    double maxSpread = 30 * Point * (1 + 9 * (Digits == 3 || Digits == 5));

    if(spread > maxSpread) {
        Print("AUTO TRADE: Spread too wide: ", spread / Point, " points");
        return false;
    }

// Check market hours (avoid news times)
    int hour = TimeHour(TimeCurrent());
    if(hour < 2 || hour > 22) {
        Print("AUTO TRADE: Outside optimal trading hours");
        return false;
    }

// Check volatility conditions
    double atr = iATR(Symbol(), Period(), 14, 1);
    double minATR = 20 * Point * (1 + 9 * (Digits == 3 || Digits == 5));

    if(atr < minATR) {
        Print("AUTO TRADE: Low volatility conditions, ATR: ", atr / Point);
        return false;
    }

// Additional market condition checks can be added here
// (e.g., economic calendar events, margin requirements, etc.)

    return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int RILANCIAfun(int RESET, string SIMBA)
{
    if( RESET == 9) {
        M1CANDLE = 0;
        M5CANDLE = 0;
        M15CANDLE = 0;
        M30CANDLE = 0;
        H1CANDLE = 0;
        H4CANDLE = 0;
        D1CANDLE = 0;
        W1CANDLE = 0;
        MN1CANDLE = 0;
        M1 = 0;
        M5 = 0;
        M15 = 0;
        M30 = 0;
        H1 = 0;
        H4 = 0;
        D1 = 0;
        W1 = 0;
        MN1 = 0;
        GlobalVariableSet(SIMBA + "M1", M1);
        GlobalVariableSet(SIMBA + "M5", M5);
        GlobalVariableSet(SIMBA + "M15", M15);
        GlobalVariableSet(SIMBA + "M30", M30);
        GlobalVariableSet(SIMBA + "H1", H1);
        GlobalVariableSet(SIMBA + "H4", H4);
        GlobalVariableSet(SIMBA + "D1", D1);
        GlobalVariableSet(SIMBA + "W1", W1);
        GlobalVariableSet(SIMBA + "MN1", MN1);
    }
    M1CANDLE = 0;
    M5CANDLE = 0;
    M15CANDLE = 0;
    M30CANDLE = 0;
    H1CANDLE = 0;
    H4CANDLE = 0;
    D1CANDLE = 0;
    W1CANDLE = 0;
    MN1CANDLE = 0;
    int TEM = GlobalVariableGet(SIMBA + "TFBARRE");
    if(ALSYS == 1) {
        ObjectSetInteger(0, "BUTXTD0_ALERT", OBJPROP_BGCOLOR, clrAquamarine);
        ObjectSetInteger(0, "BUTXTD0_ALERT", OBJPROP_STATE, true);
    }
    if(STRA0_MANUAL == 1) {
        ObjectSetInteger(0, "BUTXTD0_STRA0", OBJPROP_BGCOLOR, clrLightSeaGreen);
        ObjectSetInteger(0, "BUTXTD0_STRA0", OBJPROP_STATE, true);
    }
    else {
        ObjectSetInteger(0, "BUTXTD0_STRA0", OBJPROP_BGCOLOR, clrLightGray);
        ObjectSetInteger(0, "BUTXTD0_STRA0", OBJPROP_STATE, false);
    }
    if(STRA1 == 1) {
        ObjectSetInteger(0, "BUTXTD0_STRA1", OBJPROP_BGCOLOR, clrLightSeaGreen);
        ObjectSetInteger(0, "BUTXTD0_STRA1", OBJPROP_STATE, true);
    }
    else {
        ObjectSetInteger(0, "BUTXTD0_STRA1", OBJPROP_BGCOLOR, clrLightGray);
        ObjectSetInteger(0, "BUTXTD0_STRA1", OBJPROP_STATE, false);
    }
    if(STRA2 == 1) {
        ObjectSetInteger(0, "BUTXTD0_STRA2", OBJPROP_BGCOLOR, clrLightSeaGreen);
        ObjectSetInteger(0, "BUTXTD0_STRA2", OBJPROP_STATE, true);
    }
    else {
        ObjectSetInteger(0, "BUTXTD0_STRA2", OBJPROP_BGCOLOR, clrLightGray);
        ObjectSetInteger(0, "BUTXTD0_STRA2", OBJPROP_STATE, false);
    }
    if(STRA3 == 1) {
        ObjectSetInteger(0, "BUTXTD0_STRA3", OBJPROP_BGCOLOR, clrLightSeaGreen);
        ObjectSetInteger(0, "BUTXTD0_STRA3", OBJPROP_STATE, true);
    }
    else {
        ObjectSetInteger(0, "BUTXTD0_STRA3", OBJPROP_BGCOLOR, clrLightGray);
        ObjectSetInteger(0, "BUTXTD0_STRA3", OBJPROP_STATE, false);
    }
    if(STRA4 == 1)  {
        ObjectSetInteger(0, "BUTXTD0_STRA4", OBJPROP_BGCOLOR, clrLightSeaGreen);
        ObjectSetInteger(0, "BUTXTD0_STRA4", OBJPROP_STATE, true);
    }
    else {
        ObjectSetInteger(0, "BUTXTD0_STRA4", OBJPROP_BGCOLOR, clrLightGray);
        ObjectSetInteger(0, "BUTXTD0_STRA4", OBJPROP_STATE, false);
    }
    if(STRA5 == 1)  {
        ObjectSetInteger(0, "BUTXTD0_STRA5", OBJPROP_BGCOLOR, clrLightSeaGreen);
        ObjectSetInteger(0, "BUTXTD0_STRA5", OBJPROP_STATE, true);
    }
    else {
        ObjectSetInteger(0, "BUTXTD0_STRA5", OBJPROP_BGCOLOR, clrLightGray);
        ObjectSetInteger(0, "BUTXTD0_STRA5", OBJPROP_STATE, false);
    }
    if(M1 == 1) {
        if(BARRE_DEVIATION == 0) TEM = 1;
        ORDERBLOCK(SIMBA, 1, iBarShift(SIMBA, 1, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(SIMBA, 1, iBarShift(SIMBA, 1, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, M1SD, M1LQ, M1FV);
        ORDERBLOCKshowliq(SIMBA, 1, iBarShift(SIMBA, 1, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, M1SD, M1LQ, M1FV);
        FVGfunc(M1FV, SIMBA, 1, iBarShift(SIMBA, 1, iTime(SIMBA, TEM, BARRE_DEVIATION)));
        ObjectSetInteger(0, "BUTXTD0_M1", OBJPROP_STATE, true);
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_M1", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_M1", OBJPROP_BGCOLOR, clrOrangeRed);
        GESTIONESD("SD", M1, "BUTXTD0_M1");
        GESTIONELQ("LQ", M1, "BUTXTD0_M1");
        GESTIONEFV("FVG", M1, "BUTXTD0_M1");
        if(ALSYS == 1 && Period() == 1) ALERTPOPUP(SIMBA, 1, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);
    }
    if(M5 == 1) {
        if(BARRE_DEVIATION == 0) TEM = 5;
        ORDERBLOCK(SIMBA, 5, iBarShift(SIMBA, 5, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(SIMBA, 5, iBarShift(SIMBA, 5, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, M5SD, M5LQ, M5FV);
        ORDERBLOCKshowliq(SIMBA, 5, iBarShift(SIMBA, 5, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, M5SD, M5LQ, M5FV);
        FVGfunc(M5FV, SIMBA, 5, iBarShift(SIMBA, 5, iTime(SIMBA, TEM, BARRE_DEVIATION)));
        ObjectSetInteger(0, "BUTXTD0_M5", OBJPROP_STATE, true);
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_M5", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_M5", OBJPROP_BGCOLOR, clrOrangeRed);
        GESTIONESD("SD", M5, "BUTXTD0_M5");
        GESTIONELQ("LQ", M5, "BUTXTD0_M5");
        GESTIONEFV("FVG", M5, "BUTXTD0_M5");
        if(ALSYS == 1 && Period() == 5) ALERTPOPUP(SIMBA, 5, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);
    }
    if(M15 == 1) {
        if(BARRE_DEVIATION == 0) TEM = 15;
        ORDERBLOCK(SIMBA, 15, iBarShift(SIMBA, 15, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(SIMBA, 15, iBarShift(SIMBA, 15, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, M15SD, M15LQ, M15FV);
        ORDERBLOCKshowliq(SIMBA, 15, iBarShift(SIMBA, 15, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, M15SD, M15LQ, M15FV);
        FVGfunc(M15FV, SIMBA, 15, iBarShift(SIMBA, 15, iTime(SIMBA, TEM, BARRE_DEVIATION)));
        ObjectSetInteger(0, "BUTXTD0_M15", OBJPROP_STATE, true);
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_M15", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_M15", OBJPROP_BGCOLOR, clrOrangeRed);
        GESTIONESD("SD", M15, "BUTXTD0_M15");
        GESTIONELQ("LQ", M15, "BUTXTD0_M15");
        GESTIONEFV("FVG", M15, "BUTXTD0_M15");
        if(ALSYS == 1 && Period() == 15) ALERTPOPUP(SIMBA, 15, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);
    }
    if(M30 == 1) {
        if(BARRE_DEVIATION == 0) TEM = 30;
        ORDERBLOCK(SIMBA, 30, iBarShift(SIMBA, 30, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(SIMBA, 30, iBarShift(SIMBA, 30, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, M30SD, M30LQ, M30FV);
        ORDERBLOCKshowliq(SIMBA, 30, iBarShift(SIMBA, 30, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, M30SD, M30LQ, M30FV);
        FVGfunc(M30FV, SIMBA, 30, iBarShift(SIMBA, 30, iTime(SIMBA, TEM, BARRE_DEVIATION)));
        ObjectSetInteger(0, "BUTXTD0_M30", OBJPROP_STATE, true);
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_M30", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_M30", OBJPROP_BGCOLOR, clrOrangeRed);
        GESTIONESD("SD", M30, "BUTXTD0_M30");
        GESTIONELQ("LQ", M30, "BUTXTD0_M30");
        GESTIONEFV("FVG", M30, "BUTXTD0_M30");
        if(ALSYS == 1 && Period() == 30) ALERTPOPUP(SIMBA, 30, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);
    }
    if(H1 == 1) {
        if(BARRE_DEVIATION == 0) TEM = 60;
        ORDERBLOCK(SIMBA, 60, iBarShift(SIMBA, 60, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(SIMBA, 60, iBarShift(SIMBA, 60, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, H1SD, H1LQ, H1FV);
        ORDERBLOCKshowliq(SIMBA, 60, iBarShift(SIMBA, 60, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, H1SD, H1LQ, H1FV);
        FVGfunc(H1FV, SIMBA, 60, iBarShift(SIMBA, 60, iTime(SIMBA, TEM, BARRE_DEVIATION)));
        ObjectSetInteger(0, "BUTXTD0_H1", OBJPROP_STATE, true);
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_H1", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_H1", OBJPROP_BGCOLOR, clrOrangeRed);
        GESTIONESD("SD", H1, "BUTXTD0_H1");
        GESTIONELQ("LQ", H1, "BUTXTD0_H1");
        GESTIONEFV("FVG", H1, "BUTXTD0_H1");
        if(ALSYS == 1 && Period() == 60) ALERTPOPUP(SIMBA, 60, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);
    }
    if(H4 == 1) {
        if(BARRE_DEVIATION == 0) TEM = 240;
        ORDERBLOCK(SIMBA, 240, iBarShift(SIMBA, 240, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(SIMBA, 240, iBarShift(SIMBA, 240, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, H4SD, H4LQ, H4FV);
        ORDERBLOCKshowliq(SIMBA, 240, iBarShift(SIMBA, 240, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, H4SD, H4LQ, H4FV);
        FVGfunc(H4FV, SIMBA, 240, iBarShift(SIMBA, 240, iTime(SIMBA, TEM, BARRE_DEVIATION)));
        ObjectSetInteger(0, "BUTXTD0_H4", OBJPROP_STATE, true);
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_H4", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_H4", OBJPROP_BGCOLOR, clrOrangeRed);
        GESTIONESD("SD", H4, "BUTXTD0_H4");
        GESTIONELQ("LQ", H4, "BUTXTD0_H4");
        GESTIONEFV("FVG", H4, "BUTXTD0_H4");
        if(ALSYS == 1 && Period() == 240) ALERTPOPUP(SIMBA, 240, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);
    }
    if(D1 == 1) {
        if(BARRE_DEVIATION == 0) TEM = 1440;
        ORDERBLOCK(SIMBA, 1440, iBarShift(SIMBA, 1440, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(SIMBA, 1440, iBarShift(SIMBA, 1440, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, D1SD, D1LQ, D1FV);
        ORDERBLOCKshowliq(SIMBA, 1440, iBarShift(SIMBA, 1440, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, D1SD, D1LQ, D1FV);
        FVGfunc(D1FV, SIMBA, 1440, iBarShift(SIMBA, 1440, iTime(SIMBA, TEM, BARRE_DEVIATION)));
        ObjectSetInteger(0, "BUTXTD0_D1", OBJPROP_STATE, true);
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_D1", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_D1", OBJPROP_BGCOLOR, clrOrangeRed);
        GESTIONESD("SD", D1, "BUTXTD0_D1");
        GESTIONELQ("LQ", D1, "BUTXTD0_D1");
        GESTIONEFV("FVG", D1, "BUTXTD0_D1");
        if(ALSYS == 1 && Period() == 1440) ALERTPOPUP(SIMBA, 1440, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);
    }
    if(W1 == 1) {
        if(BARRE_DEVIATION == 0) TEM = PERIOD_W1;
        ORDERBLOCK(SIMBA, PERIOD_W1, iBarShift(SIMBA, PERIOD_W1, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(SIMBA, PERIOD_W1, iBarShift(SIMBA, PERIOD_W1, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, W1SD, W1LQ, W1FV);
        ORDERBLOCKshowliq(SIMBA, PERIOD_W1, iBarShift(SIMBA, PERIOD_W1, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, W1SD, W1LQ, W1FV);
        FVGfunc(W1FV, SIMBA, PERIOD_W1, iBarShift(SIMBA, PERIOD_W1, iTime(SIMBA, TEM, BARRE_DEVIATION)));
        ObjectSetInteger(0, "BUTXTD0_W1", OBJPROP_STATE, true);
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_W1", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_W1", OBJPROP_BGCOLOR, clrOrangeRed);
        GESTIONESD("SD", W1, "BUTXTD0_W1");
        GESTIONELQ("LQ", W1, "BUTXTD0_W1");
        GESTIONEFV("FVG", W1, "BUTXTD0_W1");
        if(ALSYS == 1 && Period() == PERIOD_W1) ALERTPOPUP(SIMBA, PERIOD_W1, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);
    }
    if(MN1 == 1) {
        if(BARRE_DEVIATION == 0) TEM = PERIOD_MN1;
        ORDERBLOCK(SIMBA, PERIOD_MN1, iBarShift(SIMBA, PERIOD_MN1, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 1);
        ORDERBLOCKshow(SIMBA, PERIOD_MN1, iBarShift(SIMBA, PERIOD_MN1, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, MN1SD, MN1LQ, MN1FV);
        ORDERBLOCKshowliq(SIMBA, PERIOD_MN1, iBarShift(SIMBA, PERIOD_MN1, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, MN1SD, MN1LQ, MN1FV);
        FVGfunc(MN1FV, SIMBA, PERIOD_MN1, iBarShift(SIMBA, PERIOD_MN1, iTime(SIMBA, TEM, BARRE_DEVIATION)));
        ObjectSetInteger(0, "BUTXTD0_MN1", OBJPROP_STATE, true);
        if(LAST_FLOW == 1)ObjectSetInteger(0, "BUTXTD0_MN1", OBJPROP_BGCOLOR, clrLimeGreen);
        if(LAST_FLOW == 2)ObjectSetInteger(0, "BUTXTD0_MN1", OBJPROP_BGCOLOR, clrOrangeRed);
        GESTIONESD("SD", MN1, "BUTXTD0_MN1");
        GESTIONELQ("LQ", MN1, "BUTXTD0_MN1");
        GESTIONEFV("FVG", MN1, "BUTXTD0_MN1");
        if(ALSYS == 1 && Period() == PERIOD_MN1) ALERTPOPUP(SIMBA, PERIOD_MN1, LAST_FLOW, LAST_HH, LAST_LL, LAST_BREAKER, LAST_LEG0flow);
    }
    TEM = 0;
    if(M1 == 0) ORDERBLOCK(SIMBA, 1, iBarShift(SIMBA, 1, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 0);
    if(M5 == 0) ORDERBLOCK(SIMBA, 5, iBarShift(SIMBA, 5, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 0);
    if(M15 == 0) ORDERBLOCK(SIMBA, 15, iBarShift(SIMBA, 15, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 0);
    if(M30 == 0) ORDERBLOCK(SIMBA, 30, iBarShift(SIMBA, 30, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 0);
    if(H1 == 0) ORDERBLOCK(SIMBA, 60, iBarShift(SIMBA, 60, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 0);
    if(H4 == 0) ORDERBLOCK(SIMBA, 240, iBarShift(SIMBA, 240, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 0);
    if(D1 == 0) ORDERBLOCK(SIMBA, 1440, iBarShift(SIMBA, 1440, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 0);
    if(W1 == 0) ORDERBLOCK(SIMBA, PERIOD_W1, iBarShift(SIMBA, PERIOD_W1, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 0);
    if(MN1 == 0) ORDERBLOCK(SIMBA, PERIOD_MN1, iBarShift(SIMBA, PERIOD_MN1, iTime(SIMBA, TEM, BARRE_DEVIATION)), 1, USE_LSB_SIGNAL_ENTRY, 0);
    if(M1 == 0) {
        ObjectSetInteger(0, "BUTXTD0_M1", OBJPROP_STATE, false);
        ObjectSetInteger(0, "BUTXTD0_M1", OBJPROP_BGCOLOR, clrLightGray);
    }
    if(M5 == 0) {
        ObjectSetInteger(0, "BUTXTD0_M5", OBJPROP_STATE, false);
        ObjectSetInteger(0, "BUTXTD0_M5", OBJPROP_BGCOLOR, clrLightGray);
    }
    if(M15 == 0) {
        ObjectSetInteger(0, "BUTXTD0_M15", OBJPROP_STATE, false);
        ObjectSetInteger(0, "BUTXTD0_M15", OBJPROP_BGCOLOR, clrLightGray);
    }
    if(M30 == 0) {
        ObjectSetInteger(0, "BUTXTD0_M30", OBJPROP_STATE, false);
        ObjectSetInteger(0, "BUTXTD0_M30", OBJPROP_BGCOLOR, clrLightGray);
    }
    if(H1 == 0) {
        ObjectSetInteger(0, "BUTXTD0_H1", OBJPROP_STATE, false);
        ObjectSetInteger(0, "BUTXTD0_H1", OBJPROP_BGCOLOR, clrLightGray);
    }
    if(H4 == 0) {
        ObjectSetInteger(0, "BUTXTD0_M4", OBJPROP_STATE, false);
        ObjectSetInteger(0, "BUTXTD0_H4", OBJPROP_BGCOLOR, clrLightGray);
    }
    if(D1 == 0) {
        ObjectSetInteger(0, "BUTXTD0_D1", OBJPROP_STATE, false);
        ObjectSetInteger(0, "BUTXTD0_D1", OBJPROP_BGCOLOR, clrLightGray);
    }
    if(W1 == 0) {
        ObjectSetInteger(0, "BUTXTD0_W1", OBJPROP_STATE, false);
        ObjectSetInteger(0, "BUTXTD0_W1", OBJPROP_BGCOLOR, clrLightGray);
    }
    if(MN1 == 0) {
        ObjectSetInteger(0, "BUTXTD0_MN1", OBJPROP_STATE, false);
        ObjectSetInteger(0, "BUTXTD0_MN1", OBJPROP_BGCOLOR, clrLightGray);
    }
    if(M1 == 1 && M1NEWBAR == 0) M1NEWBAR = iTime(SIMBA, 1, 0);
    if(M5 == 1 && M5NEWBAR == 0) M5NEWBAR = iTime(SIMBA, 5, 0);
    if(M15 == 1 && M15NEWBAR == 0) M15NEWBAR = iTime(SIMBA, 15, 0);
    if(M30 == 1 && M30NEWBAR == 0) M30NEWBAR = iTime(SIMBA, 30, 0);
    if(H1 == 1 && H1NEWBAR == 0) H1NEWBAR = iTime(SIMBA, 60, 0);
    if(H4 == 1 && H4NEWBAR == 0) H4NEWBAR = iTime(SIMBA, 240, 0);
    if(D1 == 1 && D1NEWBAR == 0) D1NEWBAR = iTime(SIMBA, 1440, 0);
    if(W1 == 1 && W1NEWBAR == 0) W1NEWBAR = iTime(SIMBA, PERIOD_W1, 0);
    if(MN1 == 1 && MN1NEWBAR == 0) MN1NEWBAR = iTime(SIMBA, PERIOD_MN1, 0);
    int ver = 0;
    switch(Period()) {
    case 1:
        ver = M1SD;
        break;
    case 5 :
        ver = M5SD;
        break;
    case 15 :
        ver = M15SD;
        break;
    case 30 :
        ver = M30SD;
        break;
    case 60 :
        ver = H1SD;
        break;
    case 240 :
        ver = H4SD;
        break;
    case 1440 :
        ver = D1SD;
        break;
    case PERIOD_W1 :
        ver = W1SD;
        break;
    case PERIOD_MN1 :
        ver = MN1SD;
        break;
    }
    if(ver == 0) {
        ObjectSetInteger(0, "BUTXTD0_ALERT", OBJPROP_STATE, false);
        ObjectSetInteger(0, "BUTXTD0_ALERT", OBJPROP_BGCOLOR, clrLightGray);
        ALSYS = 0;
        GlobalVariableSet(Symbol() + "ALSYS", ALSYS);
    }
    return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string FORZAVAL(string SIMBA)
{
    string SYMBOL_SUFFIX = "";
    int VEDISTRENGTH = 1;
    int SCANNER = DASHBOARD;
    string VALU[];
    if(SIMBA == "EUR") {
        ArrayResize(VALU, 7);
        VALU[0] = "EURJPY" + SYMBOL_SUFFIX;
        VALU[1] = "EURCAD" + SYMBOL_SUFFIX;
        VALU[2] = "EURGBP" + SYMBOL_SUFFIX;
        VALU[3] = "EURCHF" + SYMBOL_SUFFIX;
        VALU[4] = "EURAUD" + SYMBOL_SUFFIX;
        VALU[5] = "EURUSD" + SYMBOL_SUFFIX;
        VALU[6] = "EURNZD" + SYMBOL_SUFFIX;
    }
    if(SIMBA == "USD") {
        ArrayResize(VALU, 7);
        VALU[0] = "USDJPY" + SYMBOL_SUFFIX;
        VALU[1] = "USDCAD" + SYMBOL_SUFFIX;
        VALU[2] = "AUDUSD" + SYMBOL_SUFFIX;
        VALU[3] = "USDCHF" + SYMBOL_SUFFIX;
        VALU[4] = "GBPUSD" + SYMBOL_SUFFIX;
        VALU[5] = "EURUSD" + SYMBOL_SUFFIX;
        VALU[6] = "NZDUSD" + SYMBOL_SUFFIX;
    }
    if(SIMBA == "JPY") {
        ArrayResize(VALU, 7);
        VALU[0] = "USDJPY" + SYMBOL_SUFFIX;
        VALU[1] = "EURJPY" + SYMBOL_SUFFIX;
        VALU[2] = "AUDJPY" + SYMBOL_SUFFIX;
        VALU[3] = "CHFJPY" + SYMBOL_SUFFIX;
        VALU[4] = "GBPJPY" + SYMBOL_SUFFIX;
        VALU[5] = "CADJPY" + SYMBOL_SUFFIX;
        VALU[6] = "NZDJPY" + SYMBOL_SUFFIX;
    }
    if(SIMBA == "CAD") {
        ArrayResize(VALU, 6);
        VALU[0] = "CADCHF" + SYMBOL_SUFFIX;
        VALU[1] = "CADJPY" + SYMBOL_SUFFIX;
        VALU[2] = "GBPCAD" + SYMBOL_SUFFIX;
        VALU[3] = "AUDCAD" + SYMBOL_SUFFIX;
        VALU[4] = "EURCAD" + SYMBOL_SUFFIX;
        VALU[5] = "USDCAD" + SYMBOL_SUFFIX;
    }
    if(SIMBA == "AUD") {
        ArrayResize(VALU, 7);
        VALU[0] = "AUDUSD" + SYMBOL_SUFFIX;
        VALU[1] = "AUDNZD" + SYMBOL_SUFFIX;
        VALU[2] = "AUDCAD" + SYMBOL_SUFFIX;
        VALU[3] = "AUDCHF" + SYMBOL_SUFFIX;
        VALU[4] = "AUDJPY" + SYMBOL_SUFFIX;
        VALU[5] = "EURAUD" + SYMBOL_SUFFIX;
        VALU[6] = "GBPAUD" + SYMBOL_SUFFIX;
    }
    if(SIMBA == "NZD") {
        ArrayResize(VALU, 5);
        VALU[0] = "NZDUSD" + SYMBOL_SUFFIX;
        VALU[1] = "NZDJPY" + SYMBOL_SUFFIX;
        VALU[2] = "EURNZD" + SYMBOL_SUFFIX;
        VALU[3] = "AUDNZD" + SYMBOL_SUFFIX;
        VALU[4] = "GBPNZD" + SYMBOL_SUFFIX;
    }
    if(SIMBA == "GBP") {
        ArrayResize(VALU, 7);
        VALU[0] = "GBPUSD" + SYMBOL_SUFFIX;
        VALU[1] = "EURGBP" + SYMBOL_SUFFIX;
        VALU[2] = "GBPCHF" + SYMBOL_SUFFIX;
        VALU[3] = "GBPAUD" + SYMBOL_SUFFIX;
        VALU[4] = "GBPCAD" + SYMBOL_SUFFIX;
        VALU[5] = "GBPJPY" + SYMBOL_SUFFIX;
        VALU[6] = "GBPNZD" + SYMBOL_SUFFIX;
    }
    if(SIMBA == "CHF") {
        ArrayResize(VALU, 6);
        VALU[0] = "CHFJPY" + SYMBOL_SUFFIX;
        VALU[1] = "USDCHF" + SYMBOL_SUFFIX;
        VALU[2] = "EURCHF" + SYMBOL_SUFFIX;
        VALU[3] = "AUDCHF" + SYMBOL_SUFFIX;
        VALU[4] = "GBPCHF" + SYMBOL_SUFFIX;
        VALU[5] = "CADCHF" + SYMBOL_SUFFIX;
    }
    double USDJPY = perch("USDJPY" + SYMBOL_SUFFIX);
    double USDCAD = perch("USDCAD" + SYMBOL_SUFFIX);
    double AUDUSD = perch("AUDUSD" + SYMBOL_SUFFIX);
    double USDCHF = perch("USDCHF" + SYMBOL_SUFFIX);
    double GBPUSD = perch("GBPUSD" + SYMBOL_SUFFIX);
    double EURUSD = perch("EURUSD" + SYMBOL_SUFFIX);
    double NZDUSD = perch("NZDUSD" + SYMBOL_SUFFIX);
    double EURJPY = perch("EURJPY" + SYMBOL_SUFFIX);
    double EURCAD = perch("EURCAD" + SYMBOL_SUFFIX);
    double EURGBP = perch("EURGBP" + SYMBOL_SUFFIX);
    double EURCHF = perch("EURCHF" + SYMBOL_SUFFIX);
    double EURAUD = perch("EURAUD" + SYMBOL_SUFFIX);
    double EURNZD = perch("EURNZD" + SYMBOL_SUFFIX);
    double AUDNZD = perch("AUDNZD" + SYMBOL_SUFFIX);
    double AUDCAD = perch("AUDCAD" + SYMBOL_SUFFIX);
    double AUDCHF = perch("AUDCHF" + SYMBOL_SUFFIX);
    double AUDJPY = perch("AUDJPY" + SYMBOL_SUFFIX);
    double CHFJPY = perch("CHFJPY" + SYMBOL_SUFFIX);
    double GBPCHF = perch("GBPCHF" + SYMBOL_SUFFIX);
    double GBPAUD = perch("GBPAUD" + SYMBOL_SUFFIX);
    double GBPCAD = perch("GBPCAD" + SYMBOL_SUFFIX);
    double GBPJPY = perch("GBPJPY" + SYMBOL_SUFFIX);
    double CADJPY = perch("CADJPY" + SYMBOL_SUFFIX);
    double NZDJPY = perch("NZDJPY" + SYMBOL_SUFFIX);
    double GBPNZD = perch("GBPNZD" + SYMBOL_SUFFIX);
    double CADCHF = perch("CADCHF" + SYMBOL_SUFFIX);
    double eur = (EURJPY + EURCAD + EURGBP + EURCHF + EURAUD + EURUSD + EURNZD) / 7;
    double usd = (USDJPY + USDCAD - AUDUSD + USDCHF - GBPUSD - EURUSD - NZDUSD) / 7;
    double jpy = (-1 * (USDJPY + EURJPY + AUDJPY + CHFJPY + GBPJPY + CADJPY + NZDJPY)) / 7;
    double cad = (CADCHF + CADJPY - (GBPCAD + AUDCAD + EURCAD + USDCAD)) / 6;
    double aud = (AUDUSD + AUDNZD + AUDCAD + AUDCHF + AUDJPY - (EURAUD + GBPAUD)) / 7;
    double nzd = (NZDUSD + NZDJPY - (EURNZD + AUDNZD + GBPNZD)) / 5;
    double gbp = (GBPUSD - EURGBP + GBPCHF + GBPAUD + GBPCAD + GBPJPY + GBPNZD) / 7;
    double chf = (CHFJPY - (USDCHF + EURCHF + AUDCHF + GBPCHF + CADCHF)) / 6;
    eur = NormalizeDouble(eur, 2);
    usd = NormalizeDouble(usd, 2);
    jpy = NormalizeDouble(jpy, 2);
    cad = NormalizeDouble(cad, 2);
    aud = NormalizeDouble(aud, 2);
    nzd = NormalizeDouble(nzd, 2);
    gbp = NormalizeDouble(gbp, 2);
    chf = NormalizeDouble(chf, 2);
    double VALORI[8][2];
    VALORI[0][0] = eur;
    VALORI[1][0] = usd;
    VALORI[2][0] = jpy;
    VALORI[3][0] = cad;
    VALORI[4][0] = aud;
    VALORI[5][0] = nzd;
    VALORI[6][0] = gbp;
    VALORI[7][0] = chf;
    VALORI[0][1] = 1;
    VALORI[1][1] = 2;
    VALORI[2][1] = 3;
    VALORI[3][1] = 4;
    VALORI[4][1] = 5;
    VALORI[5][1] = 6;
    VALORI[6][1] = 7;
    VALORI[7][1] = 8;
    ArraySort(VALORI, WHOLE_ARRAY, 0, MODE_DESCEND);
    string CAZZO = "";
    int posizione = 0;
    if(VEDISTRENGTH == 1 || SCANNER == false) {
        string PRIMAVAL = "";
        string SECONDAVAL = "";
        for(int i = 0; i < 8; i++) {
            int PIPPO = VALORI[i][1];
            string VALUT = "";
            switch(PIPPO) {
            case 1:
                VALUT = "EUR";
                break;
            case 2:
                VALUT = "USD";
                break;
            case 3:
                VALUT = "JPY";
                break;
            case 4:
                VALUT = "CAD";
                break;
            case 5:
                VALUT = "AUD";
                break;
            case 6:
                VALUT = "NZD";
                break;
            case 7:
                VALUT = "GBP";
                break;
            case 8:
                VALUT = "CHF";
                break;
            }
            if(ObjectFind("L" + i) != 0) {
                LabelCreate_topright(0, "L" + i, 0, 30 * ZOOM_PIXEL, (250 - 15 * (i + 1) + 20)*ZOOM_PIXEL, CORNER_RIGHT_LOWER);
                LabelCreate_topright(0, "Lx" + i, 0, 10 * ZOOM_PIXEL, (250 - 15 * (i + 1) + 20)*ZOOM_PIXEL, CORNER_RIGHT_LOWER);
            }
            int COLOREFORZA = COLOR_FOREGROUND;
            COLOREFORZA = COLOR_FOREGROUND;
            LabelTextChange(0, "L" + i, DoubleToStr(VALORI[i][0] * 100, 0) + " %" + "   |   ", clrWhite);
            LabelTextChange(0, "Lx" + i, VALUT, clrWhite);
            if(StringSubstr(Symbol(), 0, 3) == VALUT) PRIMAVAL = VALUT + " " + DoubleToStr(VALORI[i][0] * 100, 0) + " %";
            if(StringSubstr(Symbol(), 3, 3) == VALUT) SECONDAVAL = VALUT + " " + DoubleToStr(VALORI[i][0] * 100, 0) + " %";
            if(VALORI[i][0] > 0) ObjectSetInteger(0, "L" + i, OBJPROP_COLOR, Lime);
            if(VALORI[i][0] < 0) ObjectSetInteger(0, "L" + i, OBJPROP_COLOR, Red);
            if(VALORI[i][0] == 0) ObjectSetInteger(0, "L" + i, OBJPROP_COLOR, COLOREFORZA);
            ObjectSetInteger(0, "Lx" + i, OBJPROP_COLOR, COLOREFORZA);
            if(SCANNER == false) {
                if(StringSubstr(Symbol(), 0, 3) == VALUT) ObjectSetInteger(0, "Lx" + i, OBJPROP_COLOR, Aqua);
                if(StringSubstr(Symbol(), 3, 6) == VALUT) ObjectSetInteger(0, "Lx" + i, OBJPROP_COLOR, Aqua);
            }
            posizione = i;
        }
    }
    return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool FIBOON(string BUTTON, string WHERE, int SHOW)
{
    int totalObjects = ObjectsTotal(0, 0, -1);
    for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
        if(SHOW == 0)  if(ObjectName(i) == "BUTXTD1_FIBO_") {
                ObjectSetInteger(0, ObjectName(i), OBJPROP_STATE, false);
                ObjectSetInteger(0, ObjectName(i), OBJPROP_BGCOLOR, clrLightGray);
            }
        if(SHOW == 1)  if(ObjectName(i) == "BUTXTD1_FIBO_") {
                ObjectSetInteger(0, ObjectName(i), OBJPROP_STATE, true);
                ObjectSetInteger(0, ObjectName(i), OBJPROP_STATE, clrHotPink);
            }
    }
    if(SHOW == 1) {
    }
    return(false);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SYMBOL_CHANGER(int SHOW)
{
    if(SHOW == 1) {
        string VETTORE = PAIRS;
        string PAIR[];
        while(VETTORE != "") {
            ArrayResize(PAIR, ArraySize(PAIR) + 1);
            int POS = 0;
            POS = StringFind(VETTORE, ",", 0);
            if(StringFind(VETTORE, ",", 0) != -1) {
                POS = StringFind(VETTORE, ",", 0);
                PAIR[ArraySize(PAIR) - 1] = StringSubstr(VETTORE, 0, POS);
                VETTORE = StringSubstr(VETTORE, POS + 1, 0);
            }
            else if (VETTORE != "") {
                POS = StringLen(VETTORE);
                PAIR[ArraySize(PAIR) - 1] = StringSubstr(VETTORE, 0, 0);
                VETTORE = "";
            }
        }
        int QUANTI_PER_COLONNA = int(MathCeil(ArraySize(PAIR) / 8));
        int CONTARE = 0;
        int POSX = 0;
        int POSY = 0;
        for(int i = 0; i < ArraySize(PAIR); i++) {
            Create_Button(0, "BUTXTD2S_" + PAIR[i], 0, 20 + POSX, 440 - POSY, 100, 20, CORNER_LEFT_LOWER, PAIR[i], clrLightGray);
            if(CONTARE < QUANTI_PER_COLONNA) {
                POSX = POSX + 100;
                CONTARE = CONTARE + 1;
            }
            else {
                POSX = 0;
                POSY = POSY + 20;
                CONTARE = 0;
            }
        }
    }
    else {
        int totalObjects = ObjectsTotal(0, 0, -1);
        for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
            if(StringSubstr(ObjectName(i), 0, 9) == "BUTXTD2S_") {
                if(NOT(StringSubstr(ObjectName(i), 9, 0), OP_BUY) + NOT(StringSubstr(ObjectName(i), 9, 0), OP_SELL) == 0) ObjectSetInteger(0, "BUTXTD2S_" + StringSubstr(ObjectName(i), 9, 0), OBJPROP_BGCOLOR, clrLightGray);
                if(StringSubstr(ObjectName(i), 9, 0) == Symbol()) ObjectSetInteger(0, "BUTXTD2S_" + Symbol(), OBJPROP_BGCOLOR, clrLightSeaGreen);
                if(NOT(StringSubstr(ObjectName(i), 9, 0), OP_BUY) + NOT(StringSubstr(ObjectName(i), 9, 0), OP_SELL) != 0) {
                    if(PROFITTONE(PREFIX + StringSubstr(ObjectName(i), 9, 0) + SUFFIX, OP_BUY) + PROFITTONE(PREFIX + StringSubstr(ObjectName(i), 9, 0) + SUFFIX, OP_SELL) > 0) ObjectSetInteger(0, "BUTXTD2S_" + StringSubstr(ObjectName(i), 9, 0), OBJPROP_BGCOLOR, clrLimeGreen);
                    if(PROFITTONE(PREFIX + StringSubstr(ObjectName(i), 9, 0) + SUFFIX, OP_BUY) + PROFITTONE(PREFIX + StringSubstr(ObjectName(i), 9, 0) + SUFFIX, OP_SELL) < 0) ObjectSetInteger(0, "BUTXTD2S_" + StringSubstr(ObjectName(i), 9, 0), OBJPROP_BGCOLOR, clrRed);
                }
            }
        }
    }
    return(false);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GESTIONESD(string TYPE, int VAL, string MOTHER)
{
    if(VAL == 0) {
        ObjectDelete(0, MOTHER + TYPE);
        GlobalVariableSet(Symbol() + StringSubstr(MOTHER, 8, 0) + TYPE, 0);
    }
    else {
        Create_Button(0, MOTHER + TYPE, 0, (int)ObjectGetInteger(0, MOTHER, OBJPROP_XDISTANCE) / ZOOM_PIXEL, (int)ObjectGetInteger(0, MOTHER, OBJPROP_YDISTANCE) / ZOOM_PIXEL - 40, (int)ObjectGetInteger(0, MOTHER, OBJPROP_XSIZE) / ZOOM_PIXEL, (int)ObjectGetInteger(0, MOTHER, OBJPROP_YSIZE) / ZOOM_PIXEL, CORNER_LEFT_LOWER, TYPE, clrLightGray);
        ObjectSetInteger(0, MOTHER + TYPE, OBJPROP_BGCOLOR, clrLightGray);
        ObjectSetInteger(0, MOTHER + TYPE, OBJPROP_STATE, false);
        if(HIDE_TD0 == 0) ObjectSetInteger(0, MOTHER + TYPE, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        if(GlobalVariableGet(Symbol() + StringSubstr(MOTHER, 8, 0) + TYPE) == 1)  {
            ObjectSetInteger(0, MOTHER + TYPE, OBJPROP_BGCOLOR, clrLightSeaGreen);
            ObjectSetInteger(0, MOTHER + TYPE, OBJPROP_STATE, true);
        }
    }
    return(false);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GESTIONELQ(string TYPE, int VAL, string MOTHER)
{
    if(VAL == 0) {
        ObjectDelete(0, MOTHER + TYPE);
        GlobalVariableSet(Symbol() + StringSubstr(MOTHER, 8, 0) + TYPE, 0);
    }
    else {
        Create_Button(0, MOTHER + TYPE, 0, (int)ObjectGetInteger(0, MOTHER, OBJPROP_XDISTANCE) / ZOOM_PIXEL, (int)ObjectGetInteger(0, MOTHER, OBJPROP_YDISTANCE) / ZOOM_PIXEL - 60, (int)ObjectGetInteger(0, MOTHER, OBJPROP_XSIZE) / ZOOM_PIXEL, (int)ObjectGetInteger(0, MOTHER, OBJPROP_YSIZE) / ZOOM_PIXEL, CORNER_LEFT_LOWER, TYPE, clrLightGray);
        ObjectSetInteger(0, MOTHER + TYPE, OBJPROP_BGCOLOR, clrLightGray);
        ObjectSetInteger(0, MOTHER + TYPE, OBJPROP_STATE, false);
        if(HIDE_TD0 == 0) ObjectSetInteger(0, MOTHER + TYPE, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        if(GlobalVariableGet(Symbol() + StringSubstr(MOTHER, 8, 0) + TYPE) == 1)  {
            ObjectSetInteger(0, MOTHER + TYPE, OBJPROP_BGCOLOR, clrLightSeaGreen);
            ObjectSetInteger(0, MOTHER + TYPE, OBJPROP_STATE, true);
        }
    }
    return(false);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GESTIONEFV(string TYPE, int VAL, string MOTHER)
{
    if(VAL == 0) {
        ObjectDelete(0, MOTHER + TYPE);
        GlobalVariableSet(Symbol() + StringSubstr(MOTHER, 8, 0) + TYPE, 0);
    }
    else {
        Create_Button(0, MOTHER + TYPE, 0, (int)ObjectGetInteger(0, MOTHER, OBJPROP_XDISTANCE) / ZOOM_PIXEL, (int)ObjectGetInteger(0, MOTHER, OBJPROP_YDISTANCE) / ZOOM_PIXEL - 80, (int)ObjectGetInteger(0, MOTHER, OBJPROP_XSIZE) / ZOOM_PIXEL, (int)ObjectGetInteger(0, MOTHER, OBJPROP_YSIZE) / ZOOM_PIXEL, CORNER_LEFT_LOWER, TYPE, clrLightGray);
        ObjectSetInteger(0, MOTHER + TYPE, OBJPROP_BGCOLOR, clrLightGray);
        ObjectSetInteger(0, MOTHER + TYPE, OBJPROP_STATE, false);
        if(HIDE_TD0 == 0) ObjectSetInteger(0, MOTHER + TYPE, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        if(GlobalVariableGet(Symbol() + StringSubstr(MOTHER, 8, 0) + TYPE) == 1)  {
            ObjectSetInteger(0, MOTHER + TYPE, OBJPROP_BGCOLOR, clrLightSeaGreen);
            ObjectSetInteger(0, MOTHER + TYPE, OBJPROP_STATE, true);
        }
    }
    return(false);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TIMEFRAMESEL(string SIMBO, int PERIO)
{
    string TTT = tftransformation(PERIO);
    int totalObjects = ObjectsTotal(0, 0, -1);
    for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
        if(StringSubstr(ObjectName(i), 0, 9) == "BUTXTD0_Z") {
            if(StringSubstr(ObjectName(i), 9, 0) == TTT) ObjectSetInteger(0, ObjectName(i), OBJPROP_BGCOLOR, clrLightSeaGreen);
            else  ObjectSetInteger(0, ObjectName(i), OBJPROP_BGCOLOR, clrLightGray);
        }
    }
    return(false);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int FVGcalc(string SIMBA, int TF, int y, double &MyArray[], double &My2[], int RILEVAZIONE)
{
    if(ArraySize(MyArray) == 0) {
        ArrayResize(MyArray, 1);
        MyArray[ArraySize(MyArray) - 1] = iBars(SIMBA, TF) - (y + 1);
        ArrayResize(My2, 1);
        My2[ArraySize(My2) - 1] = 0;
    }
    int DOVE = 0;
    for(int x = iBars(SIMBA, TF) - MyArray[ArraySize(MyArray) - 1]; x > y; x--) {
        if(RILEVAZIONE == 1) {
            if(iHigh(SIMBA, TF, x + 2) < iLow(SIMBA, TF, x) && iClose(SIMBA, TF, x + 1) > iHigh(SIMBA, TF, x + 2) && MyArray[ArraySize(MyArray) - 1] < iBars(SIMBA, TF) - (x + 1)) {
                ArrayResize(MyArray, ArraySize(MyArray) + 1);
                DOVE = 1;
                MyArray[ArraySize(MyArray) - 1] = iBars(SIMBA, TF) - (x + 1);
                ArrayResize(My2, ArraySize(My2) + 1);
                My2[ArraySize(My2) - 1] = DOVE;
            }
        }
        if(RILEVAZIONE == 2) {
            if(iLow(SIMBA, TF, x + 2) > iHigh(SIMBA, TF, x) && iClose(SIMBA, TF, x + 1) < iLow(SIMBA, TF, x + 2) && MyArray[ArraySize(MyArray) - 1] < iBars(SIMBA, TF) - (x + 1)) {
                ArrayResize(MyArray, ArraySize(MyArray) + 1);
                DOVE = 2;
                MyArray[ArraySize(MyArray) - 1] = iBars(SIMBA, TF) - (x + 1);
                ArrayResize(My2, ArraySize(My2) + 1);
                My2[ArraySize(My2) - 1] = DOVE;
            }
        }
        if(RILEVAZIONE == 3) {
            int UP = 0;
            int DOWN = 0;
            if(iHigh(SIMBA, TF, x + 2) < iLow(SIMBA, TF, x) && iClose(SIMBA, TF, x + 1) > iHigh(SIMBA, TF, x + 2) && MyArray[ArraySize(MyArray) - 1] < iBars(SIMBA, TF) - (x + 1)) UP = 1;
            if(iLow(SIMBA, TF, x + 2) > iHigh(SIMBA, TF, x) && iClose(SIMBA, TF, x + 1) < iLow(SIMBA, TF, x + 2) && MyArray[ArraySize(MyArray) - 1] < iBars(SIMBA, TF) - (x + 1)) DOWN = 1;
            if(UP == 1) {
                ArrayResize(MyArray, ArraySize(MyArray) + 1);
                DOVE = 1;
                MyArray[ArraySize(MyArray) - 1] = iBars(SIMBA, TF) - (x + 1);
                ArrayResize(My2, ArraySize(My2) + 1);
                My2[ArraySize(My2) - 1] = 1;
                continue;
            }
            if(DOWN == 1) {
                ArrayResize(MyArray, ArraySize(MyArray) + 1);
                DOVE = 2;
                MyArray[ArraySize(MyArray) - 1] = iBars(SIMBA, TF) - (x + 1);
                ArrayResize(My2, ArraySize(My2) + 1);
                My2[ArraySize(My2) - 1] = 2;
                continue;
            }
        }
    }
    return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CHECKnewBar(string SIMBA, int TF)
{
    bool newBar = false;
    datetime ver;
    switch(TF) {
    case 1:
        ver = M1NEWBAR;
        break;
    case 5 :
        ver = M5NEWBAR;
        break;
    case 15 :
        ver = M15NEWBAR;
        break;
    case 30 :
        ver = M30NEWBAR;
        break;
    case 60 :
        ver = H1NEWBAR;
        break;
    case 240 :
        ver = H4NEWBAR;
        break;
    case 1440 :
        ver = D1NEWBAR;
        break;
    case PERIOD_W1 :
        ver = W1NEWBAR;
        break;
    case PERIOD_MN1 :
        ver = MN1NEWBAR;
        break;
    }
    if ( ver != iTime(SIMBA, TF, 0) ) {
        ver = iTime(SIMBA, TF, 0);
        newBar = true;
        switch(TF) {
        case 1:
            M1NEWBAR = ver;
            break;
        case 5 :
            M5NEWBAR = ver;
            break;
        case 15 :
            M15NEWBAR = ver;
            break;
        case 30 :
            M30NEWBAR = ver;
            break;
        case 60 :
            H1NEWBAR = ver;
            break;
        case 240 :
            H4NEWBAR = ver;
            break;
        case 1440 :
            D1NEWBAR = ver;
            break;
        case PERIOD_W1 :
            W1NEWBAR = ver;
            break;
        case PERIOD_MN1 :
            MN1NEWBAR = ver;
            break;
        }
    }
    return(newBar);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int LSBfuncBSS(string SIMBA, int TF, int HH, int LL, int BMS, int BMSbreak, int OF, int REVERSE, int CURR, int CHOCH)
{
    int OB = 0;
    int BREAK = 0;
    int LSBbroken = 0;
    int MITIGATED = 0;
    int MITIGATEDWHERE = 0;
    BSSLSBSOURCE = 0;
    BSSLSBSOURCEMITIGATED = 0;
    BSSLSBBROKENYES = 0;
    if(REVERSE == 1 && OF == 1) OF = 2;
    else if(REVERSE == 1 && OF == 2) OF = 1;
    if(OF == 1) {
        int subLL = 0;
        int subHH = 0;
        if(REVERSE == 0) {
            subLL = iBars(SIMBA, TF) - HH;
            for(int c = iBars(SIMBA, TF) - HH; c > CURR; c--) {
                if(iClose(SIMBA, TF, c) < iLow(SIMBA, TF, subLL)) subLL = c;
            }
            if(subLL != iBars(SIMBA, TF) - HH) {
                for(int m = subLL; m <= iBars(SIMBA, TF) - HH; m++) {
                    if(iClose(SIMBA, TF, m) > iOpen(SIMBA, TF, m) && iClose(SIMBA, TF, subLL) < iLow(SIMBA, TF, m)) {
                        OB = m;
                        for(int n = m; n >= subLL; n--) {
                            if(iClose(SIMBA, TF, n) < iLow(SIMBA, TF, m)) {
                                BREAK = n;
                                subHH = iHighest(SIMBA, TF, MODE_HIGH, 1 + (BREAK - OB), BREAK);
                                break;
                            }
                        }
                        if(subHH != 0) break;
                    }
                }
            }
        }
        else {
            subHH = iHighest(SIMBA, TF, MODE_HIGH, 1 + (LL - BMS), iBars(SIMBA, TF) - LL);
            OB = iBars(SIMBA, TF) - BMS;
            BREAK = iBars(SIMBA, TF) - BMSbreak;
        }
        for(int i = BREAK; i > CURR; i--) {
            if(iClose(SIMBA, TF, i) > iHigh(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, (OB - BREAK) + 1, BREAK))) {
                BSSLSBSOURCE = iBars(SIMBA, TF) - iLowest(SIMBA, TF, MODE_CLOSE, (OB - i) + 1, i);
                LSBbroken = i;
                break;
            }
        }
        if(OB != 0 && BREAK != 0) {
            if(LSBbroken == 0) {
                MITIGATED = BREAK;
                if(MITIGATED != 0) {
                    for(int x = MITIGATED - 1; x >= CURR; x--) {
                        if(iHigh(SIMBA, TF, x) > iLow(SIMBA, TF, OB)) {
                            MITIGATEDWHERE = x;
                            break;
                        }
                    }
                }
            }
            else {
                MITIGATED = LSBbroken;
                if(MITIGATED != 0) {
                    for(int x = MITIGATED - 1; x >= CURR; x--) {
                        if(iLow(SIMBA, TF, x) < iHigh(SIMBA, TF, iBars(SIMBA, TF) - BSSLSBSOURCE)) {
                            MITIGATEDWHERE = x;
                            break;
                        }
                    }
                }
            }
        }
    }
    if(OF == 2) {
        int subLL = 0;
        int subHH = 0;
        if(REVERSE == 0) {
            subHH = iBars(SIMBA, TF) - LL;
            for(int c = iBars(SIMBA, TF) - LL; c > CURR; c--) {
                if(iClose(SIMBA, TF, c) > iHigh(SIMBA, TF, subHH)) subHH = c;
            }
            if(subHH != iBars(SIMBA, TF) - LL) {
                for(int m = subHH; m <= iBars(SIMBA, TF) - LL; m++) {
                    if(iClose(SIMBA, TF, m) < iOpen(SIMBA, TF, m) && iClose(SIMBA, TF, subHH) > iHigh(SIMBA, TF, m)) {
                        OB = m;
                        for(int n = m; n >= subHH; n--) {
                            if(iClose(SIMBA, TF, n) > iHigh(SIMBA, TF, m)) {
                                BREAK = n;
                                subLL = iLowest(SIMBA, TF, MODE_LOW, 1 + (BREAK - OB), BREAK);
                                break;
                            }
                        }
                        if(subLL != 0) break;
                    }
                }
            }
        }
        else {
            subLL = iLowest(SIMBA, TF, MODE_LOW, 1 + (HH - BMS), iBars(SIMBA, TF) - HH);
            OB = iBars(SIMBA, TF) - BMS;
            BREAK = iBars(SIMBA, TF) - BMSbreak;
        }
        for(int i = BREAK; i > CURR; i--) {
            if(iClose(SIMBA, TF, i) < iLow(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, (OB - BREAK) + 1, BREAK))) {
                BSSLSBSOURCE = iBars(SIMBA, TF) - iHighest(SIMBA, TF, MODE_CLOSE, (OB - i) + 1, i);
                LSBbroken = i;
                break;
            }
        }
        if(OB != 0 && BREAK != 0) {
            if(LSBbroken == 0) {
                MITIGATED = BREAK;
                if(MITIGATED != 0) {
                    for(int x = MITIGATED - 1; x >= CURR; x--) {
                        if(iLow(SIMBA, TF, x) < iHigh(SIMBA, TF, OB)) {
                            MITIGATEDWHERE = x;
                            break;
                        }
                    }
                }
            }
            else {
                MITIGATED = LSBbroken;
                if(MITIGATED != 0) {
                    for(int x = MITIGATED - 1; x >= CURR; x--) {
                        if(iHigh(SIMBA, TF, x) > iLow(SIMBA, TF, iBars(SIMBA, TF) - BSSLSBSOURCE)) {
                            MITIGATEDWHERE = x;
                            break;
                        }
                    }
                }
            }
        }
    }
    BSSLSBBROKENYES = LSBbroken;
    BSSLSBSOURCEMITIGATED = MITIGATEDWHERE;
    return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int LSBfunc(string SIMBA, int TF, int HH, int LL, int OF, int BMS, int BMSbreak, int REVERSE, int CURR, string PREF)
{
    int OB = 0;
    int BREAK = 0;
    int LSBbroken = 0;
    int MITIGATED = 0;
    int MITIGATEDWHERE = 0;
    int DIRETTO = 0;
    LSBSOURCE = 0;
    LSBSOURCEMITIGATED = 0;
    LSBBROKENYES = 0;
    if(REVERSE == 1 && OF == 1) OF = 2;
    else if(REVERSE == 1 && OF == 2) OF = 1;
    if(OF == 1) {
        int subLL = 0;
        int subHH = 0;
        if(REVERSE == 0) {
            subLL = iBars(SIMBA, TF) - HH;
            for(int c = iBars(SIMBA, TF) - HH; c > CURR; c--) {
                if(iClose(SIMBA, TF, c) < iLow(SIMBA, TF, subLL)) subLL = c;
            }
            if(subLL != iBars(SIMBA, TF) - HH) {
                for(int m = subLL; m <= iBars(SIMBA, TF) - HH; m++) {
                    if(iClose(SIMBA, TF, m) > iOpen(SIMBA, TF, m) && iClose(SIMBA, TF, subLL) < iLow(SIMBA, TF, m)) {
                        OB = m;
                        for(int n = m; n >= subLL; n--) {
                            if(iClose(SIMBA, TF, n) < iLow(SIMBA, TF, m)) {
                                BREAK = n;
                                subHH = iHighest(SIMBA, TF, MODE_HIGH, 1 + (BREAK - OB), BREAK);
                                break;
                            }
                        }
                        if(subHH != 0) break;
                    }
                }
            }
        }
        else {
            subHH = iHighest(SIMBA, TF, MODE_HIGH, 1 + (LL - BMS), iBars(SIMBA, TF) - LL);
            OB = iBars(SIMBA, TF) - BMS;
            BREAK = iBars(SIMBA, TF) - BMSbreak;
        }
        for(int i = BREAK; i > CURR; i--) {
            if(iClose(SIMBA, TF, i) > iHigh(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, (OB - BREAK) + 1, BREAK))) {
                LSBSOURCE = iBars(SIMBA, TF) - iLowest(SIMBA, TF, MODE_CLOSE, (OB - i) + 1, i);
                LSBbroken = i;
                break;
            }
        }
        if(OB != 0 && BREAK != 0) {
            if(LSBbroken == 0) {
                if(DASHBOARD == false) ObjectCreate(0, TF + PREF + "LSB", OBJ_RECTANGLE, 0, iTime(SIMBA, TF, OB), iLow(SIMBA, TF, OB), iTime(SIMBA, TF, CURR) + 60 * TF, iHigh(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, (OB - BREAK) + 1, BREAK)));
                ObjectSetInteger(0, TF + PREF + "LSB", OBJPROP_BACK, false);
                ObjectSetInteger(0, TF + PREF + "LSB", OBJPROP_STYLE, STYLE_DOT);
                ObjectSetInteger(0, TF + PREF + "LSB", OBJPROP_WIDTH, 3);
                ObjectSetInteger(0, TF + PREF + "LSB", OBJPROP_HIDDEN, true);
                ObjectSetInteger(0, TF + PREF + "LSB", OBJPROP_COLOR, clrLightSalmon);
                if(DASHBOARD == false) CREATETEXTPRICEprice(TF + PREF + "LSBOBresptextint", tftransformation(TF) + " OB-", iTime(SIMBA, TF, CURR) + 60 * TF, iLow(SIMBA, TF, OB), clrWhite, ANCHOR_LEFT_LOWER);
                MITIGATED = BREAK;
                if(MITIGATED != 0) {
                    for(int x = MITIGATED - 1; x >= CURR; x--) {
                        if(iHigh(SIMBA, TF, x) > iLow(SIMBA, TF, OB)) {
                            MITIGATEDWHERE = x;
                            break;
                        }
                    }
                }
                if(MITIGATEDWHERE != 0) {
                    if(DASHBOARD == false) ObjectCreate(0, TF + PREF + "SOBmitLSB", OBJ_ARROW, 0, 0, 0, 0, 0);
                    ObjectSetInteger(0, TF + PREF + "SOBmitLSB", OBJPROP_HIDDEN, true);
                    ObjectSetInteger(0, TF + PREF + "SOBmitLSB", OBJPROP_ARROWCODE, 254); // Set the arrow code
                    ObjectSetInteger(0, TF + PREF + "SOBmitLSB", OBJPROP_COLOR, clrLightSalmon); // Set the arrow code
                    ObjectSetInteger(0, TF + PREF + "SOBmitLSB", OBJPROP_TIME, iTime(SIMBA, TF, MITIGATEDWHERE)); // Set time
                    ObjectSetDouble(0, TF + PREF + "SOBmitLSB", OBJPROP_PRICE, iLow(SIMBA, TF, OB));
                    ObjectSetInteger(0, TF + PREF + "SOBmitLSB", OBJPROP_ANCHOR, ANCHOR_TOP);
                    ObjectSetInteger(0, TF + PREF + "LSB", OBJPROP_BACK, false);
                    ObjectSetInteger(0, TF + PREF + "LSB", OBJPROP_WIDTH, 1);
                }
            }
            else {
                if(DASHBOARD == false) ObjectCreate(0, TF + PREF + "LSBOBresp", OBJ_TREND, 0, 0, 0, 0, 0);
                ObjectSetInteger(0, TF + PREF + "LSBOBresp", OBJPROP_RAY, false);
                ObjectSetInteger(0, TF + PREF + "LSBOBresp", OBJPROP_HIDDEN, true);
                ObjectMove(0, TF + PREF + "LSBOBresp", 0, iTime(SIMBA, TF, OB), iHigh(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, (OB - BREAK) + 1, BREAK)));
                ObjectMove(0, TF + PREF + "LSBOBresp", 1, iTime(SIMBA, TF, LSBbroken), iHigh(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, (OB - BREAK) + 1, BREAK)));
                if(DASHBOARD == false) CREATETEXTPRICEprice(TF + PREF + "LSBOBresptext", "BSS+ " + tftransformation(TF), iTime(SIMBA, TF, OB), iHigh(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, (OB - BREAK) + 1, BREAK)), clrYellow, ANCHOR_LEFT_LOWER);
                ObjectSetInteger(0, TF + PREF + "LSBOBresp", OBJPROP_COLOR, clrYellow);
                if(DASHBOARD == false) ObjectCreate(0, TF + PREF + "SOURCELSB", OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                ObjectSetInteger(0, TF + PREF + "SOURCELSB", OBJPROP_BACK, false);
                ObjectSetInteger(0, TF + PREF + "SOURCELSB", OBJPROP_STYLE, STYLE_DOT);
                ObjectSetInteger(0, TF + PREF + "SOURCELSB", OBJPROP_WIDTH, 3);
                ObjectSetInteger(0, TF + PREF + "SOURCELSB", OBJPROP_HIDDEN, true);
                ObjectMove(0, TF + PREF + "SOURCELSB", 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - LSBSOURCE), iHigh(SIMBA, TF, iBars(SIMBA, TF) - LSBSOURCE));
                datetime ST = iTime(SIMBA, TF, CURR) + 60 * TF;
                for(int m = LSBbroken; m > CURR; m--) {
                    if(iClose(SIMBA, TF, m) < iLow(SIMBA, TF, iBars(SIMBA, TF) - LSBSOURCE)) {
                        ST = iTime(SIMBA, TF, m);
                        break;
                    }
                }
                ObjectMove(0, TF + PREF + "SOURCELSB", 1, ST, iLow(SIMBA, TF, iBars(SIMBA, TF) - LSBSOURCE));
                ObjectSetInteger(0, TF + PREF + "SOURCELSB", OBJPROP_COLOR, clrLightGreen);
                CREATETEXTPRICEprice(TF + PREF + "SOURCELSBtext", tftransformation(TF) + " OB+", ST, iHigh(SIMBA, TF, iBars(SIMBA, TF) - LSBSOURCE), clrWhite, ANCHOR_LEFT_UPPER);
                MITIGATED = LSBbroken;
                if(MITIGATED != 0) {
                    for(int x = MITIGATED - 1; x >= CURR; x--) {
                        if(iLow(SIMBA, TF, x) < iHigh(SIMBA, TF, iBars(SIMBA, TF) - LSBSOURCE)) {
                            MITIGATEDWHERE = x;
                            break;
                        }
                    }
                }
                if(MITIGATEDWHERE != 0) {
                    if(DASHBOARD == false) ObjectCreate(0, TF + PREF + "SOSmitLSB", OBJ_ARROW, 0, 0, 0, 0, 0);
                    ObjectSetInteger(0, TF + PREF + "SOSmitLSB", OBJPROP_HIDDEN, true);
                    ObjectSetInteger(0, TF + PREF + "SOSmitLSB", OBJPROP_ARROWCODE, 254); // Set the arrow code
                    ObjectSetInteger(0, TF + PREF + "SOSmitLSB", OBJPROP_COLOR, clrLightGreen); // Set the arrow code
                    ObjectSetInteger(0, TF + PREF + "SOSmitLSB", OBJPROP_TIME, iTime(SIMBA, TF, MITIGATEDWHERE)); // Set time
                    ObjectSetDouble(0, TF + PREF + "SOSmitLSB", OBJPROP_PRICE, iHigh(SIMBA, TF, iBars(SIMBA, TF) - LSBSOURCE));
                    ObjectSetInteger(0, TF + PREF + "SOSmitLSB", OBJPROP_ANCHOR, ANCHOR_TOP);
                    ObjectSetInteger(0, TF + PREF + "SOURCELSB", OBJPROP_WIDTH, 1);
                }
            }
        }
    }
    if(OF == 2) {
        int subLL = 0;
        int subHH = 0;
        if(REVERSE == 0) {
            subHH = iBars(SIMBA, TF) - LL;
            for(int c = iBars(SIMBA, TF) - LL; c > CURR; c--) {
                if(iClose(SIMBA, TF, c) > iHigh(SIMBA, TF, subHH)) subHH = c;
            }
            if(subHH != iBars(SIMBA, TF) - LL) {
                for(int m = subHH; m <= iBars(SIMBA, TF) - LL; m++) {
                    if(iClose(SIMBA, TF, m) < iOpen(SIMBA, TF, m) && iClose(SIMBA, TF, subHH) > iHigh(SIMBA, TF, m)) {
                        OB = m;
                        for(int n = m; n >= subHH; n--) {
                            if(iClose(SIMBA, TF, n) > iHigh(SIMBA, TF, m)) {
                                BREAK = n;
                                subLL = iLowest(SIMBA, TF, MODE_LOW, 1 + (BREAK - OB), BREAK);
                                break;
                            }
                        }
                        if(subLL != 0) break;
                    }
                }
            }
        }
        else {
            subLL = iLowest(SIMBA, TF, MODE_LOW, 1 + (HH - BMS), iBars(SIMBA, TF) - HH);
            OB = iBars(SIMBA, TF) - BMS;
            BREAK = iBars(SIMBA, TF) - BMSbreak;
        }
        for(int i = BREAK; i > CURR; i--) {
            if(iClose(SIMBA, TF, i) < iLow(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, (OB - BREAK) + 1, BREAK))) {
                LSBSOURCE = iBars(SIMBA, TF) - iHighest(SIMBA, TF, MODE_CLOSE, (OB - i) + 1, i);
                LSBbroken = i;
                break;
            }
        }
        if(OB != 0 && BREAK != 0) {
            if(LSBbroken == 0) {
                if(DASHBOARD == false) ObjectCreate(0, TF + PREF + "LSB", OBJ_RECTANGLE, 0, iTime(SIMBA, TF, OB), iHigh(SIMBA, TF, OB), iTime(SIMBA, TF, CURR) + 60 * TF, iLow(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, (OB - BREAK) + 1, BREAK)));
                ObjectSetInteger(0, TF + PREF + "LSB", OBJPROP_BACK, false);
                ObjectSetInteger(0, TF + PREF + "LSB", OBJPROP_STYLE, STYLE_DOT);
                ObjectSetInteger(0, TF + PREF + "LSB", OBJPROP_WIDTH, 3);
                ObjectSetInteger(0, TF + PREF + "LSB", OBJPROP_HIDDEN, true);
                ObjectSetInteger(0, TF + PREF + "LSB", OBJPROP_COLOR, clrLightGreen);
                if(DASHBOARD == false) CREATETEXTPRICEprice(TF + PREF + "LSBOBresptextint", tftransformation(TF) + " OB+", iTime(SIMBA, TF, CURR) + 60 * TF, iHigh(SIMBA, TF, OB), clrWhite, ANCHOR_LEFT_UPPER);
                MITIGATED = BREAK;
                if(MITIGATED != 0) {
                    for(int x = MITIGATED - 1; x >= CURR; x--) {
                        if(iLow(SIMBA, TF, x) < iHigh(SIMBA, TF, OB)) {
                            MITIGATEDWHERE = x;
                            break;
                        }
                    }
                }
                if(MITIGATEDWHERE != 0) {
                    if(DASHBOARD == false) ObjectCreate(0, TF + PREF + "SOBmitLSB", OBJ_ARROW, 0, 0, 0, 0, 0);
                    ObjectSetInteger(0, TF + PREF + "SOBmitLSB", OBJPROP_HIDDEN, true);
                    ObjectSetInteger(0, TF + PREF + "SOBmitLSB", OBJPROP_ARROWCODE, 254); // Set the arrow code
                    ObjectSetInteger(0, TF + PREF + "SOBmitLSB", OBJPROP_COLOR, clrLightGreen); // Set the arrow code
                    ObjectSetInteger(0, TF + PREF + "SOBmitLSB", OBJPROP_TIME, iTime(SIMBA, TF, MITIGATEDWHERE)); // Set time
                    ObjectSetDouble(0, TF + PREF + "SOBmitLSB", OBJPROP_PRICE, iHigh(SIMBA, TF, OB));
                    ObjectSetInteger(0, TF + PREF + "SOBmitLSB", OBJPROP_ANCHOR, ANCHOR_BOTTOM);
                    ObjectSetInteger(0, TF + PREF + "LSB", OBJPROP_BACK, false);
                    ObjectSetInteger(0, TF + PREF + "LSB", OBJPROP_WIDTH, 1);
                }
            }
            else {
                if(DASHBOARD == false) ObjectCreate(0, TF + PREF + "LSBOBresp", OBJ_TREND, 0, 0, 0, 0, 0);
                ObjectSetInteger(0, TF + PREF + "LSBOBresp", OBJPROP_RAY, false);
                ObjectSetInteger(0, TF + PREF + "LSBOBresp", OBJPROP_HIDDEN, true);
                ObjectMove(0, TF + PREF + "LSBOBresp", 0, iTime(SIMBA, TF, OB), iLow(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, (OB - BREAK) + 1, BREAK)));
                ObjectMove(0, TF + PREF + "LSBOBresp", 1, iTime(SIMBA, TF, LSBbroken), iLow(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, (OB - BREAK) + 1, BREAK)));
                if(DASHBOARD == false) CREATETEXTPRICEprice(TF + PREF + "LSBOBresptext", "BSS- " + tftransformation(TF), iTime(SIMBA, TF, OB), iLow(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, (OB - BREAK) + 1, BREAK)), clrYellow, ANCHOR_LEFT_UPPER);
                ObjectSetInteger(0, TF + PREF + "LSBOBresp", OBJPROP_COLOR, clrYellow);
                if(DASHBOARD == false) ObjectCreate(0, TF + PREF + "SOURCELSB", OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                ObjectSetInteger(0, TF + PREF + "SOURCELSB", OBJPROP_BACK, false);
                ObjectSetInteger(0, TF + PREF + "SOURCELSB", OBJPROP_STYLE, STYLE_DOT);
                ObjectSetInteger(0, TF + PREF + "SOURCELSB", OBJPROP_WIDTH, 3);
                ObjectSetInteger(0, TF + PREF + "SOURCELSB", OBJPROP_HIDDEN, true);
                ObjectMove(0, TF + PREF + "SOURCELSB", 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - LSBSOURCE), iHigh(SIMBA, TF, iBars(SIMBA, TF) - LSBSOURCE));
                datetime ST = iTime(SIMBA, TF, CURR) + 60 * TF;
                for(int m = LSBbroken; m > CURR; m--) {
                    if(iClose(SIMBA, TF, m) > iHigh(SIMBA, TF, iBars(SIMBA, TF) - LSBSOURCE)) {
                        ST = iTime(SIMBA, TF, m);
                        break;
                    }
                }
                ObjectMove(0, TF + PREF + "SOURCELSB", 1, ST, iLow(SIMBA, TF, iBars(SIMBA, TF) - LSBSOURCE));
                ObjectSetInteger(0, TF + PREF + "SOURCELSB", OBJPROP_COLOR, clrLightSalmon);
                CREATETEXTPRICEprice(TF + PREF + "SOURCELSBtext", tftransformation(TF) + " OB-", ST, iLow(SIMBA, TF, iBars(SIMBA, TF) - LSBSOURCE), clrWhite, ANCHOR_LEFT_LOWER);
                MITIGATED = LSBbroken;
                if(MITIGATED != 0) {
                    for(int x = MITIGATED - 1; x >= CURR; x--) {
                        if(iHigh(SIMBA, TF, x) > iLow(SIMBA, TF, iBars(SIMBA, TF) - LSBSOURCE)) {
                            MITIGATEDWHERE = x;
                            break;
                        }
                    }
                }
                if(MITIGATEDWHERE != 0) {
                    if(DASHBOARD == false) ObjectCreate(0, TF + PREF + "SOSmitLSB", OBJ_ARROW, 0, 0, 0, 0, 0);
                    ObjectSetInteger(0, TF + PREF + "SOSmitLSB", OBJPROP_HIDDEN, true);
                    ObjectSetInteger(0, TF + PREF + "SOSmitLSB", OBJPROP_ARROWCODE, 254); // Set the arrow code
                    ObjectSetInteger(0, TF + PREF + "SOSmitLSB", OBJPROP_COLOR, clrLightSalmon); // Set the arrow code
                    ObjectSetInteger(0, TF + PREF + "SOSmitLSB", OBJPROP_TIME, iTime(SIMBA, TF, MITIGATEDWHERE)); // Set time
                    ObjectSetDouble(0, TF + PREF + "SOSmitLSB", OBJPROP_PRICE, iLow(SIMBA, TF, iBars(SIMBA, TF) - LSBSOURCE));
                    ObjectSetInteger(0, TF + PREF + "SOSmitLSB", OBJPROP_ANCHOR, ANCHOR_BOTTOM);
                    ObjectSetInteger(0, TF + PREF + "SOURCELSB", OBJPROP_BACK, false);
                    ObjectSetInteger(0, TF + PREF + "SOURCELSB", OBJPROP_WIDTH, 1);
                }
            }
        }
    }
    LSBBROKENYES = LSBbroken;
    LSBSOURCEMITIGATED = MITIGATEDWHERE;
    DIRETTO = REVERSE;
    return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MITIGATIONfunc(string SIMBA, int TF, int CURRCANDX, double &FLOW[], double &RTS[], double &HH[], double &LL[], double &RTO[], double &BREAKER[], double &BMS[], double &BMSbreak[], int &SOURCEinv[])
{
    for(int U = 0; U < ArraySize(FLOW); U++) {
        if(FLOW[U] == 1) {
            if(RTS[U] == -1) {
                int MITIGATED = 0;
                int WALLY = 0;
                if(CHECK_MITIGATION_AFTER == 2) {
                    for(int x = (iBars(SIMBA, TF) - LL[U]); x > 0; x++) {
                        if(iClose(SIMBA, TF, x) > iOpen(SIMBA, TF, x) && iHigh(SIMBA, TF, x + 1) < iClose(SIMBA, TF, x)) {
                            WALLY = iHighest(SIMBA, TF, MODE_HIGH, (x - (iBars(SIMBA, TF) - LL[U])) + 1, iBars(SIMBA, TF) - LL[U]);
                            break;
                        }
                    }
                    for(int x = (iBars(SIMBA, TF) - LL[U]); x > CURRCANDX; x--) {
                        if(iClose(SIMBA, TF, x) > iHigh(SIMBA, TF, WALLY)) {
                            MITIGATED = x;
                            break;
                        }
                    }
                }
                if(MITIGATED == 0) MITIGATED = (iBars(SIMBA, TF) - BREAKER[U]) - 1;
                if(MITIGATED != 0) {
                    for(int x = MITIGATED - 1; x >= CURRCANDX; x--) {
                        if(iLow(SIMBA, TF, x) < iHigh(SIMBA, TF, iBars(SIMBA, TF) - LL[U])) {
                            RTS[U] = iBars(SIMBA, TF) - x;
                            break;
                        }
                    }
                }
            }
        }
        if(FLOW[U] == 2) {
            if(RTS[U] == -1) {
                int MITIGATED = 0;
                int WALLY = 0;
                if(CHECK_MITIGATION_AFTER == 2) {
                    for(int x = (iBars(SIMBA, TF) - HH[U]); x > 0; x++) {
                        if(iClose(SIMBA, TF, x) < iOpen(SIMBA, TF, x) && iLow(SIMBA, TF, x + 1) > iClose(SIMBA, TF, x)) {
                            WALLY = iLowest(SIMBA, TF, MODE_LOW, (x - (iBars(SIMBA, TF) - HH[U])) + 1, iBars(SIMBA, TF) - HH[U]);
                            break;
                        }
                    }
                    for(int x = (iBars(SIMBA, TF) - HH[U]); x > CURRCANDX; x--) {
                        if(iClose(SIMBA, TF, x) < iLow(SIMBA, TF, WALLY)) {
                            MITIGATED = x;
                            break;
                        }
                    }
                }
                if(MITIGATED == 0) MITIGATED = (iBars(SIMBA, TF) - BREAKER[U]) - 1;
                if(MITIGATED != 0) {
                    for(int x = MITIGATED - 1; x >= CURRCANDX; x--) {
                        if(iHigh(SIMBA, TF, x) > iLow(SIMBA, TF, iBars(SIMBA, TF) - HH[U])) {
                            RTS[U] = iBars(SIMBA, TF) - x;
                            break;
                        }
                    }
                }
            }
        }
        if(FLOW[U] == 1) {
            if(RTO[U] == -1) {
                int MITIGATED = 0;
                MITIGATED = (iBars(SIMBA, TF) - HH[U]) - 1;
                if(MITIGATED != 0) {
                    for(int x = MITIGATED - 1; x >= CURRCANDX; x--) {
                        if(iLow(SIMBA, TF, x) <= EQUILIBRIUM(SIMBA, TF, HH[U], LL[U])) {
                            RTO[U] = iBars(SIMBA, TF) - x;
                            break;
                        }
                    }
                }
            }
        }
        if(FLOW[U] == 2) {
            if(RTO[U] == -1) {
                int MITIGATED = 0;
                MITIGATED = (iBars(SIMBA, TF) - LL[U]) - 1;
                if(MITIGATED != 0) {
                    for(int x = MITIGATED - 1; x >= CURRCANDX; x--) {
                        if(iHigh(SIMBA, TF, x) >= EQUILIBRIUM(SIMBA, TF, HH[U], LL[U])) {
                            RTO[U] = iBars(SIMBA, TF) - x;
                            break;
                        }
                    }
                }
            }
        }
        if(FLOW[U] == 1) {
            if(SOURCEinv[U] == 0) {
                for(int k = (iBars(SIMBA, TF) - BREAKER[U]) - 1; k > CURRCANDX; k--) {
                    if(iClose(SIMBA, TF, k) < iLow(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, 1 + (BREAKER[U] - LL[U]), iBars(SIMBA, TF) - BREAKER[U]))) {
                        SOURCEinv[U] = iBars(SIMBA, TF) - k;
                        break;
                    }
                }
            }
        }
        if(FLOW[U] == 2) {
            if(SOURCEinv[U] == 0) {
                for(int k = (iBars(SIMBA, TF) - BREAKER[U]) - 1; k > CURRCANDX; k--) {
                    if(iClose(SIMBA, TF, k) > iHigh(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, 1 + (BREAKER[U] - HH[U]), iBars(SIMBA, TF) - BREAKER[U]))) {
                        SOURCEinv[U] = iBars(SIMBA, TF) - k;
                        break;
                    }
                }
            }
        }
    }
    return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int PREMIUMDISCOUNT(string SIMBA, int TF, int CURRCANDX)
{
    if(CURRCANDX != 0) CURRCANDX = iBarShift(SIMBA, TF, iTime(SIMBA, GlobalVariableGet(SIMBA + "TFBARRE"), GlobalVariableGet(SIMBA + "BARRE")));
    double RH = GlobalVariableGet(SIMBA + TF + "RANGEh");
    double RL = GlobalVariableGet(SIMBA + TF + "RANGEl");
    double FF = GlobalVariableGet(SIMBA + TF + "RANGEf");
    double RANGE = RH - RL;
    double EQ = (RH + RL) / 2;
    double FIBER = 0;
    if(FF == 1) {
        FIBER = (RH - iClose(SIMBA, TF, CURRCANDX)) / RANGE * 100;
    }
    if(FF == 2) {
        FIBER = (iClose(SIMBA, TF, CURRCANDX) - RL) / RANGE * 100;
    }
    string WHAT = "SD";
    if(iClose(SIMBA, TF, CURRCANDX) > EQ) WHAT = DoubleToString(FIBER, 0) + " %";
    if(iClose(SIMBA, TF, CURRCANDX) < EQ) WHAT = DoubleToString(FIBER, 0) + " %";
    if(iClose(SIMBA, TF, CURRCANDX) == EQ) WHAT = "Equilibrium";
// PREMIUM DISCOUNT
    if(FF == 1 && FIBER > 50) WHAT = "D " + WHAT;
    if(FF == 1 && FIBER < 50) WHAT = "P " + WHAT;
    if(FF == 2 && FIBER > 50) WHAT = "P " + WHAT;
    if(FF == 2 && FIBER < 50) WHAT = "D " + WHAT;
// END PREMIUM DISCOUNT
    string MOTHER = "BUTXTD0_" + tftransformation(TF);
    EditCreate(0, "BUTXTD0_" + tftransformation(TF) + "_FAREA", 0,
               ObjectGetInteger(0, MOTHER, OBJPROP_XDISTANCE) / ZOOM_PIXEL, ObjectGetInteger(0, MOTHER, OBJPROP_YDISTANCE) / ZOOM_PIXEL - 20, ObjectGetInteger(0, MOTHER, OBJPROP_XSIZE) / ZOOM_PIXEL, ObjectGetInteger(0, MOTHER, OBJPROP_YSIZE) / ZOOM_PIXEL,
               WHAT, "Arial", FONT_SIZE, ALIGN_CENTER, true, CORNER_LEFT_LOWER, clrBlack);
    if(FF == 1 && FIBER < 50) EditTextChange(0, "BUTXTD0_" + tftransformation(TF) + "_FAREA", WHAT, clrBlack, clrWhite);
    if(FF == 1 && FIBER > 50) EditTextChange(0, "BUTXTD0_" + tftransformation(TF) + "_FAREA", WHAT, clrBlue, clrWhite);
    if(FF == 2 && FIBER < 50) EditTextChange(0, "BUTXTD0_" + tftransformation(TF) + "_FAREA", WHAT, clrBlack, clrWhite);
    if(FF == 2 && FIBER > 50) EditTextChange(0, "BUTXTD0_" + tftransformation(TF) + "_FAREA", WHAT, clrOrange, clrWhite);
    return(0);
}
//+------------------------------------------------------------------+
