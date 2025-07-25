//+------------------------------------------------------------------+
//|                                                 ChartObjects.mqh |
//+------------------------------------------------------------------+
//| Chart Objects and UI Management for Web24hub EA                 |
//+------------------------------------------------------------------+
#property strict

// Display Control Variables
int SPECIALBOLLVALUE = 0;
int ICHI = 0;
int SESSION = 0;
int SESSIONtype = 0;
int VEDIPD = 0;
int VEDIPW = 0;
int VEDIPM = 0;
bool HIGH_LOW_KILLZONE = false;

int LAST_LEG0 = 0;
int LAST_LEG0flow = 0;
int LAST_LEG1 = 0;
int LAST_LEG1flow = 0;
int LAST_LEG2 = 0;
int LAST_LEG2flow = 0;

int LAST_SOURCE_A;
int LAST_STARTER_SOURCE;
double LAST_RTSFUCK;
double LAST_BMSall;
double LAST_BMSallnature;
double LAST_BMSoppall;
double LAST_BMS;
double LAST_BMSbreak;
int LAST_HH;
int LAST_LL;
double LAST_EQ;
double LAST_HH_OLD;
double LAST_LL_OLD;
int LAST_FLOW;
double LAST_FLOWprev;
double LAST_OBresp;
int LAST_BREAKER;
double LAST_RTO;
double LAST_RTS;
double LAST_HH_SUPPLY;
int LAST_HH_SUPPLY_index;
double LAST_LL_DEMAND;
int LAST_LL_DEMAND_index;
double LAST_OB_SUPPLY;
double LAST_OB_DEMAND;
double LAST_RTO_CHECK;
double LAST_RTS_CHECK;
int LAST_REV_index = 0;
int LAST_TF = 0;

int M1CANDLE;
double M1BMSall[];
double M1BMSallnature[];
double M1BMS[];
double M1BMSbreak[];
double M1HH[];
double M1LL[];
double M1FLOW[];
double M1OBresp[];
double M1BREAKER[];
double M1RTO[];
double M1RTOall[];
double M1RTS[];
double M1FVG[];
double M1FVGnat[];
double M1INVALID[];

int M5CANDLE;
double M5BMSall[];
double M5BMSallnature[];
double M5BMS[];
double M5BMSbreak[];
double M5HH[];
double M5LL[];
double M5FLOW[];
double M5OBresp[];
double M5BREAKER[];
double M5RTO[];
double M5RTOall[];
double M5RTS[];
double M5FVG[];
double M5FVGnat[];
double M5INVALID[];

int M15CANDLE;
double M15BMSall[];
double M15BMSallnature[];
double M15BMS[];
double M15BMSbreak[];
double M15HH[];
double M15LL[];
double M15FLOW[];
double M15OBresp[];
double M15BREAKER[];
double M15RTO[];
double M15RTOall[];
double M15RTS[];
double M15FVG[];
double M15FVGnat[];
double M15INVALID[];

int M30CANDLE;
double M30BMSall[];
double M30BMSallnature[];
double M30BMS[];
double M30BMSbreak[];
double M30HH[];
double M30LL[];
double M30FLOW[];
double M30OBresp[];
double M30BREAKER[];
double M30RTO[];
double M30RTOall[];
double M30RTS[];
double M30FVG[];
double M30FVGnat[];
double M30INVALID[];

int H1CANDLE;
double H1BMSall[];
double H1BMSallnature[];
double H1BMS[];
double H1BMSbreak[];
double H1HH[];
double H1LL[];
double H1FLOW[];
double H1OBresp[];
double H1BREAKER[];
double H1RTO[];
double H1RTOall[];
double H1RTS[];
double H1FVG[];
double H1FVGnat[];
double H1INVALID[];

int H4CANDLE;
double H4BMSall[];
double H4BMSallnature[];
double H4BMS[];
double H4BMSbreak[];
double H4HH[];
double H4LL[];
double H4FLOW[];
double H4OBresp[];
double H4BREAKER[];
double H4RTO[];
double H4RTOall[];
double H4RTS[];
double H4FVG[];
double H4FVGnat[];
double H4INVALID[];

int D1CANDLE;
double D1BMSall[];
double D1BMSallnature[];
double D1BMS[];
double D1BMSbreak[];
double D1HH[];
double D1LL[];
double D1FLOW[];
double D1OBresp[];
double D1BREAKER[];
double D1RTO[];
double D1RTOall[];
double D1RTS[];
double D1FVG[];
double D1FVGnat[];
double D1INVALID[];

int W1CANDLE;
double W1BMSall[];
double W1BMSallnature[];
double W1BMS[];
double W1BMSbreak[];
double W1HH[];
double W1LL[];
double W1FLOW[];
double W1OBresp[];
double W1BREAKER[];
double W1RTO[];
double W1RTOall[];
double W1RTS[];
double W1FVG[];
double W1FVGnat[];
double W1INVALID[];

int MN1CANDLE;
double MN1BMSall[];
double MN1BMSallnature[];
double MN1BMS[];
double MN1BMSbreak[];
double MN1HH[];
double MN1LL[];
double MN1FLOW[];
double MN1OBresp[];
double MN1BREAKER[];
double MN1RTO[];
double MN1RTOall[];
double MN1RTS[];
double MN1FVG[];
double MN1FVGnat[];
double MN1INVALID[];
//+------------------------------------------------------------------+
//| Utility Functions                                               |
//+------------------------------------------------------------------+
int DASHDISTX(string name)
{
    return((int)(ObjectGetInteger(0, name, OBJPROP_XDISTANCE) + ObjectGetInteger(0, name, OBJPROP_XSIZE)));
}

//+------------------------------------------------------------------+
//| Create Button                                                   |
//+------------------------------------------------------------------+
bool Create_Button(long              chart_ID,               // chart's ID
                   string            name,      // button name
                   int               sub_window,             // subwindow index
                   int               x,// X coordinate
                   int               y,// Y coordinate
                   int               width,                 // button width
                   int               height,                // button height
                   ENUM_BASE_CORNER  corner, // chart corner for anchoring
                   string            text,            // text
                   color             back_clr       // background color
                  )
{
    string            font = "Arial";     // font
    int               font_size = FONT_SIZE;           // font size
    color             clr = clrBlack;          // text color
    bool              back = false     ;         // in the background
    int btn_border_color = clrBlack;
//--- reset the error value
    ResetLastError();
//--- create the button
    ObjectCreate(chart_ID, name, OBJ_BUTTON, sub_window, 0, 0);
    ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x * ZOOM_PIXEL);
    ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y * ZOOM_PIXEL);
    ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width * ZOOM_PIXEL);
    ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height * ZOOM_PIXEL);
    ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
    ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
    ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
    ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
    ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr);
    ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_COLOR, btn_border_color);
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
    ObjectSetInteger(chart_ID, name, OBJPROP_STATE, false);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, false);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, false);
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, false);
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, 0);
//--- successful execution
    return(true);
}

//+------------------------------------------------------------------+
//| Create Edit Field                                               |
//+------------------------------------------------------------------+
bool EditCreate(const long             chart_ID = 0,             // chart's ID
                const string           name = "Edit",            // object name
                const int              sub_window = 0,           // subwindow index
                const int              x = 0,                    // X coordinate
                const int              y = 0,                    // Y coordinate
                const int              width = 50,               // width
                const int              height = 18,              // height
                const string           text = "Text",            // text
                const string           font = "Arial",           // font
                const int font_size = 8,
                const ENUM_ALIGN_MODE  align = ALIGN_CENTER,     // alignment type
                const bool             read_only = false,        // ability to edit
                const ENUM_BASE_CORNER corner = CORNER_LEFT_UPPER, // chart corner for anchoring
                const color            clr = clrBlack,           // text color
                const color            back_clr = clrWhite,      // background color
                const color            border_clr = clrNONE,     // border color
                const bool             back = false,             // in the background
                const bool             selection = false,        // highlight to move
                const bool             hidden = true,            // hidden in the object list
                const long             z_order = 0)
// font size)                // priority for mouse click
{
    if(ObjectFind(chart_ID, name) >= 0) return(false);
//--- reset the error value
    ResetLastError();
//--- create edit field
    if(!ObjectCreate(chart_ID, name, OBJ_EDIT, sub_window, 0, 0)) {
        Print(__FUNCTION__,
              ": failed to create \"Edit\" object! Error code = ", GetLastError());
        return(false);
    }
//--- set object coordinates
    ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
//--- set object size
    ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width);
    ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height);
//--- set the text
    ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
//--- set text font
    ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
//--- set font size
    ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
//--- set the type of text alignment in the object
    ObjectSetInteger(chart_ID, name, OBJPROP_ALIGN, align);
//--- enable (true) or cancel (false) read-only mode
    ObjectSetInteger(chart_ID, name, OBJPROP_READONLY, read_only);
//--- set the chart's corner, relative to which object coordinates are defined
    ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
//--- set text color
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- set background color
    ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr);
//--- set border color
    ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_COLOR, border_clr);
//--- display in the foreground (false) or background (true)
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
//--- hide (true) or display (false) graphical object name in the object list
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
    return(true);
}

//+------------------------------------------------------------------+
//| Change Edit Object's Text                                       |
//+------------------------------------------------------------------+
bool EditTextChange(const long   chart_ID = 0, // chart's ID
                    const string name = "Edit", // object name
                    const string text = "Text",
                    const int clr = clrWhite,
                    const int backclr = clrBlack) // text

{
    if(ObjectFind(0, name) < 0) return(false);
//--- reset the error value
    ResetLastError();
//--- change object text
    if(!ObjectSetString(chart_ID, name, OBJPROP_TEXT, text)) {
        return(false);
    }
//--- successful execution
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
    ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, backclr);
    ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_COLOR, clrBlack);
    return(true);
}

//+------------------------------------------------------------------+
//| Create Rectangle Label                                          |
//+------------------------------------------------------------------+
bool RectLabelCreate( long             chart_ID,               // chart's ID
                      string           name,         // label name
                      int              sub_window,             // subwindow index
                      int              x,                      // X coordinate
                      int              y,                      // Y coordinate
                      int              width,                 // width
                      int              height,                // height
                      color            back_clr,  // background color
                      int border,     // border type
                      int corner, // chart corner for anchoring
                      int             clr,               // flat border color (Flat)
                      int style,        // flat border style
                      const int              line_width = 1,           // flat border width
                      const bool             back = false,             // in the background
                      const bool             selection = false,        // highlight to move
                      const bool             hidden = true,            // hidden in the object list
                      const long             z_order = 0)              // priority for mouse click
{
//--- reset the error value
    ResetLastError();
//--- create a rectangle label
    if(!ObjectCreate(chart_ID, name, OBJ_RECTANGLE_LABEL, sub_window, 0, 0)) {
        Print(__FUNCTION__,
              ": failed to create a rectangle label! Error code = ", GetLastError());
        return(false);
    }
//--- set label coordinates
    ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
//--- set label size
    ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width);
    ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height);
//--- set background color
    ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr);
//--- set border type
    ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_TYPE, border);
//--- set the chart's corner, relative to which point coordinates are defined
    ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
//--- set flat border color (in Flat mode)
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- set flat border line style
    ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, style);
//--- set flat border width
    ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, line_width);
//--- display in the foreground (false) or background (true)
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
//--- hide (true) or display (false) graphical object name in the object list
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
    return(true);
}

//+------------------------------------------------------------------+
//| Move Rectangle Label                                            |
//+------------------------------------------------------------------+
bool RectLabelMove(long   chart_ID,       // chart's ID
                   string name, // label name
                   int    x,              // X coordinate
                   int    y)              // Y coordinate
{
//--- reset the error value
    ResetLastError();
//--- move the rectangle label
    if(!ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x)) {
        Print(__FUNCTION__,
              ": failed to move X coordinate of the label! Error code = ", GetLastError());
        return(false);
    }
    if(!ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y)) {
        Print(__FUNCTION__,
              ": failed to move Y coordinate of the label! Error code = ", GetLastError());
        return(false);
    }
//--- successful execution
    return(true);
}

//+------------------------------------------------------------------+
//| Change Rectangle Label Size                                     |
//+------------------------------------------------------------------+
bool RectLabelChangeSize( long   chart_ID,       // chart's ID
                          string name, // label name
                          int    width,         // label width
                          int    height)        // label height
{
//--- reset the error value
    ResetLastError();
//--- change label size
    if(!ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width)) {
        Print(__FUNCTION__,
              ": failed to change the label's width! Error code = ", GetLastError());
        return(false);
    }
    if(!ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height)) {
        Print(__FUNCTION__,
              ": failed to change the label's height! Error code = ", GetLastError());
        return(false);
    }
//--- successful execution
    return(true);
}

//+------------------------------------------------------------------+
//| Create Text Label (Top Left)                                   |
//+------------------------------------------------------------------+
bool LabelCreate_topleft(long              chart_ID,               // chart's ID
                         string            name,             // label name
                         int               sub_window,             // subwindow index
                         int               x,                      // X coordinate
                         int               y,                      // Y coordinate
                         int anchor = ANCHOR_LEFT_UPPER, // anchor type
                         const ENUM_BASE_CORNER  corner = CORNER_LEFT_UPPER, // chart corner for anchoring
                         const string            text = "L",           // text
                         const string            font = "Arial",           // font
                         const color             clr = clrWhite,             // color
                         const double            angle = 0.0,              // text slope
                         const bool              back = false,             // in the background
                         const bool              selection = false,        // highlight to move
                         const bool              hidden = true,            // hidden in the object list
                         const long              z_order = 0)              // priority for mouse click
{
    if(!ObjectFind(chart_ID, name)) return(false);
    int font_size = FONT_SIZE;
//--- reset the error value
    ResetLastError();
//--- create a text label
    if(!ObjectCreate(chart_ID, name, OBJ_LABEL, sub_window, 0, 0)) {
        Print(__FUNCTION__,
              ": failed to create text label! Error code = ", GetLastError());
        return(false);
    }
//--- set label coordinates
    ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
//--- set the chart's corner, relative to which point coordinates are defined
    ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
//--- set the text
    ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
//--- set text font
    ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
//--- set font size
    ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, FONT_SIZE);
//--- set the slope angle of the text
    ObjectSetDouble(chart_ID, name, OBJPROP_ANGLE, angle);
//--- set anchor type
    ObjectSetInteger(chart_ID, name, OBJPROP_ANCHOR, anchor);
//--- set color
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- display in the foreground (false) or background (true)
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
//--- hide (true) or display (false) graphical object name in the object list
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
    return(true);
}

//+------------------------------------------------------------------+
//| Create Text Label (Top Right)                                  |
//+------------------------------------------------------------------+
bool LabelCreate_topright(long              chart_ID,               // chart's ID
                          string            name,             // label name
                          int               sub_window,             // subwindow index
                          int               x,                      // X coordinate
                          int               y,                      // Y coordinate
                          const ENUM_BASE_CORNER  corner = CORNER_LEFT_UPPER, // chart corner for anchoring
                          const string            text = "L",           // text
                          const string            font = "Arial",           // font
                          const color             clr = clrWhite,             // color
                          const double            angle = 0.0,              // text slope
                          const ENUM_ANCHOR_POINT anchor = ANCHOR_RIGHT_UPPER, // anchor type
                          const bool              back = false,             // in the background
                          const bool              selection = false,        // highlight to move
                          const bool              hidden = true,            // hidden in the object list
                          const long              z_order = 0)              // priority for mouse click
{
    if(!ObjectFind(chart_ID, name)) return(false);
    int font_size = FONT_SIZE;
//--- reset the error value
    ResetLastError();
//--- create a text label
    if(!ObjectCreate(chart_ID, name, OBJ_LABEL, sub_window, 0, 0)) {
        Print(__FUNCTION__,
              ": failed to create text label! Error code = ", GetLastError());
        return(false);
    }
//--- set label coordinates
    ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
//--- set the chart's corner, relative to which point coordinates are defined
    ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
//--- set the text
    ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
//--- set text font
    ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
//--- set font size
    if(StringSubstr(name, 5, StringLen(name) - 6) == "INFO")  ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, FONT_SIZE + 5);
    else if(StringSubstr(name, 5, StringLen(name) - 6) == "VERS")  ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, FONT_SIZE);
    else ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, FONT_SIZE);
//--- set the slope angle of the text
    ObjectSetDouble(chart_ID, name, OBJPROP_ANGLE, angle);
//--- set anchor type
    ObjectSetInteger(chart_ID, name, OBJPROP_ANCHOR, anchor);
//--- set color
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- display in the foreground (false) or background (true)
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
//--- hide (true) or display (false) graphical object name in the object list
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
    return(true);
}

//+------------------------------------------------------------------+
//| Change Label Text                                               |
//+------------------------------------------------------------------+
bool LabelTextChange(long   chart_ID,   // chart's ID
                     string name, // object name
                     string text,
                     int clr)  // text
{
//--- reset the error value
    ResetLastError();
//--- change object text
    if(ObjectFind(name) >= 0) {
        if(!ObjectSetString(chart_ID, name, OBJPROP_TEXT, text)) {
            Print(__FUNCTION__,
                  ": failed to change the text! Error code = ", GetLastError());
            return(false);
        }
        ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
    }
//--- successful execution
    return(true);
}

//+------------------------------------------------------------------+
//| Show/Hide UI Elements                                           |
//+------------------------------------------------------------------+
void SHOWHIDE(int SHOW, string WHAT)
{
    if(SHOW == 0) {
        ObjectSetText("BUTT_" + WHAT, "<");
        int totalObjects = ObjectsTotal(0, 0, -1);
        for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
            if(StringSubstr(ObjectName(i), 0, 7) == "BUTX" + WHAT) ObjectSetInteger(0, ObjectName(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        }
        ChartSetInteger(0, CHART_FOREGROUND, 0);
    }
    if(SHOW == 1) {
        ObjectSetText("BUTT_" + WHAT, ">");
        int totalObjects = ObjectsTotal(0, 0, -1);
        for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
            if(StringSubstr(ObjectName(i), 0, 7) == "BUTX" + WHAT) ObjectSetInteger(0, ObjectName(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        }
        ChartSetInteger(0, CHART_FOREGROUND, 0);
    }
}

//+------------------------------------------------------------------+
//| Show/Hide Trade Manager                                         |
//+------------------------------------------------------------------+
void SHOWHIDE_TDM(int SHOW)
{
    if(SHOW == 0) {
        ObjectSetText("BUTT_TDM", "<");
        int totalObjects = ObjectsTotal(0, 0, -1);
        for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
            if(StringSubstr(ObjectName(i), 0, 7) == "BUTXTDM") ObjectSetInteger(0, ObjectName(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        }
        ChartSetInteger(0, CHART_FOREGROUND, 0);
    }
    if(SHOW == 1) {
        ObjectSetText("BUTT_TDM", ">");
        int totalObjects = ObjectsTotal(0, 0, -1);
        for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
            if(StringSubstr(ObjectName(i), 0, 7) == "BUTXTDM") ObjectSetInteger(0, ObjectName(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        }
        ChartSetInteger(0, CHART_FOREGROUND, 0);
    }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TRADING_PANEL(int SHOW)
{
    int LARGHEZZA = (ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0));
    int ALTEZZA = (ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, 0));
    ObjectCreate("BUTT_BACKGROUND", OBJ_RECTANGLE_LABEL, 0, 0, 0);
    ObjectSet("BUTT_BACKGROUND", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSet("BUTT_BACKGROUND", OBJPROP_XDISTANCE, 0);
    ObjectSet("BUTT_BACKGROUND", OBJPROP_YDISTANCE, 20);
    ObjectSet("BUTT_BACKGROUND", OBJPROP_XSIZE, 300);
    ObjectSet("BUTT_BACKGROUND", OBJPROP_YSIZE, ALTEZZA - 40);
    ObjectSet("BUTT_BACKGROUND", OBJPROP_BORDER_TYPE, BORDER_FLAT);
    ObjectSet("BUTT_BACKGROUND", OBJPROP_COLOR, clrWhite);
    ObjectSet("BUTT_BACKGROUND", OBJPROP_BGCOLOR, clrDarkGray);
    ObjectSet("BUTT_BACKGROUND", OBJPROP_BACK, 0);
    LabelCreate_topleft(0, "BUTT_TITLE", 0, 10, 40, ANCHOR_LEFT_UPPER);
    LabelTextChange(0, "BUTT_TITLE", "Trade Manager Web24hub", clrWhite);
    LabelCreate_topleft(0, "BUTT_SEP1", 0, 10, 50, ANCHOR_LEFT_UPPER);
    LabelTextChange(0, "BUTT_SEP1", "---------------------------------------------------------------------------", clrWhite);
    string ACCTIPO = "Demo";
    if(!IsDemo()) ACCTIPO = "Real";
    LabelCreate_topleft(0, "BUTT_ACC0", 0, 10, 60, ANCHOR_LEFT_UPPER);
    LabelTextChange(0, "BUTT_ACC0", "Account n° " + AccountNumber() + " " + ACCTIPO, clrWhite);
    LabelCreate_topleft(0, "BUTT_ACC1", 0, 10, 70, ANCHOR_LEFT_UPPER);
    LabelTextChange(0, "BUTT_ACC1", "Spread " + MarketInfo(Symbol(), MODE_SPREAD) + " points", clrWhite);
    LabelCreate_topleft(0, "BUTT_LONG", 0, 10, 90, ANCHOR_LEFT_UPPER);
    LabelTextChange(0, "BUTT_LONG", "Long pos : " + DoubleToStr(SOMMASIZE(Symbol(), OP_BUY), 2) + " | TP : " + PROFITTONE_FUTURO(Symbol(), OP_BUY) + " | SL : " + PERDITONE_FUTURO(Symbol(), OP_BUY), clrWhite);
    LabelCreate_topleft(0, "BUTT_SHORT", 0, 10, 110, ANCHOR_LEFT_UPPER);
    LabelTextChange(0, "BUTT_SHORT", "Short pos : " + DoubleToStr(SOMMASIZE(Symbol(), OP_SELL), 2) + " | TP : " + PROFITTONE_FUTURO(Symbol(), OP_SELL) + " | SL : " + PERDITONE_FUTURO(Symbol(), OP_BUY), clrWhite);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime LONGER(string SIM, int PERIODO, int shift)
{
    datetime tm = TimeDay(iTime(SIM, PERIODO, shift));
    switch (PERIODO) {
    case PERIOD_MN1:
        return tm - (tm % 86400) - ((TimeDay(tm) - 1) * 86400);
    case PERIOD_W1:
        return (((tm - 259200) / 604800) * 604800) + 259200;
    default:
        return 0;
    }
    return(tm);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CREATETEXTPRICEprice(string nametext, string caption, datetime time, double price, int colore, int ANCHOR)
{
    if(ObjectFind(0, nametext) < 0) {
        ObjectCreate(0, nametext, OBJ_TEXT, 0, time, price);
        ObjectSetText(nametext, caption, FONT_SIZE_CHART_TEXT, "Arial", colore);
        ObjectSetInteger(0, nametext, OBJPROP_ANCHOR, ANCHOR);
        ObjectSetInteger(0, nametext, OBJPROP_HIDDEN, true);
    }
    else {
        if(ObjectGet(nametext, OBJPROP_TIME1) != time) ObjectMove(0, nametext, 0, time, price);
        if(ObjectGet(nametext, OBJPROP_PRICE1) != price) ObjectMove(0, nametext, 0, time, price);
        if(ObjectGet(nametext, OBJPROP_TEXT) != caption) ObjectSetText(nametext, caption, FONT_SIZE_CHART_TEXT, "Arial", colore);
    }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SPECIALBOLL(string SIMBA, int TFX, int VAL)
{
    if(VAL == 0) {
        int totalObjects = ObjectsTotal(0, 0, -1);
        for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
            if(StringSubstr(ObjectName(i), 0, 3) == "AVG") ObjectDelete(ObjectName(i));
        }
        return(0);
    }
    else {
        for(int i = MathMin(3000, iBars(SIMBA, TFX) - 100); i > 0; i--) {
            double AVGH0 = iMA(SIMBA, TFX, 208, 0, MODE_SMA, PRICE_HIGH, i);
            double AVGH1 = iMA(SIMBA, TFX, 208, 0, MODE_SMA, PRICE_HIGH, i - 1);
            double AVGL0 = iMA(SIMBA, TFX, 208, 0, MODE_SMA, PRICE_LOW, i);
            double AVGL1 = iMA(SIMBA, TFX, 208, 0, MODE_SMA, PRICE_LOW, i - 1);
            ObjectCreate(0, "AVGH" + i, OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectSetInteger(0, "AVGH" + i, OBJPROP_HIDDEN, true);
            ObjectMove(0, "AVGH" + i, 0, iTime(SIMBA, TFX, i), AVGH0);
            ObjectMove(0, "AVGH" + i, 1, iTime(SIMBA, TFX, i - 1), AVGH1);
            ObjectSetInteger(0, "AVGH" + i, OBJPROP_RAY, false);
            ObjectSetInteger(0, "AVGH" + i, OBJPROP_COLOR, clrLime);
            ObjectCreate(0, "AVGL" + i, OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectSetInteger(0, "AVGL" + i, OBJPROP_HIDDEN, true);
            ObjectMove(0, "AVGL" + i, 0, iTime(SIMBA, TFX, i), AVGL0);
            ObjectMove(0, "AVGL" + i, 1, iTime(SIMBA, TFX, i - 1), AVGL1);
            ObjectSetInteger(0, "AVGL" + i, OBJPROP_RAY, false);
            ObjectSetInteger(0, "AVGL" + i, OBJPROP_COLOR, clrRed);
            double AVGHU0 = iBands(SIMBA, TFX, 208, 2, 0, PRICE_HIGH, 1, i);
            double AVGHU1 = iBands(SIMBA, TFX, 208, 2, 0, PRICE_HIGH, 1, i - 1);
            double AVGHL0 = iBands(SIMBA, TFX, 208, 2, 0, PRICE_LOW, 1, i);
            double AVGHL1 = iBands(SIMBA, TFX, 208, 2, 0, PRICE_LOW, 1, i - 1);
            ObjectCreate(0, "AVGHU" + i, OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectSetInteger(0, "AVGHU" + i, OBJPROP_HIDDEN, true);
            ObjectMove(0, "AVGHU" + i, 0, iTime(SIMBA, TFX, i), AVGHU0);
            ObjectMove(0, "AVGHU" + i, 1, iTime(SIMBA, TFX, i - 1), AVGHU1);
            ObjectSetInteger(0, "AVGHU" + i, OBJPROP_RAY, false);
            ObjectSetInteger(0, "AVGHU" + i, OBJPROP_COLOR, clrLime);
            ObjectCreate(0, "AVGHL" + i, OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectSetInteger(0, "AVGHL" + i, OBJPROP_HIDDEN, true);
            ObjectMove(0, "AVGHL" + i, 0, iTime(SIMBA, TFX, i), AVGHL0);
            ObjectMove(0, "AVGHL" + i, 1, iTime(SIMBA, TFX, i - 1), AVGHL1);
            ObjectSetInteger(0, "AVGHL" + i, OBJPROP_RAY, false);
            ObjectSetInteger(0, "AVGHL" + i, OBJPROP_COLOR, clrRed);
            double AVGLU0 = iBands(SIMBA, TFX, 208, 2, 0, PRICE_HIGH, 2, i);
            double AVGLU1 = iBands(SIMBA, TFX, 208, 2, 0, PRICE_HIGH, 2, i - 1);
            double AVGLL0 = iBands(SIMBA, TFX, 208, 2, 0, PRICE_LOW, 2, i);
            double AVGLL1 = iBands(SIMBA, TFX, 208, 2, 0, PRICE_LOW, 2, i - 1);
            ObjectCreate(0, "AVGLU" + i, OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectSetInteger(0, "AVGLU" + i, OBJPROP_HIDDEN, true);
            ObjectMove(0, "AVGLU" + i, 0, iTime(SIMBA, TFX, i), AVGLU0);
            ObjectMove(0, "AVGLU" + i, 1, iTime(SIMBA, TFX, i - 1), AVGLU1);
            ObjectSetInteger(0, "AVGLU" + i, OBJPROP_RAY, false);
            ObjectSetInteger(0, "AVGLU" + i, OBJPROP_COLOR, clrLime);
            ObjectCreate(0, "AVGLL" + i, OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectSetInteger(0, "AVGLL" + i, OBJPROP_HIDDEN, true);
            ObjectMove(0, "AVGLL" + i, 0, iTime(SIMBA, TFX, i), AVGLL0);
            ObjectMove(0, "AVGLL" + i, 1, iTime(SIMBA, TFX, i - 1), AVGLL1);
            ObjectSetInteger(0, "AVGLL" + i, OBJPROP_RAY, false);
            ObjectSetInteger(0, "AVGLL" + i, OBJPROP_COLOR, clrRed);
        }
    }
    return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int VEDIFIBO(string SIMBA, int TFX, int SINO, int LAST_LLx, int LAST_HHx, int FLOM)
{
    int totalObjects = ObjectsTotal(0, 0, -1);
    for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
        if(StringSubstr(ObjectName(i), 0, StringLen(TFX)) == TFX && StringSubstr(ObjectName(i), StringLen(TFX), 5) == "_FIBO") ObjectDelete(ObjectName(i));
    }
    if(SINO == 0) return(0);
    datetime starty = iTime(SIMBA, GlobalVariableGet(SIMBA + "TFBARRE"), GlobalVariableGet(SIMBA + "BARRE")) + 12 * PeriodSeconds();
    ObjectCreate(0, TFX + "_FIBO_RR", OBJ_FIBO, 0, 0, 0, 0, 0);
    ObjectSetInteger(0, TFX + "_FIBO_RR", OBJPROP_LEVELCOLOR, clrDimGray);
    double POINTZERO = 0;
    double POINT100 = 0;
    if(FLOM == 1) {
        POINTZERO = iLow(SIMBA, TFX, iBars(SIMBA, TFX) - LAST_LLx);
        POINT100 = iHigh(SIMBA, TFX, iBars(SIMBA, TFX) - LAST_HHx);
    }
    if(FLOM == 2) {
        POINTZERO = iHigh(SIMBA, TFX, iBars(SIMBA, TFX) - LAST_HHx);
        POINT100 = iLow(SIMBA, TFX, iBars(SIMBA, TFX) - LAST_LLx);
    }
    ObjectMove(0, TFX + "_FIBO_RR", 0, starty, POINTZERO);
    ObjectMove(0, TFX + "_FIBO_RR", 1, starty, POINT100);
    ObjectSet(TFX + "_FIBO_RR", OBJPROP_FIBOLEVELS, 9);
    ObjectSet(TFX + "_FIBO_RR", OBJPROP_RAY_RIGHT, true);
    ObjectSetFiboDescription(TFX + "_FIBO_RR", 1, "50 Equilibrium  %$");
    ObjectSetFiboDescription(TFX + "_FIBO_RR", 2, "61.8 Percent  %$");
    ObjectSetFiboDescription(TFX + "_FIBO_RR", 4, "OTE  %$");
    ObjectSetFiboDescription(TFX + "_FIBO_RR", 5, "79  %$");
    ObjectSetFiboDescription(TFX + "_FIBO_RR", 6, "Target 2  %$");
    ObjectSetFiboDescription(TFX + "_FIBO_RR", 7, "Target 1  %$");
    ObjectSetFiboDescription(TFX + "_FIBO_RR", 8, "Symmetrical Price  %$");
    ObjectSetDouble(0, TFX + "_FIBO_RR", OBJPROP_LEVELVALUE, 1, 0.5);
    ObjectSetDouble(0, TFX + "_FIBO_RR", OBJPROP_LEVELVALUE, 2, 0.618);
    ObjectSetDouble(0, TFX + "_FIBO_RR", OBJPROP_LEVELVALUE, 4, 0.705);
    ObjectSetDouble(0, TFX + "_FIBO_RR", OBJPROP_LEVELVALUE, 5, 0.79);
    ObjectSetDouble(0, TFX + "_FIBO_RR", OBJPROP_LEVELVALUE, 6, -0.62);
    ObjectSetDouble(0, TFX + "_FIBO_RR", OBJPROP_LEVELVALUE, 7, -0.27);
    ObjectSetDouble(0, TFX + "_FIBO_RR", OBJPROP_LEVELVALUE, 8, -1);
    if(FLOM == 1) {
        double ENTRYZONE0 = POINT100 - (POINT100 - POINTZERO) * 0.79;
        double ENTRYZONE1 = POINT100 - (POINT100 - POINTZERO) * 0.618;
        ObjectCreate(0, TFX + "_FIBO_RR_OTE", OBJ_RECTANGLE, 0, 0, 0, 0, 0);
        ObjectMove(0, TFX + "_FIBO_RR_OTE", 0, starty, ENTRYZONE0);
        ObjectMove(0, TFX + "_FIBO_RR_OTE", 1, starty + PeriodSeconds(Period() * 60 * 10), ENTRYZONE1);
        ObjectSetInteger(0, TFX + "_FIBO_RR_OTE", OBJPROP_COLOR, C'255,241,166');
        double STOPLOSSZONE0 = POINT100 - (POINT100 - POINTZERO) * 0.79;
        double STOPLOSSZONE1 = POINTZERO - (POINT100 - POINTZERO) * 0;
        ObjectCreate(0, TFX + "_FIBO_RR_SL", OBJ_RECTANGLE, 0, 0, 0, 0, 0);
        ObjectMove(0, TFX + "_FIBO_RR_SL", 0, starty, STOPLOSSZONE0);
        ObjectMove(0, TFX + "_FIBO_RR_SL", 1, starty + PeriodSeconds(Period() * 60 * 10), STOPLOSSZONE1);
        ObjectSetInteger(0, TFX + "_FIBO_RR_SL", OBJPROP_COLOR, C'255,189,164');
        double SAFEPROFITZONE0 = POINT100 - (POINT100 - POINTZERO) * 0.618;
        double SAFEPROFITZONE1 = POINT100 + (POINT100 - POINTZERO) * 1;
        ObjectCreate(0, TFX + "_FIBO_RR_TP", OBJ_RECTANGLE, 0, 0, 0, 0, 0);
        ObjectMove(0, TFX + "_FIBO_RR_TP", 0, starty, SAFEPROFITZONE0);
        ObjectMove(0, TFX + "_FIBO_RR_TP", 1, starty + PeriodSeconds(Period() * 60 * 10), SAFEPROFITZONE1);
        ObjectSetInteger(0, TFX + "_FIBO_RR_TP", OBJPROP_COLOR, C'191,240,191');
        ObjectCreate(0, TFX + "_FIBO_EQUILIBRIUM", OBJ_TREND, 0, 0, 0, 0, 0);
        ObjectSetInteger(0, TFX + "_FIBO_EQUILIBRIUM", OBJPROP_RAY, false);
        ObjectSetInteger(0, TFX + "_FIBO_EQUILIBRIUM", OBJPROP_COLOR, clrWhite);
        ObjectCreate(0, TFX + "_FIBO_PREMIUM", OBJ_TEXT, 0, 0, 0, 0, 0);
        ObjectSetText(TFX + "_FIBO_PREMIUM", "PREMIUM", FONT_SIZE_CHART_TEXT);
        ObjectSetInteger(0, TFX + "_FIBO_PREMIUM", OBJPROP_ANCHOR, ANCHOR_CENTER);
        ObjectSetInteger(0, TFX + "_FIBO_PREMIUM", OBJPROP_COLOR, clrWhite);
        ObjectSetDouble(0, TFX + "_FIBO_PREMIUM", OBJPROP_ANGLE, 90);
        ObjectCreate(0, TFX + "_FIBO_DISCOUNT", OBJ_TEXT, 0, 0, 0, 0, 0);
        ObjectSetText(TFX + "_FIBO_DISCOUNT", "DISCOUNT", FONT_SIZE_CHART_TEXT);
        ObjectSetInteger(0, TFX + "_FIBO_DISCOUNT", OBJPROP_ANCHOR, ANCHOR_CENTER);
        ObjectSetInteger(0, TFX + "_FIBO_DISCOUNT", OBJPROP_COLOR, clrWhite);
        ObjectSetDouble(0, TFX + "_FIBO_DISCOUNT", OBJPROP_ANGLE, 90);
        ObjectMove(0, TFX + "_FIBO_EQUILIBRIUM", 0, starty - 2 * PeriodSeconds(), (POINT100 + POINTZERO) / 2);
        ObjectMove(0, TFX + "_FIBO_EQUILIBRIUM", 1, starty, (POINT100 + POINTZERO) / 2);
        ObjectMove(0, TFX + "_FIBO_PREMIUM", 0, starty - PeriodSeconds(), (POINT100 + (POINT100 + POINTZERO) / 2) / 2);
        ObjectMove(0, TFX + "_FIBO_PREMIUM", 1, starty, (POINT100 + (POINT100 + POINTZERO) / 2) / 2);
        ObjectMove(0, TFX + "_FIBO_DISCOUNT", 0, starty - PeriodSeconds(), (POINTZERO + (POINT100 + POINTZERO) / 2) / 2);
        ObjectMove(0, TFX + "_FIBO_DISCOUNT", 1, starty, (POINTZERO + (POINT100 + POINTZERO) / 2) / 2);
    }
    if(FLOM == 2) {
        double ENTRYZONE0 = POINT100 - (POINT100 - POINTZERO) * 0.79;
        double ENTRYZONE1 = POINT100 - (POINT100 - POINTZERO) * 0.618;
        ObjectCreate(0, TFX + "_FIBO_RR_OTE", OBJ_RECTANGLE, 0, 0, 0, 0, 0);
        ObjectMove(0, TFX + "_FIBO_RR_OTE", 0, starty, ENTRYZONE0);
        ObjectMove(0, TFX + "_FIBO_RR_OTE", 1, starty + PeriodSeconds(Period() * 60 * 10), ENTRYZONE1);
        ObjectSetInteger(0, TFX + "_FIBO_RR_OTE", OBJPROP_COLOR, C'255,241,166');
        double STOPLOSSZONE0 = POINT100 - (POINT100 - POINTZERO) * 0.79;
        double STOPLOSSZONE1 = POINTZERO - (POINT100 - POINTZERO) * 0;
        ObjectCreate(0, TFX + "_FIBO_RR_SL", OBJ_RECTANGLE, 0, 0, 0, 0, 0);
        ObjectMove(0, TFX + "_FIBO_RR_SL", 0, starty, STOPLOSSZONE0);
        ObjectMove(0, TFX + "_FIBO_RR_SL", 1, starty + PeriodSeconds(Period() * 60 * 10), STOPLOSSZONE1);
        ObjectSetInteger(0, TFX + "_FIBO_RR_SL", OBJPROP_COLOR, C'255,189,164');
        double SAFEPROFITZONE0 = POINT100 - (POINT100 - POINTZERO) * 0.618;
        double SAFEPROFITZONE1 = POINT100 + (POINT100 - POINTZERO) * 1;
        ObjectCreate(0, TFX + "_FIBO_RR_TP", OBJ_RECTANGLE, 0, 0, 0, 0, 0);
        ObjectMove(0, TFX + "_FIBO_RR_TP", 0, starty, SAFEPROFITZONE0);
        ObjectMove(0, TFX + "_FIBO_RR_TP", 1, starty + PeriodSeconds(Period() * 60 * 10), SAFEPROFITZONE1);
        ObjectSetInteger(0, TFX + "_FIBO_RR_TP", OBJPROP_COLOR, C'191,240,191');
        ObjectCreate(0, TFX + "_FIBO_EQUILIBRIUM", OBJ_TREND, 0, 0, 0, 0, 0);
        ObjectSetInteger(0, TFX + "_FIBO_EQUILIBRIUM", OBJPROP_RAY, false);
        ObjectSetInteger(0, TFX + "_FIBO_EQUILIBRIUM", OBJPROP_COLOR, clrWhite);
        ObjectCreate(0, TFX + "_FIBO_PREMIUM", OBJ_TEXT, 0, 0, 0, 0, 0);
        ObjectSetText(TFX + "_FIBO_PREMIUM", "PREMIUM", FONT_SIZE_CHART_TEXT);
        ObjectSetInteger(0, TFX + "_FIBO_PREMIUM", OBJPROP_ANCHOR, ANCHOR_CENTER);
        ObjectSetInteger(0, TFX + "_FIBO_PREMIUM", OBJPROP_COLOR, clrWhite);
        ObjectSetDouble(0, TFX + "_FIBO_PREMIUM", OBJPROP_ANGLE, 90);
        ObjectCreate(0, TFX + "_FIBO_DISCOUNT", OBJ_TEXT, 0, 0, 0, 0, 0);
        ObjectSetText(TFX + "_FIBO_DISCOUNT", "DISCOUNT", FONT_SIZE_CHART_TEXT);
        ObjectSetInteger(0, TFX + "_FIBO_DISCOUNT", OBJPROP_ANCHOR, ANCHOR_CENTER);
        ObjectSetInteger(0, TFX + "_FIBO_DISCOUNT", OBJPROP_COLOR, clrWhite);
        ObjectSetDouble(0, TFX + "_FIBO_DISCOUNT", OBJPROP_ANGLE, 90);
        ObjectMove(0, TFX + "_FIBO_EQUILIBRIUM", 0, starty - 2 * PeriodSeconds(), (POINT100 + POINTZERO) / 2);
        ObjectMove(0, TFX + "_FIBO_EQUILIBRIUM", 1, starty, (POINT100 + POINTZERO) / 2);
        ObjectMove(0, TFX + "_FIBO_DISCOUNT", 0, starty - PeriodSeconds(), (POINT100 + (POINT100 + POINTZERO) / 2) / 2);
        ObjectMove(0, TFX + "_FIBO_DISCOUNT", 1, starty, (POINT100 + (POINT100 + POINTZERO) / 2) / 2);
        ObjectMove(0, TFX + "_FIBO_PREMIUM", 0, starty - PeriodSeconds(), (POINTZERO + (POINT100 + POINTZERO) / 2) / 2);
        ObjectMove(0, TFX + "_FIBO_PREMIUM", 1, starty, (POINTZERO + (POINT100 + POINTZERO) / 2) / 2);
    }
    ObjectSetInteger(0, TFX + "_FIBO_EQUILIBRIUM", OBJPROP_HIDDEN, true);
    ObjectSetInteger(0, TFX + "_FIBO_PREMIUM", OBJPROP_HIDDEN, true);
    ObjectSetInteger(0, TFX + "_FIBO_DISCOUNT", OBJPROP_HIDDEN, true);
    ObjectSetInteger(0, TFX + "_FIBO_RR_OTE", OBJPROP_HIDDEN, true);
    ObjectSetInteger(0, TFX + "_FIBO_RR_SL", OBJPROP_HIDDEN, true);
    ObjectSetInteger(0, TFX + "_FIBO_RR_TP", OBJPROP_HIDDEN, true);
    ObjectSetInteger(0, TFX + "_FIBO_RR", OBJPROP_HIDDEN, true);
    return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int VEDIPDHL(string SIMBA, int TFX, int VEDIYN)
{
    string CAV = "";
    if(TFX == PERIOD_D1) {
        CAV = "BUTXTD0_YHYL";
    }
    if(TFX == PERIOD_W1) {
        CAV = "BUTXTD0_WHWL";
    }
    if(TFX == PERIOD_MN1) {
        CAV = "BUTXTD0_MHML";
    }
    if(VEDIYN == 1) {
        ObjectSetInteger(0, CAV, OBJPROP_BGCOLOR, clrLightSeaGreen);
        ObjectSetInteger(0, CAV, OBJPROP_STATE, true);
    }
    if(VEDIYN == 0) {
        ObjectSetInteger(0, CAV, OBJPROP_BGCOLOR, clrLightGray);
        ObjectSetInteger(0, CAV, OBJPROP_STATE, false);
    }
    for(int x = 100; x >= 0; x--) {
        int LONGER = PeriodSeconds(TFX);
        string name;
        if(TFX == PERIOD_D1) {
            name = "PD";
            if(TimeDayOfWeek(iTime(SIMBA, TFX, x) + LONGER) > 5) {
                while(TimeDayOfWeek(iTime(SIMBA, TFX, x) + LONGER) != 1) {
                    LONGER = LONGER + PeriodSeconds(PERIOD_D1);
                }
            }
        }
        if(TFX == PERIOD_W1) {
            LONGER = PeriodSeconds(TFX);
            name = "PW";
        }
        if(TFX == PERIOD_MN1) {
            LONGER = PeriodSeconds(TFX);
            if(TimeDay(iTime(SIMBA, TFX, x) + LONGER) < 10) {
                while(TimeDay(iTime(SIMBA, TFX, x) + LONGER) > 1) {
                    LONGER = LONGER - PeriodSeconds(PERIOD_D1);
                }
            }
            if(TimeDay(iTime(SIMBA, TFX, x) + LONGER) > 10) {
                while(TimeDay(iTime(SIMBA, TFX, x) + LONGER) > 10) {
                    LONGER = LONGER + PeriodSeconds(PERIOD_D1);
                }
            }
            name = "PM";
        }
        if(VEDIYN == 0) {
            int totalObjects = ObjectsTotal(0, 0, -1);
            for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
                if(StringSubstr(ObjectName(i), 0, 2) == name) ObjectDelete(ObjectName(i));
            }
            return(0);
        }
        double HIGH = iHigh(SIMBA, TFX, x + 1);
        double HIGHold = iHigh(SIMBA, TFX, x + 2);
        double LOW = iLow(SIMBA, TFX, x + 1);
        double LOWold = iLow(SIMBA, TFX, x + 2);
        ObjectCreate(0, name + "H" + x, OBJ_TREND, 0, 0, 0, 0, 0);
        ObjectSetInteger(0, name + "H" + x, OBJPROP_HIDDEN, true);
        ObjectSetInteger(0, name + "H" + x, OBJPROP_RAY, false);
        ObjectSetInteger(0, name + "H" + x, OBJPROP_COLOR, clrDeepSkyBlue);
        ObjectSetInteger(0, name + "H" + x, OBJPROP_WIDTH, 2);
        ObjectSetInteger(0, name + "H" + x, OBJPROP_STYLE, STYLE_SOLID);
        ObjectMove(0, name + "H" + x, 0, iTime(SIMBA, TFX, x), HIGH);
        ObjectMove(0, name + "H" + x, 1, iTime(SIMBA, TFX, x) + LONGER, HIGH);
        ObjectCreate(0, name + "HH" + x, OBJ_TREND, 0, 0, 0, 0, 0);
        ObjectSetInteger(0, name + "HH" + x, OBJPROP_HIDDEN, true);
        ObjectSetInteger(0, name + "HH" + x, OBJPROP_RAY, false);
        ObjectSetInteger(0, name + "HH" + x, OBJPROP_COLOR, clrDeepSkyBlue);
        ObjectSetInteger(0, name + "HH" + x, OBJPROP_WIDTH, 2);
        ObjectSetInteger(0, name + "HH" + x, OBJPROP_STYLE, STYLE_SOLID);
        ObjectMove(0, name + "HH" + x, 0, iTime(SIMBA, TFX, x), HIGHold);
        ObjectMove(0, name + "HH" + x, 1, iTime(SIMBA, TFX, x), HIGH);
        ObjectCreate(0, name + "L" + x, OBJ_TREND, 0, 0, 0, 0, 0);
        ObjectSetInteger(0, name + "L" + x, OBJPROP_HIDDEN, true);
        ObjectSetInteger(0, name + "L" + x, OBJPROP_RAY, false);
        ObjectSetInteger(0, name + "L" + x, OBJPROP_COLOR, clrSlateBlue);
        ObjectSetInteger(0, name + "L" + x, OBJPROP_WIDTH, 2);
        ObjectSetInteger(0, name + "L" + x, OBJPROP_STYLE, STYLE_SOLID);
        ObjectMove(0, name + "L" + x, 0, iTime(SIMBA, TFX, x), LOW);
        ObjectMove(0, name + "L" + x, 1, iTime(SIMBA, TFX, x) + LONGER, LOW);
        ObjectCreate(0, name + "LL" + x, OBJ_TREND, 0, 0, 0, 0, 0);
        ObjectSetInteger(0, name + "LL" + x, OBJPROP_HIDDEN, true);
        ObjectSetInteger(0, name + "LL" + x, OBJPROP_RAY, false);
        ObjectSetInteger(0, name + "LL" + x, OBJPROP_COLOR, clrSlateBlue);
        ObjectSetInteger(0, name + "LL" + x, OBJPROP_WIDTH, 2);
        ObjectSetInteger(0, name + "LL" + x, OBJPROP_STYLE, STYLE_SOLID);
        ObjectMove(0, name + "LL" + x, 0, iTime(SIMBA, TFX, x), LOWold);
        ObjectMove(0, name + "LL" + x, 1, iTime(SIMBA, TFX, x), LOW);
    }
    return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int VEDIICHI(string SIMBA, int TFX, int VEDIYN)
{
    if(VEDIYN == 0) {
        int totalObjects = ObjectsTotal(0, 0, -1);
        for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
            if(StringSubstr(ObjectName(i), 0, 5) == "CLOUD") ObjectDelete(ObjectName(i));
        }
        return(0);
    }
    for(int x = 1000; x > 0; x--) {
        double SSA = iIchimoku(SIMBA, TFX, 9, 26, 52, MODE_SENKOUSPANA, x);
        double SSB = iIchimoku(SIMBA, TFX, 9, 26, 52, MODE_SENKOUSPANB, x);
        double STOPLOSS = iIchimoku(SIMBA, TFX, 9, 26, 52, MODE_KIJUNSEN, x);
        double SSA0 = iIchimoku(SIMBA, TFX, 9, 26, 52, MODE_SENKOUSPANA, x - 1);
        double SSB0 = iIchimoku(SIMBA, TFX, 9, 26, 52, MODE_SENKOUSPANB, x - 1);
        double STOPLOSS0 = iIchimoku(SIMBA, TFX, 9, 26, 52, MODE_KIJUNSEN, x - 1);
        ObjectCreate(0, "CLOUDSSA" + x, OBJ_TREND, 0, 0, 0, 0, 0);
        ObjectSetInteger(0, "CLOUDSSA" + x, OBJPROP_HIDDEN, true);
        ObjectSetInteger(0, "CLOUDSSA" + x, OBJPROP_RAY, false);
        ObjectSetInteger(0, "CLOUDSSA" + x, OBJPROP_COLOR, clrLime);
        ObjectMove(0, "CLOUDSSA" + x, 0, iTime(SIMBA, TFX, x), SSA);
        ObjectMove(0, "CLOUDSSA" + x, 1, iTime(SIMBA, TFX, x - 1), SSA0);
        ObjectCreate(0, "CLOUDSSB" + x, OBJ_TREND, 0, 0, 0, 0, 0);
        ObjectSetInteger(0, "CLOUDSSB" + x, OBJPROP_HIDDEN, true);
        ObjectSetInteger(0, "CLOUDSSB" + x, OBJPROP_RAY, false);
        ObjectSetInteger(0, "CLOUDSSB" + x, OBJPROP_COLOR, clrRed);
        ObjectMove(0, "CLOUDSSB" + x, 0, iTime(SIMBA, TFX, x), SSB);
        ObjectMove(0, "CLOUDSSB" + x, 1, iTime(SIMBA, TFX, x - 1), SSB0);
        ObjectCreate(0, "CLOUDSTOP" + x, OBJ_TREND, 0, 0, 0, 0, 0);
        ObjectSetInteger(0, "CLOUDSTOP" + x, OBJPROP_HIDDEN, true);
        ObjectSetInteger(0, "CLOUDSTOP" + x, OBJPROP_RAY, false);
        ObjectSetInteger(0, "CLOUDSTOP" + x, OBJPROP_STYLE, STYLE_DOT);
        ObjectSetInteger(0, "CLOUDSTOP" + x, OBJPROP_COLOR, clrYellow);
        ObjectMove(0, "CLOUDSTOP" + x, 0, iTime(SIMBA, TFX, x), STOPLOSS);
        ObjectMove(0, "CLOUDSTOP" + x, 1, iTime(SIMBA, TFX, x - 1), STOPLOSS0);
    }
    return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SESSIONfunct(string SIM, int Gshift, int SESS)
{
    if(SESSION == 1) ObjectSetInteger(0, "BUTXTD0_SESS", OBJPROP_BGCOLOR, clrLightSeaGreen);
    else ObjectSetInteger(0, "BUTXTD0_SESS", OBJPROP_BGCOLOR, clrLightGray);
    if(SESSION == 0) return(0);
//    Market Open: 0600
//London Open Kill Zone: 0800 - 1100
//NY Kill Zone: 1300 - 1500
//London Close Kill Zone: 1600 - 1800
    Gshift = 60 * Gshift;
    int START = 0;
    int ASIAop = Gshift / 5 * 60;
    int ASIAcl = ASIAop * 9;
    int LONDop = Gshift / 5 * 60 * 8;
    int LONDcl = LONDop + Gshift / 5 * 60 * 9;
    int USop = Gshift / 5 * 60 * 13;
    int UScl = USop + Gshift / 5 * 60 * 9;
    for(int i = 0 + iBarShift(SIM, 1440, iTime(SIM, GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE"))); i <= (iBarShift(SIM, 1440, iTime(SIM, GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")))) + 15; i++) {
        if(SESS == 1) ObjectCreate(0, "SESSMOH" + i, OBJ_VLINE, 0, 0, 0);
        if(SESS == 1)  ObjectCreate(0, "SESSMO" + i, OBJ_TREND, 0, 0, 0, 0, 0);
        if(SESS == 2)  ObjectCreate(0, "SESSASIA" + i, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
        if(SESS == 2)  ObjectCreate(0, "SESSLONDON" + i, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
        if(SESS == 2)  ObjectCreate(0, "SESSUSA" + i, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
        if(SESS == 1)   ObjectCreate(0, "SESSLOKZu" + i, OBJ_TREND, 0, 0, 0, 0, 0);
        if(SESS == 1)   ObjectCreate(0, "SESSLOKZd" + i, OBJ_TREND, 0, 0, 0, 0, 0);
        if(SESS == 1)   ObjectCreate(0, "SESSNYKZu" + i, OBJ_TREND, 0, 0, 0, 0, 0);
        if(SESS == 1)   ObjectCreate(0, "SESSNYKZd" + i, OBJ_TREND, 0, 0, 0, 0, 0);
        if(SESS == 1) ObjectCreate(0, "SESSLCKZu" + i, OBJ_TREND, 0, 0, 0, 0, 0);
        if(SESS == 1) ObjectCreate(0, "SESSLCKZd" + i, OBJ_TREND, 0, 0, 0, 0, 0);
        if(iTime(SIM, PERIOD_H1, 0) > iTime(SIM, 1440, i)) {
            int MAXHIGH_ASIA = iHighest(SIM, PERIOD_H1, MODE_HIGH, (iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i)) - iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + ASIAcl)), iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + ASIAcl));
            int MINLOW_ASIA = iLowest(SIM, PERIOD_H1, MODE_LOW, (iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i)) - iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + ASIAcl)), iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + ASIAcl));
            ObjectMove(0, "SESSASIA" + i, 0, iTime(SIM, 1440, i), iHigh(SIM, PERIOD_H1, MAXHIGH_ASIA));
            ObjectMove(0, "SESSASIA" + i, 1, iTime(SIM, 1440, i) + ASIAcl, iLow(SIM, PERIOD_H1, MINLOW_ASIA));
            ObjectSetInteger(SIM, "SESSASIA" + i, OBJPROP_BACK, false);
            ObjectSetInteger(SIM, "SESSASIA" + i, OBJPROP_COLOR, clrThistle);
            ObjectSetInteger(SIM, "SESSASIA" + i, OBJPROP_WIDTH, 1);
            CREATETEXTPRICEprice("SESSASIAH" + i, "Asia high", (int)ObjectGetInteger(0, "SESSASIA" + i, OBJPROP_TIME), ObjectGetDouble(0, "SESSASIA" + i, OBJPROP_PRICE1), clrThistle, ANCHOR_LEFT_LOWER);
            CREATETEXTPRICEprice("SESSASIAL" + i, "Asia low", (int)ObjectGetInteger(0, "SESSASIA" + i, OBJPROP_TIME), ObjectGetDouble(0, "SESSASIA" + i, OBJPROP_PRICE2), clrThistle, ANCHOR_LEFT_UPPER);
        }
        if(iTime(SIM, PERIOD_H1, 0) > iTime(SIM, 1440, i) + LONDop) {
            int MAXHIGH_LON = iHighest(SIM, PERIOD_H1, MODE_HIGH, (iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + LONDop) - iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + LONDcl)) + 1, iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + LONDcl));
            int MINLOW_LON = iLowest(SIM, PERIOD_H1, MODE_LOW, (iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + LONDop) - iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + LONDcl)) + 1, iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + LONDcl));
            ObjectMove(0, "SESSLONDON" + i, 0, iTime(SIM, 1440, i) + LONDop, iHigh(SIM, PERIOD_H1, MAXHIGH_LON));
            ObjectMove(0, "SESSLONDON" + i, 1, iTime(SIM, 1440, i) + LONDcl, iLow(SIM, PERIOD_H1, MINLOW_LON));
            ObjectSetInteger(SIM, "SESSLONDON" + i, OBJPROP_BACK, false);
            ObjectSetInteger(SIM, "SESSLONDON" + i, OBJPROP_COLOR, clrYellow);
            ObjectSetInteger(SIM, "SESSLONDON" + i, OBJPROP_WIDTH, 1);
            CREATETEXTPRICEprice("SESSLONDONH" + i, "London high", (int)ObjectGetInteger(0, "SESSLONDON" + i, OBJPROP_TIME), ObjectGetDouble(0, "SESSLONDON" + i, OBJPROP_PRICE1), clrYellow, ANCHOR_LEFT_LOWER);
            CREATETEXTPRICEprice("SESSLONDONL" + i, "London low", (int)ObjectGetInteger(0, "SESSLONDON" + i, OBJPROP_TIME), ObjectGetDouble(0, "SESSLONDON" + i, OBJPROP_PRICE2), clrYellow, ANCHOR_LEFT_UPPER);
        }
        if(iTime(SIM, PERIOD_H1, 0) > iTime(SIM, 1440, i) + USop) {
            int MAXHIGH_USA = iHighest(SIM, PERIOD_H1, MODE_HIGH, (iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + USop) - iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + UScl)) + 1, iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + UScl));
            int MINLOW_USA = iLowest(SIM, PERIOD_H1, MODE_LOW, (iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + USop) - iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + UScl)) + 1, iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + UScl));
            ObjectMove(0, "SESSUSA" + i, 0, iTime(SIM, 1440, i) + USop, iHigh(SIM, PERIOD_H1, MAXHIGH_USA));
            ObjectMove(0, "SESSUSA" + i, 1, iTime(SIM, 1440, i) + UScl, iLow(SIM, PERIOD_H1, MINLOW_USA));
            ObjectSetInteger(SIM, "SESSUSA" + i, OBJPROP_BACK, false);
            ObjectSetInteger(SIM, "SESSUSA" + i, OBJPROP_COLOR, clrSkyBlue);
            ObjectSetInteger(SIM, "SESSUSA" + i, OBJPROP_WIDTH, 1);
            CREATETEXTPRICEprice("SESSUSAH" + i, "USA high", (int)ObjectGetInteger(0, "SESSUSA" + i, OBJPROP_TIME), ObjectGetDouble(0, "SESSUSA" + i, OBJPROP_PRICE1), clrSkyBlue, ANCHOR_LEFT_LOWER);
            CREATETEXTPRICEprice("SESSUSAL" + i, "USA low", (int)ObjectGetInteger(0, "SESSUSA" + i, OBJPROP_TIME), ObjectGetDouble(0, "SESSUSA" + i, OBJPROP_PRICE2), clrSkyBlue, ANCHOR_LEFT_UPPER);
        }
        ObjectMove(SIM, "SESSMOH" + i, 0, iTime(SIM, 1440, i) + 60 * Gshift / 5 * 7, 0);
        ObjectSetInteger(SIM, "SESSMOH" + i, OBJPROP_COLOR, Col_NY_OPEN);
        ObjectSetInteger(SIM, "SESSMOH" + i, OBJPROP_STYLE, STYLE_DOT);
        ObjectSetInteger(SIM, "SESSMOH" + i, OBJPROP_WIDTH, 1);
        ObjectCreate(0, "SESSMOHtext" + i, OBJ_TEXT, 0, (int)ObjectGetInteger(0, "SESSMOH" + i, OBJPROP_TIME1), iHigh(SIM, PERIOD_H1, iHighest(SIM, PERIOD_H1, MODE_HIGH, iBarShift(SIM, 60, iTime(SIM, 1440, i)) -
                     iBarShift(SIM, 60, iTime(SIM, 1440, i) + 60 * Gshift / 5 * 7), iBarShift(SIM, 60, iTime(SIM, 1440, i) + 60 * Gshift / 5 * 7))));
        ObjectSetString(0, "SESSMOHtext" + i, OBJPROP_TEXT, "NY 0000");
        ObjectSetDouble(0, "SESSMOHtext" + i, OBJPROP_ANGLE, 90);
        ObjectSetInteger(0, "SESSMOHtext" + i, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
        ObjectSetInteger(0, "SESSMOHtext" + i, OBJPROP_COLOR, Col_NY_OPEN);
        ObjectSetInteger(0, "SESSMOHtext" + i, OBJPROP_FONTSIZE, FONT_SIZE);
        ObjectMove(SIM, "SESSMO" + i, 0, iTime(SIM, 1440, i) + 60 * Gshift / 5 * 7, iOpen(SIM, PERIOD_H1, iBarShift(SIM, 60, iTime(SIM, 1440, i) + 60 * Gshift / 5 * 7)));
        ObjectMove(SIM, "SESSMO" + i, 1, iTime(SIM, 1440, i) + 60 * 1440 + 60 * Gshift / 5 * 7, iOpen(SIM, PERIOD_H1, iBarShift(SIM, 60, iTime(SIM, 1440, i) + 60 * Gshift / 5 * 7)));
        ObjectSetInteger(SIM, "SESSMO" + i, OBJPROP_RAY, false);
        ObjectSetInteger(SIM, "SESSMO" + i, OBJPROP_COLOR, Col_NY_OPEN);
        ObjectSetInteger(SIM, "SESSMO" + i, OBJPROP_WIDTH, 1);
        int LOKZs = Gshift + 60 * 60 * 4;
        int LOKZe = LOKZs + 60 * 60 * 3;
        int MAXHIGH_LOKZ = iHighest(SIM, PERIOD_H1, MODE_HIGH, iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + LOKZs) - iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + LOKZe) + 1, iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + LOKZe));
        int MINLOW_LOKZ = iLowest(SIM, PERIOD_H1, MODE_LOW, iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + LOKZs) - iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + LOKZe) + 1, iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + LOKZe));
        if(HIGH_LOW_KILLZONE == false) {
            ObjectMove(SIM, "SESSLOKZu" + i, 0, iTime(SIM, 1440, i) + 60 * Gshift + LOKZs, iHigh(SIM, 1440, i));
            ObjectMove(SIM, "SESSLOKZu" + i, 1, iTime(SIM, 1440, i) + 60 * Gshift + LOKZe, iHigh(SIM, 1440, i));
        }
        else {
            ObjectMove(SIM, "SESSLOKZu" + i, 0, iTime(SIM, 1440, i) + 60 * Gshift + LOKZs, iHigh(SIM, PERIOD_H1, MAXHIGH_LOKZ));
            ObjectMove(SIM, "SESSLOKZu" + i, 1, iTime(SIM, 1440, i) + 60 * Gshift + LOKZe, iHigh(SIM, PERIOD_H1, MAXHIGH_LOKZ));
        }
        ObjectSetInteger(SIM, "SESSLOKZu" + i, OBJPROP_RAY, false);
        ObjectSetInteger(SIM, "SESSLOKZu" + i, OBJPROP_COLOR, clrOrange);
        ObjectSetInteger(SIM, "SESSLOKZu" + i, OBJPROP_WIDTH, 2);
        if(HIGH_LOW_KILLZONE == false) {
            ObjectMove(SIM, "SESSLOKZd" + i, 0, iTime(SIM, 1440, i) + 60 * Gshift + LOKZs, iLow(SIM, 1440, i));
            ObjectMove(SIM, "SESSLOKZd" + i, 1, iTime(SIM, 1440, i) + 60 * Gshift + LOKZe, iLow(SIM, 1440, i));
        }
        else {
            ObjectMove(SIM, "SESSLOKZd" + i, 0, iTime(SIM, 1440, i) + 60 * Gshift + LOKZs, iLow(SIM, PERIOD_H1, MINLOW_LOKZ));
            ObjectMove(SIM, "SESSLOKZd" + i, 1, iTime(SIM, 1440, i) + 60 * Gshift + LOKZe, iLow(SIM, PERIOD_H1, MINLOW_LOKZ));
        }
        ObjectSetInteger(SIM, "SESSLOKZd" + i, OBJPROP_RAY, false);
        ObjectSetInteger(SIM, "SESSLOKZd" + i, OBJPROP_COLOR, clrOrange);
        ObjectSetInteger(SIM, "SESSLOKZd" + i, OBJPROP_WIDTH, 2);
        int NYKZs = Gshift + 60 * 60 * 9;
        int NYKZe = NYKZs + 60 * 60 * 2;
        int MAXHIGH_NYKZ = iHighest(SIM, PERIOD_H1, MODE_HIGH, iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + NYKZs) - iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + NYKZe) + 1, iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + NYKZe));
        int MINLOW_NYKZ = iLowest(SIM, PERIOD_H1, MODE_LOW, iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + NYKZs) - iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + NYKZe) + 1, iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + NYKZe));
        if(HIGH_LOW_KILLZONE == false) {
            ObjectMove(SIM, "SESSNYKZu" + i, 0, iTime(SIM, 1440, i) + 60 * Gshift + NYKZs, iHigh(SIM, 1440, i));
            ObjectMove(SIM, "SESSNYKZu" + i, 1, iTime(SIM, 1440, i) + 60 * Gshift + NYKZe, iHigh(SIM, 1440, i));
        }
        else {
            ObjectMove(SIM, "SESSNYKZu" + i, 0, iTime(SIM, 1440, i) + 60 * Gshift + NYKZs, iHigh(SIM, PERIOD_H1, MAXHIGH_NYKZ));
            ObjectMove(SIM, "SESSNYKZu" + i, 1, iTime(SIM, 1440, i) + 60 * Gshift + NYKZe, iHigh(SIM, PERIOD_H1, MAXHIGH_NYKZ));
        }
        ObjectSetInteger(SIM, "SESSNYKZu" + i, OBJPROP_RAY, false);
        ObjectSetInteger(SIM, "SESSNYKZu" + i, OBJPROP_COLOR, clrGreen);
        ObjectSetInteger(SIM, "SESSNYKZu" + i, OBJPROP_WIDTH, 2);
        if(HIGH_LOW_KILLZONE == false) {
            ObjectMove(SIM, "SESSNYKZd" + i, 0, iTime(SIM, 1440, i) + 60 * Gshift + NYKZs, iLow(SIM, 1440, i));
            ObjectMove(SIM, "SESSNYKZd" + i, 1, iTime(SIM, 1440, i) + 60 * Gshift + NYKZe, iLow(SIM, 1440, i));
        }
        else {
            ObjectMove(SIM, "SESSNYKZd" + i, 0, iTime(SIM, 1440, i) + 60 * Gshift + NYKZs, iLow(SIM, PERIOD_H1, MINLOW_NYKZ));
            ObjectMove(SIM, "SESSNYKZd" + i, 1, iTime(SIM, 1440, i) + 60 * Gshift + NYKZe, iLow(SIM, PERIOD_H1, MINLOW_NYKZ));
        }
        ObjectSetInteger(SIM, "SESSNYKZd" + i, OBJPROP_RAY, false);
        ObjectSetInteger(SIM, "SESSNYKZd" + i, OBJPROP_COLOR, clrGreen);
        ObjectSetInteger(SIM, "SESSNYKZd" + i, OBJPROP_WIDTH, 2);
        int LCKZs = Gshift + 60 * 60 * 12;
        int LCKZe = LCKZs + 60 * 60 * 2;
        int MAXHIGH_LCKZ = iHighest(SIM, PERIOD_H1, MODE_HIGH, iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + LCKZs) - iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + LCKZe) + 1, iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + LCKZe));
        int MINLOW_LCKZ = iLowest(SIM, PERIOD_H1, MODE_LOW, iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + LCKZs) - iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + LCKZe) + 1, iBarShift(SIM, PERIOD_H1, iTime(SIM, 1440, i) + 60 * Gshift + LCKZe));
        if(HIGH_LOW_KILLZONE == false) {
            ObjectMove(SIM, "SESSLCKZu" + i, 0, iTime(SIM, 1440, i) + 60 * Gshift + LCKZs, iHigh(SIM, 1440, i));
            ObjectMove(SIM, "SESSLCKZu" + i, 1, iTime(SIM, 1440, i) + 60 * Gshift + LCKZe, iHigh(SIM, 1440, i));
        }
        else {
            ObjectMove(SIM, "SESSLCKZu" + i, 0, iTime(SIM, 1440, i) + 60 * Gshift + LCKZs, iHigh(SIM, PERIOD_H1, MAXHIGH_LCKZ));
            ObjectMove(SIM, "SESSLCKZu" + i, 1, iTime(SIM, 1440, i) + 60 * Gshift + LCKZe, iHigh(SIM, PERIOD_H1, MAXHIGH_LCKZ));
        }
        ObjectSetInteger(SIM, "SESSLCKZu" + i, OBJPROP_RAY, false);
        ObjectSetInteger(SIM, "SESSLCKZu" + i, OBJPROP_COLOR, clrBlue);
        ObjectSetInteger(SIM, "SESSLCKZu" + i, OBJPROP_WIDTH, 2);
        if(HIGH_LOW_KILLZONE == false) {
            ObjectMove(SIM, "SESSLCKZd" + i, 0, iTime(SIM, 1440, i) + 60 * Gshift + LCKZs, iLow(SIM, 1440, i));
            ObjectMove(SIM, "SESSLCKZd" + i, 1, iTime(SIM, 1440, i) + 60 * Gshift + LCKZe, iLow(SIM, 1440, i));
        }
        else {
            ObjectMove(SIM, "SESSLCKZd" + i, 0, iTime(SIM, 1440, i) + 60 * Gshift + LCKZs, iLow(SIM, PERIOD_H1, MINLOW_LCKZ));
            ObjectMove(SIM, "SESSLCKZd" + i, 1, iTime(SIM, 1440, i) + 60 * Gshift + LCKZe, iLow(SIM, PERIOD_H1, MINLOW_LCKZ));
        }
        ObjectSetInteger(SIM, "SESSLCKZd" + i, OBJPROP_RAY, false);
        ObjectSetInteger(SIM, "SESSLCKZd" + i, OBJPROP_COLOR, clrBlue);
        ObjectSetInteger(SIM, "SESSLCKZd" + i, OBJPROP_WIDTH, 2);
    }
    return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int FVGfunc(int FVGshow, string SIMBA, int TF, int CURRCANDX)
{
    int totalObjects = ObjectsTotal(0, 0, -1);
    for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
        if(StringSubstr(ObjectName(i), StringLen(TF), 3) == "FVG" && TF == StringSubstr(ObjectName(i), 0, StringLen(TF))) ObjectDelete(ObjectName(i));
    }
    if(FVGshow == 0) return(0);
    double FVG[];
    double FVGnat[];
    double HH[];
    double LL[];
    double FLO[];
    switch(TF) {
    case 1:
        ArrayCopy(FVG, M1FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, M1FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, M1HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, M1LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLO, M1FLOW, 0, 0, WHOLE_ARRAY);
        break;
    case 5:
        ArrayCopy(FVG, M5FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, M5FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, M5HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, M5LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLO, M5FLOW, 0, 0, WHOLE_ARRAY);
        break;
    case 15:
        ArrayCopy(FVG, M15FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, M15FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, M15HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, M15LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLO, M15FLOW, 0, 0, WHOLE_ARRAY);
        break;
    case 30:
        ArrayCopy(FVG, M30FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, M30FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, M30HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, M30LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLO, M30FLOW, 0, 0, WHOLE_ARRAY);
        break;
    case 60:
        ArrayCopy(FVG, H1FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, H1FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, H1HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, H1LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLO, H1FLOW, 0, 0, WHOLE_ARRAY);
        break;
    case 240:
        ArrayCopy(FVG, H4FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, H4FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, H4HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, H4LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLO, H4FLOW, 0, 0, WHOLE_ARRAY);
        break;
    case 1440:
        ArrayCopy(FVG, D1FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, D1FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, D1HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, D1LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLO, D1FLOW, 0, 0, WHOLE_ARRAY);
        break;
    case PERIOD_W1:
        ArrayCopy(FVG, W1FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, W1FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, W1HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, W1LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLO, W1FLOW, 0, 0, WHOLE_ARRAY);
        break;
    case PERIOD_MN1:
        ArrayCopy(FVG, MN1FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, MN1FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, MN1HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, MN1LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLO, MN1FLOW, 0, 0, WHOLE_ARRAY);
        break;
    }
    if(FVGshow == 1) {
        double FVGstop[];
        ArrayResize(FVGstop, ArraySize(FVG));
        double FVGstopfull[];
        ArrayResize(FVGstopfull, ArraySize(FVG));
        for(int U = 0; U < ArraySize(FVG); U++) {
            if(FVGnat[U] == 1) {
                if(FVGstop[U] == 0) FVGstop[U] = FVG[U] + 1;
                for(int k = (iBars(SIMBA, TF) - FVG[U]) - 2; k >= CURRCANDX; k--) {
                    if(iLow(SIMBA, TF, k) <= iLow(SIMBA, TF, (iBars(SIMBA, TF) - FVG[U]) - 1) && iLow(SIMBA, TF, k) < iLow(SIMBA, TF, iBars(SIMBA, TF) - FVGstop[U])) {
                        FVGstop[U] = iBars(SIMBA, TF) - k;
                    }
                    if(iLow(SIMBA, TF, k) <= iHigh(SIMBA, TF, (iBars(SIMBA, TF) - FVG[U]) + 1)) {
                        FVGstop[U] = iBars(SIMBA, TF) - k;
                        FVGstopfull[U] = 1;
                        break;
                    }
                }
            }
            if(FVGnat[U] == 2) {
                if(FVGstop[U] == 0) FVGstop[U] = FVG[U] + 1;
                for(int k = (iBars(SIMBA, TF) - FVG[U]) - 2; k >= CURRCANDX; k--) {
                    if(iHigh(SIMBA, TF, k) >= iHigh(SIMBA, TF, (iBars(SIMBA, TF) - FVG[U]) - 1) && iHigh(SIMBA, TF, k) > iHigh(SIMBA, TF, iBars(SIMBA, TF) - FVGstop[U])) {
                        FVGstop[U] = iBars(SIMBA, TF) - k;
                    }
                    if(iHigh(SIMBA, TF, k) >= iLow(SIMBA, TF, (iBars(SIMBA, TF) - FVG[U]) + 1)) {
                        FVGstop[U] = iBars(SIMBA, TF) - k;
                        FVGstopfull[U] = 1;
                        break;
                    }
                }
            }
        }
        double OBIM[];
        ArrayResize(OBIM, ArraySize(FVG));
        double OBIMbreak[];
        ArrayResize(OBIMbreak, ArraySize(FVG));
        double OBIMnat[];
        ArrayResize(OBIMnat, ArraySize(FVG));
        for(int v = ArraySize(FVG) - 1; v > 1; v--) {
            if(FVGnat[v] == 1) {
                int STOP;
                for(int z = v - 1; z > 1; z--) {
                    if(FVGnat[z] == FVGnat[v]) {
                        STOP = z;
                        break;
                    }
                }
                for(int x = iBars(SIMBA, TF) - FVG[v]; x < iBars(SIMBA, TF) - FVG[STOP]; x++) {
                    if(iClose(SIMBA, TF, x) < iOpen(SIMBA, TF, x) && iClose(SIMBA, TF, iBars(SIMBA, TF) - FVG[v]) > iHigh(SIMBA, TF, x)) {
                        OBIM[v] = iBars(SIMBA, TF) - x;
                        OBIMnat[v] = 1;
                        for(int g = x; g > CURRCANDX; g--) {
                            if(iClose(SIMBA, TF, g) > iHigh(SIMBA, TF, x)) {
                                OBIMbreak[v] = iBars(SIMBA, TF) - g;
                                break;
                            }
                        }
                        break;
                    }
                }
            }
            if(FVGnat[v] == 2) {
                int STOP;
                for(int z = v - 1; z > 1; z--) {
                    if(FVGnat[z] == FVGnat[v]) {
                        STOP = z;
                        break;
                    }
                }
                for(int x = iBars(SIMBA, TF) - FVG[v]; x < iBars(SIMBA, TF) - FVG[STOP]; x++) {
                    if(iClose(SIMBA, TF, x) > iOpen(SIMBA, TF, x) && iClose(SIMBA, TF, iBars(SIMBA, TF) - FVG[v]) < iLow(SIMBA, TF, x)) {
                        OBIM[v] = iBars(SIMBA, TF) - x;
                        OBIMnat[v] = 2;
                        for(int g = x; g > CURRCANDX; g--) {
                            if(iClose(SIMBA, TF, g) < iLow(SIMBA, TF, x)) {
                                OBIMbreak[v] = iBars(SIMBA, TF) - g;
                                break;
                            }
                        }
                        break;
                    }
                }
            }
        }
        double OBIMstop[];
        ArrayResize(OBIMstop, ArraySize(FVG));
        for(int U = 0; U < ArraySize(OBIM); U++) {
            if(OBIMnat[U] == 1) {
                for(int k = (iBars(SIMBA, TF) - OBIM[U]) - 1; k > CURRCANDX; k--) {
                    if(iClose(SIMBA, TF, k) <= iLow(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, 1 + (OBIMbreak[U] - OBIM[U]), (iBars(SIMBA, TF) - OBIMbreak[U])))) {
                        OBIMstop[U] = iBars(SIMBA, TF) - k;
                        break;
                    }
                }
            }
            if(OBIMnat[U] == 2) {
                for(int k = (iBars(SIMBA, TF) - OBIM[U]) - 1; k > CURRCANDX; k--) {
                    if(iClose(SIMBA, TF, k) >= iHigh(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, 1 + (OBIMbreak[U] - OBIM[U]), (iBars(SIMBA, TF) - OBIMbreak[U])))) {
                        OBIMstop[U] = iBars(SIMBA, TF) - k;
                        break;
                    }
                }
            }
        }
        int downfind = 0;
        int upfind = 0;
        for(int f = ArraySize(FLO) - 1; f > 0; f--) {
            for(int v = ArraySize(FVG) - 1; v > 0; v--) {
                int ok = 0;
                if(FLO[f] == 1 && FVG[v] < LL[f]) continue;
                if(FLO[f] == 2 && FVG[v] < HH[f]) continue;
                if(FLO[f] == 1 && FVG[v] >= LL[f]) ok = 1;
                if(FLO[f] == 2 && FVG[v] >= HH[f]) ok = 1;
                if(ok == 0) break;
                datetime stop = iTime(SIMBA, TF, iBars(SIMBA, TF) - FVGstop[v]);
                if(FVGstopfull[v] == 0) stop = iTime(SIMBA, 0, CURRCANDX) + PeriodSeconds();
                datetime stopobim = iTime(SIMBA, TF, iBars(SIMBA, TF) - OBIMstop[v]);
                if(OBIMstop[v] == 0) stopobim = iTime(SIMBA, 0, CURRCANDX) + PeriodSeconds();
                if(((OBIMnat[v] != 0 && OBIMstop[v] == 0) || (OBIMnat[v] == 0 && FVGstopfull[v] == 0))) {
                    if(LAST_FLOW == 1 && FVGnat[v] == 1 && OBIMnat[v] != 0 && downfind == 0) {
                        ObjectCreate(0, TF + "FVG" + v, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                        ObjectMove(0, TF + "FVG" + v, 0, iTime(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1), iHigh(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1));
                        ObjectMove(0, TF + "FVG" + v, 1, stop, iLow(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) - 1));
                        ObjectSetInteger(0, TF + "FVG" + v, OBJPROP_BACK, false);
                        ObjectSetInteger(0, TF + "FVG" + v, OBJPROP_COLOR, clrLightGreen);
                        ObjectSetInteger(0, TF + "FVG" + v, OBJPROP_STYLE, STYLE_DOT);
                        ObjectCreate(0, TF + "FVGfill" + v, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                        ObjectMove(0, TF + "FVGfill" + v, 0, iTime(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1), iHigh(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1));
                        ObjectMove(0, TF + "FVGfill" + v, 1, stop, iLow(SIMBA, TF, (iBars(SIMBA, TF) - FVGstop[v])));
                        ObjectSetInteger(0, TF + "FVGfill" + v, OBJPROP_BACK, true);
                        ObjectSetInteger(0, TF + "FVGfill" + v, OBJPROP_COLOR, clrLightGreen);
                        if(DASHBOARD == false) CREATETEXTPRICEprice(TF + "FVGfilltext" + v, tftransformation(TF) + " FVG+", stop, MathMax(iHigh(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1), iLow(SIMBA, TF, (iBars(SIMBA, TF) - FVGstop[v]))), clrWhite, ANCHOR_LEFT_UPPER);
                        if(OBIMnat[v] == 1) {
                            ObjectCreate(0, TF + "FVGOBIM" + v, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                            ObjectMove(0, TF + "FVGOBIM" + v, 0, iTime(SIMBA, TF, (iBars(SIMBA, TF) - OBIM[v])), iLow(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, 1 + (OBIMbreak[v] - OBIM[v]), (iBars(SIMBA, TF) - OBIMbreak[v]))));
                            ObjectMove(0, TF + "FVGOBIM" + v, 1, stopobim, iHigh(SIMBA, TF, iBars(SIMBA, TF) - OBIM[v]));
                            ObjectSetInteger(0, TF + "FVGOBIM" + v, OBJPROP_COLOR, clrLightGreen);
                            ObjectSetInteger(0, TF + "FVGOBIM" + v, OBJPROP_BACK, false);
                            ObjectSetInteger(0, TF + "FVGOBIM" + v, OBJPROP_STYLE, STYLE_SOLID);
                        }
                        if(OBIMstop[v] == 0 && FVGstopfull[v] == 0) downfind = 1;
                    }
                    if(LAST_FLOW == 1 && FVGnat[v] == 2 && OBIMnat[v] != 0 && upfind == 0) {
                        ObjectCreate(0, TF + "FVG" + v, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                        ObjectMove(0, TF + "FVG" + v, 0, iTime(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1), iLow(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1));
                        ObjectMove(0, TF + "FVG" + v, 1, stop, iHigh(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) - 1));
                        ObjectSetInteger(0, TF + "FVG" + v, OBJPROP_BACK, false);
                        ObjectSetInteger(0, TF + "FVG" + v, OBJPROP_COLOR, clrLightSalmon);
                        ObjectSetInteger(0, TF + "FVG" + v, OBJPROP_STYLE, STYLE_DOT);
                        ObjectCreate(0, TF + "FVGfill" + v, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                        ObjectMove(0, TF + "FVGfill" + v, 0, iTime(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1), iLow(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1));
                        ObjectMove(0, TF + "FVGfill" + v, 1, stop, iHigh(SIMBA, TF, (iBars(SIMBA, TF) - FVGstop[v])));
                        ObjectSetInteger(0, TF + "FVGfill" + v, OBJPROP_BACK, true);
                        ObjectSetInteger(0, TF + "FVGfill" + v, OBJPROP_COLOR, clrLightSalmon);
                        if(DASHBOARD == false) CREATETEXTPRICEprice(TF + "FVGfilltext" + v, tftransformation(TF) + " FVG-", stop, MathMin(iLow(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1), iHigh(SIMBA, TF, (iBars(SIMBA, TF) - FVGstop[v]))), clrWhite, ANCHOR_LEFT_LOWER);
                        if(OBIMnat[v] == 2) {
                            ObjectCreate(0, TF + "FVGOBIM" + v, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                            ObjectMove(0, TF + "FVGOBIM" + v, 0, iTime(SIMBA, TF, (iBars(SIMBA, TF) - OBIM[v])), iHigh(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, 1 + (OBIMbreak[v] - OBIM[v]), (iBars(SIMBA, TF) - OBIMbreak[v]))));
                            ObjectMove(0, TF + "FVGOBIM" + v, 1, stopobim, iLow(SIMBA, TF, iBars(SIMBA, TF) - OBIM[v]));
                            ObjectSetInteger(0, TF + "FVGOBIM" + v, OBJPROP_COLOR, clrLightSalmon);
                            ObjectSetInteger(0, TF + "FVGOBIM" + v, OBJPROP_BACK, false);
                            ObjectSetInteger(0, TF + "FVGOBIM" + v, OBJPROP_STYLE, STYLE_SOLID);
                        }
                        if(OBIMstop[v] == 0 && FVGstopfull[v] == 0) upfind = 1;
                    }
                    if(LAST_FLOW == 2 && FVGnat[v] == 1 && OBIMnat[v] != 0 && downfind == 0) {
                        ObjectCreate(0, TF + "FVG" + v, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                        ObjectMove(0, TF + "FVG" + v, 0, iTime(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1), iHigh(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1));
                        ObjectMove(0, TF + "FVG" + v, 1, stop, iLow(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) - 1));
                        ObjectSetInteger(0, TF + "FVG" + v, OBJPROP_BACK, false);
                        ObjectSetInteger(0, TF + "FVG" + v, OBJPROP_COLOR, clrLightGreen);
                        ObjectSetInteger(0, TF + "FVG" + v, OBJPROP_STYLE, STYLE_DOT);
                        ObjectCreate(0, TF + "FVGfill" + v, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                        ObjectMove(0, TF + "FVGfill" + v, 0, iTime(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1), iHigh(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1));
                        ObjectMove(0, TF + "FVGfill" + v, 1, stop, iLow(SIMBA, TF, (iBars(SIMBA, TF) - FVGstop[v])));
                        ObjectSetInteger(0, TF + "FVGfill" + v, OBJPROP_BACK, true);
                        ObjectSetInteger(0, TF + "FVGfill" + v, OBJPROP_COLOR, clrLightGreen);
                        if(DASHBOARD == false) CREATETEXTPRICEprice(TF + "FVGfilltext" + v, tftransformation(TF) + " FVG+", stop, MathMax(iHigh(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1), iLow(SIMBA, TF, (iBars(SIMBA, TF) - FVGstop[v]))), clrWhite, ANCHOR_LEFT_LOWER);
                        if(OBIMnat[v] == 1) {
                            ObjectCreate(0, TF + "FVGOBIM" + v, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                            ObjectMove(0, TF + "FVGOBIM" + v, 0, iTime(SIMBA, TF, (iBars(SIMBA, TF) - OBIM[v])), iLow(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, 1 + (OBIMbreak[v] - OBIM[v]), (iBars(SIMBA, TF) - OBIMbreak[v]))));
                            ObjectMove(0, TF + "FVGOBIM" + v, 1, stopobim, iHigh(SIMBA, TF, iBars(SIMBA, TF) - OBIM[v]));
                            ObjectSetInteger(0, TF + "FVGOBIM" + v, OBJPROP_COLOR, clrLightGreen);
                            ObjectSetInteger(0, TF + "FVGOBIM" + v, OBJPROP_BACK, false);
                            ObjectSetInteger(0, TF + "FVGOBIM" + v, OBJPROP_STYLE, STYLE_SOLID);
                            if(OBIMstop[v] == 0 && FVGstopfull[v] == 0) downfind = 1;
                        }
                    }
                    if(LAST_FLOW == 2 && FVGnat[v] == 2 && OBIMnat[v] != 0 && upfind == 0) {
                        ObjectCreate(0, TF + "FVG" + v, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                        ObjectMove(0, TF + "FVG" + v, 0, iTime(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1), iLow(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1));
                        ObjectMove(0, TF + "FVG" + v, 1, stop, iHigh(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) - 1));
                        ObjectSetInteger(0, TF + "FVG" + v, OBJPROP_BACK, false);
                        ObjectSetInteger(0, TF + "FVG" + v, OBJPROP_COLOR, clrLightSalmon);
                        ObjectSetInteger(0, TF + "FVG" + v, OBJPROP_STYLE, STYLE_DOT);
                        ObjectCreate(0, TF + "FVGfill" + v, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                        ObjectMove(0, TF + "FVGfill" + v, 0, iTime(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1), iLow(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1));
                        ObjectMove(0, TF + "FVGfill" + v, 1, stop, iHigh(SIMBA, TF, (iBars(SIMBA, TF) - FVGstop[v])));
                        ObjectSetInteger(0, TF + "FVGfill" + v, OBJPROP_BACK, true);
                        ObjectSetInteger(0, TF + "FVGfill" + v, OBJPROP_COLOR, clrLightSalmon);
                        if(DASHBOARD == false) CREATETEXTPRICEprice(TF + "FVGfilltext" + v, tftransformation(TF) + " FVG-", stop, MathMin(iLow(SIMBA, TF, (iBars(SIMBA, TF) - FVG[v]) + 1), iHigh(SIMBA, TF, (iBars(SIMBA, TF) - FVGstop[v]))), clrWhite, ANCHOR_LEFT_UPPER);
                        if(OBIMnat[v] == 2) {
                            ObjectCreate(0, TF + "FVGOBIM" + v, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                            ObjectMove(0, TF + "FVGOBIM" + v, 0, iTime(SIMBA, TF, (iBars(SIMBA, TF) - OBIM[v])), iHigh(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, 1 + (OBIMbreak[v] - OBIM[v]), (iBars(SIMBA, TF) - OBIMbreak[v]))));
                            ObjectMove(0, TF + "FVGOBIM" + v, 1, stopobim, iLow(SIMBA, TF, iBars(SIMBA, TF) - OBIM[v]));
                            ObjectSetInteger(0, TF + "FVGOBIM" + v, OBJPROP_COLOR, clrLightSalmon);
                            ObjectSetInteger(0, TF + "FVGOBIM" + v, OBJPROP_BACK, false);
                            ObjectSetInteger(0, TF + "FVGOBIM" + v, OBJPROP_STYLE, STYLE_SOLID);
                        }
                        if(OBIMstop[v] == 0 && FVGstopfull[v] == 0) upfind = 1;
                    }
                    ObjectSetInteger(0, TF + "FVG" + v, OBJPROP_HIDDEN, true);
                    ObjectSetInteger(0, TF + "FVGfill" + v, OBJPROP_HIDDEN, true);
                    ObjectSetInteger(0, TF + "FVGOBIM" + v, OBJPROP_HIDDEN, true);
                }
                if(FVGstopfull[v] == 1) {
                    ObjectDelete(0, TF + "FVGfill" + v);
                    ObjectDelete(0, TF + "FVGfilltext" + v);
                }
            }
        }
    }
    return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TDMNG()
{
    if(PENDINGMODE == 0) ObjectMove(0, "BUTXTD1_MANAGER_OPEN", 0, 0, iClose(Symbol(), 0, 0));
    double DIST = MathAbs(ObjectGetDouble(0, "BUTXTD1_MANAGER_OPEN", OBJPROP_PRICE) - ObjectGetDouble(0, "BUTXTD1_MANAGER_SL", OBJPROP_PRICE));
    double DISTTP = MathAbs(ObjectGetDouble(0, "BUTXTD1_MANAGER_OPEN", OBJPROP_PRICE) - ObjectGetDouble(0, "BUTXTD1_MANAGER_TP", OBJPROP_PRICE));
    double RISCHIO = StringToDouble(ObjectGetString(0, "BUTXTD1_RISK", OBJPROP_TEXT)) / 100;
    double SIZE = AccountEquity()  * RISCHIO / MathMax(1, Transform(DIST, 0, Symbol())) / MarketInfo(Symbol(), MODE_TICKVALUE);
    ObjectSetInteger(0, "BUTXTD1_MANAGER_OPEN", OBJPROP_SELECTED, true);
    ObjectSetInteger(0, "BUTXTD1_MANAGER_SL", OBJPROP_SELECTED, true);
    ObjectSetInteger(0, "BUTXTD1_MANAGER_TP", OBJPROP_SELECTED, true);
    string OP = "";
    int OPERA = -1;
    double APERTURA = NormalizeDouble(ObjectGetDouble(0, "BUTXTD1_MANAGER_OPEN", OBJPROP_PRICE1), MarketInfo(Symbol(), MODE_DIGITS));
    double STOPLOSS = NormalizeDouble(ObjectGetDouble(0, "BUTXTD1_MANAGER_SL", OBJPROP_PRICE1), MarketInfo(Symbol(), MODE_DIGITS));
    double TAKEPROFIT = NormalizeDouble(ObjectGetDouble(0, "BUTXTD1_MANAGER_TP", OBJPROP_PRICE1), MarketInfo(Symbol(), MODE_DIGITS));
    double PREZZO = NormalizeDouble(iClose(Symbol(), 0, 0), MarketInfo(Symbol(), MODE_DIGITS));
    if(PENDINGMODE == 0) {
        if(TAKEPROFIT > APERTURA && STOPLOSS < APERTURA) {
            OP = "Buy ";
            OPERA = OP_BUY;
        }
        else if(TAKEPROFIT < APERTURA && STOPLOSS > APERTURA) {
            OP = "Sell ";
            OPERA = OP_SELL;
        }
        else {
            OP = "USE PENDINGMODE";
            OPERA = -1;
        }
    }
    else {
        if(TAKEPROFIT > APERTURA && STOPLOSS < APERTURA) {
            if(PREZZO < APERTURA) {
                OP = "Buy stop ";
                OPERA = OP_BUYSTOP;
            }
            else if(PREZZO > APERTURA) {
                OP = "Buy limit ";
                OPERA = OP_BUYLIMIT;
            }
            else {
                OP = "BOOO";
                OPERA = -1;
            }
        }
        if(TAKEPROFIT > APERTURA && STOPLOSS > APERTURA) {
            OP = "Adjust TP or SL";
        }
        if(TAKEPROFIT < APERTURA && STOPLOSS > APERTURA) {
            if(PREZZO > APERTURA) {
                OP = "Sell stop ";
                OPERA = OP_SELLSTOP;
            }
            else if(PREZZO < APERTURA) {
                OP = "Sell limit ";
                OPERA = OP_SELLLIMIT;
            }
            else {
                OP = "BOOO";
                OPERA = -1;
            }
        }
        if(TAKEPROFIT < APERTURA && STOPLOSS < APERTURA) {
            OP = "Adjust TP or SL";
        }
    }
    if(OPERA != -1) {
        CREATETEXTPRICEprice("BUTXTD1_MANAGER_OPENtext", OP + "Lot Size : " + DoubleToStr(SIZE, 2),
                             iTime(Symbol(), 0, 1) + PeriodSeconds() * 10, ObjectGet("BUTXTD1_MANAGER_OPEN", OBJPROP_PRICE1), clrWhite, ANCHOR_LEFT_UPPER);
        CREATETEXTPRICEprice("BUTXTD1_MANAGER_SLtext", "SL " + DoubleToStr(Transform(DIST, 0, Symbol()), 0) + " points | -" + DoubleToStr(AccountEquity()*RISCHIO, 0) + " " + AccountCurrency(),
                             iTime(Symbol(), 0, 1) + PeriodSeconds() * 10, ObjectGet("BUTXTD1_MANAGER_SL", OBJPROP_PRICE1), clrWhite, ANCHOR_LEFT_UPPER);
        CREATETEXTPRICEprice("BUTXTD1_MANAGER_TPtext", "RR 1:" + DoubleToStr(DISTTP / DIST, 1) + " | TP " + DoubleToStr(Transform(DISTTP, 0, Symbol()), 0) + " points | +" + DoubleToStr(AccountEquity()*RISCHIO * DISTTP / DIST, 0) + " " + AccountCurrency(),
                             iTime(Symbol(), 0, 1) + PeriodSeconds() * 10, ObjectGet("BUTXTD1_MANAGER_TP", OBJPROP_PRICE1), clrWhite, ANCHOR_LEFT_LOWER);
    }
    else {
        CREATETEXTPRICEprice("BUTXTD1_MANAGER_OPENtext", OP,
                             iTime(Symbol(), 0, 1) + PeriodSeconds() * 10, ObjectGet("BUTXTD1_MANAGER_OPEN", OBJPROP_PRICE1), clrWhite, ANCHOR_LEFT_UPPER);
        CREATETEXTPRICEprice("BUTXTD1_MANAGER_SLtext", "wrong SL",
                             iTime(Symbol(), 0, 1) + PeriodSeconds() * 10, ObjectGet("BUTXTD1_MANAGER_SL", OBJPROP_PRICE1), clrWhite, ANCHOR_LEFT_UPPER);
        CREATETEXTPRICEprice("BUTXTD1_MANAGER_TPtext", "wrong TP",
                             iTime(Symbol(), 0, 1) + PeriodSeconds() * 10, ObjectGet("BUTXTD1_MANAGER_TP", OBJPROP_PRICE1), clrWhite, ANCHOR_LEFT_LOWER);
    }
    if(OPENTRADE == 1) {
        if(OPERA != -1) {
            double SAZZA = SIZE / StringToInteger(ObjectGetString(0, "BUTXTD1_NUMB", OBJPROP_TEXT));
            if(PENDINGMODE == 0) {
                for(int i = 0; i < StringToInteger(ObjectGetString(0, "BUTXTD1_NUMB", OBJPROP_TEXT)); i++) {
                    //OrderSend(Symbol(), OPERA, StringToDouble(DoubleToStr(SAZZA, 2)), NormalizeDouble(Ask, Digits), 50, STOPLOSS, TAKEPROFIT, "", 0, 0, clrNONE);
                }
            }
            else {
                for(int i = 0; i < StringToInteger(ObjectGetString(0, "BUTXTD1_NUMB", OBJPROP_TEXT)); i++) {
                    //OrderSend(Symbol(), OPERA, StringToDouble(DoubleToStr(SAZZA, 2)), StringToDouble(DoubleToString(ObjectGet("BUTXTD1_MANAGER_OPEN", OBJPROP_PRICE1), MarketInfo(Symbol(), MODE_DIGITS))), 50, STOPLOSS, TAKEPROFIT, "", 0, 0, clrNONE);
                }
            }
        }
        OPENTRADE = 0;
        TRADEMODE = 0;
        PENDINGMODE = 0;
        HIDE_TD1 = 0;
        int totalObjects = ObjectsTotal(0, 0, -1);
        for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
            if(StringSubstr(ObjectName(i), 0, 15) == "BUTXTD1_MANAGER") ObjectDelete(ObjectName(i));
        }
        ObjectSetInteger(0, "BUTXTD1_DRAW", OBJPROP_STATE, false);
        ObjectSetInteger(0, "BUTXTD1_DRAW", OBJPROP_BGCOLOR, clrLightGray);
        ObjectSetInteger(0, "BUTXTD1_PENDING", OBJPROP_STATE, false);
        ObjectSetInteger(0, "BUTXTD1_PENDING", OBJPROP_BGCOLOR, clrLightGray);
        ObjectSetInteger(0, "BUTXTD1_OPEN", OBJPROP_STATE, false);
        ObjectSetInteger(0, "BUTXTD1_OPEN", OBJPROP_BGCOLOR, clrLightGray);
        ObjectSetString(0, "BUTXTD1_OPEN", OBJPROP_TEXT, "OPEN TRADE");
        SHOWHIDE(HIDE_TD1, "TD1");
    }
    return(false);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double VOLPROF(string SIM, int TF)
{
//// VOLUME PROFILE :
    int THECAND = iBarShift(SIM, 0, iTime(SIM, GlobalVariableGet(Symbol() + "TFBARRE"), GlobalVariableGet(Symbol() + "BARRE")));
    int THECANDDAILY = iBarShift(SIM, 1440, iTime(SIM, 0, THECAND));
    for(int k = 10 + THECANDDAILY; k >= 0 + THECANDDAILY; k--) {
        int today = iBarShift(SIM, 0, iTime(SIM, 1440, k));
        int tomorrow = MathMax(THECAND, iBarShift(SIM, 0, iTime(SIM, 1440, k - 1)) + 1);
        if(k == 0) tomorrow = THECAND;
        double profile_candle[];
        double profile_points[];
        double base = iLow(SIM, 1440, k);
        base = iLow(SIM, 0, iLowest(SIM, 0, MODE_LOW, (today - tomorrow) + 1, tomorrow));
        double endbase = iHigh(SIM, 1440, k);
        endbase = iHigh(SIM, 0, iHighest(SIM, 0, MODE_HIGH, (today - tomorrow) + 1, tomorrow));
        while(base <= endbase) {
            ArrayResize(profile_candle, ArraySize(profile_candle) + 1);
            profile_candle[ArraySize(profile_candle) - 1] = base;
            ArrayResize(profile_points, ArraySize(profile_points) + 1);
            profile_points[ArraySize(profile_points) - 1] = 0;
            base = base + MarketInfo(SIM, MODE_POINT);
        }
        for(int h = today; h >= tomorrow; h--) {
            for(int g = 0; g < ArraySize(profile_points) - 1; g++) {
                if(iHigh(SIM, 0, h) >= profile_candle[g] && iLow(SIM, 0, h) <= profile_candle[g]) {
                    profile_points[g] = profile_points[g] + 1;
                    if(ObjectFind(0, "PROFILE_" + k + "_" + g) < 0) {
                        ObjectCreate(0, "PROFILE_" + k + "_" + g, OBJ_RECTANGLE, 0, iTime(SIM, 0, today), profile_candle[g], 0, profile_candle[g] + MarketInfo(SIM, MODE_POINT));
                        ObjectSetInteger(0, "PROFILE_" + k + "_" + g, OBJPROP_HIDDEN, true);
                    }
                    if(ObjectGetInteger(0, "PROFILE_" + k + "_" + g, OBJPROP_TIME2) != iTime(SIM, 0, today) + profile_points[g]*PeriodSeconds()) ObjectMove(0, "PROFILE_" + k + "_" + g, 1, iTime(SIM, 0, today) + profile_points[g]*PeriodSeconds(), ObjectGetDouble(0, "PROFILE_" + k + "_" + g, OBJPROP_PRICE2));
                }
            }
        }
    }
    if(THECANDDAILY > 0) {
        int totalObjects = ObjectsTotal(0, 0, -1);
        for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
            if(StringSubstr(ObjectName(i), 0, 4) == "PROF" && StringSubstr(ObjectName(i), 8, 1) < THECANDDAILY) ObjectDelete(ObjectName(i));
        }
    }
    return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ORDERBLOCK(string SIMBA, int TF, int CURRCANDX, int DRAWYN, int LSBYES, int DELETE)
{
    RefreshRates();
    if(DELETE == 0) {
        if(DASHBOARD == false) {
            string BUTTON = "";
            switch(TF) {
            case 1:
                BUTTON = "M1";
                break;
            case 5 :
                BUTTON = "M5";
                break;
            case 15 :
                BUTTON = "M15";
                break;
            case 30 :
                BUTTON = "M30";
                break;
            case 60 :
                BUTTON = "H1";
                break;
            case 240 :
                BUTTON = "H4";
                break;
            case 1440 :
                BUTTON = "D1";
                break;
            case PERIOD_W1 :
                BUTTON = "W1";
                break;
            case PERIOD_MN1 :
                BUTTON = "MN1";
                break;
            }
            string FLOQ = "OFF";
            ObjectSetString(0, "BUTXTD0_" + BUTTON, OBJPROP_TEXT, FLOQ);
        }
        int LUNGA = StringLen(TF) + 1;
        int totalObjects = ObjectsTotal(0, 0, -1);
        for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
            VEDIFIBO(SIMBA, TF, 0, LAST_LL, LAST_HH, 0);
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "S")  ObjectDelete(ObjectName(i));
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "L")  ObjectDelete(ObjectName(i));
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "H")  ObjectDelete(ObjectName(i));
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "O")  ObjectDelete(ObjectName(i));
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "B")  ObjectDelete(ObjectName(i));
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "R")  ObjectDelete(ObjectName(i));
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "W")  ObjectDelete(ObjectName(i));
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "X")  ObjectDelete(ObjectName(i));
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "F")  ObjectDelete(ObjectName(i));
            if(ObjectName(i) == "BUTXTD0_" + tftransformation(TF) + "_FAREA") ObjectDelete(ObjectName(i));
        }
        return(0);
    }
    ChartSetInteger(0, CHART_FOREGROUND, 0);
    int CANDLE;
    double BMSall[];
    double BMSallnature[];
    double BMS[];
    double BMSbreak[];
    double HH[];
    double LL[];
    double FLOW[];
    double OBresp[];
    double BREAKER[];
    double RTO[];
    double RTOall[];
    double RTS[];
    double FVG[];
    double FVGnat[];
    double INVALID[];
    int MAXCAND = 0;
    switch(TF) {
    case 1 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 10)));
        break;
    case 5 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 50)));
        break;
    case 15 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 100)));
        break;
    case 30 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 200)));
        break;
    case 60 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 365)));
        break;
    case 240 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 3 * 365)));
        break;
    case 1440 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_MN1, 48)));
        break;
    case PERIOD_W1 :
        MAXCAND = iBars(SIMBA, TF) - 50;
        break;
    case PERIOD_MN1 :
        MAXCAND = iBars(SIMBA, TF) - 50;
        break;
    }
    int LOADINGlevel = 0;
    for(int i = MAXCAND + CURRCANDX; i > CURRCANDX; i--) {
        if(ArraySize(FLOW) == 0) {
            if(iClose(SIMBA, TF, i + 2) < iOpen(SIMBA, TF, i + 2) && iClose(SIMBA, TF, i + 1) > iHigh(SIMBA, TF, i + 2) && iClose(SIMBA, TF, i) > iHigh(SIMBA, TF, i + 1)) {
                if(DEBUGMODE == true)   Print("01");
                ArrayResize(BMSall, ArraySize(BMSall) + 1);
                ArrayResize(BMSallnature, ArraySize(BMSallnature) + 1);
                ArrayResize(RTOall, ArraySize(RTOall) + 1);
                ArrayResize(BMS, ArraySize(BMS) + 1);
                ArrayResize(BMSbreak, ArraySize(BMSbreak) + 1);
                ArrayResize(HH, ArraySize(HH) + 1);
                ArrayResize(LL, ArraySize(LL) + 1);
                ArrayResize(FLOW, ArraySize(FLOW) + 1);
                ArrayResize(OBresp, ArraySize(OBresp) + 1);
                ArrayResize(BREAKER, ArraySize(BREAKER) + 1);
                ArrayResize(RTO, ArraySize(RTO) + 1);
                ArrayResize(RTS, ArraySize(RTS) + 1);
                ArrayResize(INVALID, ArraySize(INVALID) + 1);
                int F = FVGcalc(SIMBA, TF, i, FVG, FVGnat, 1);
                RTOall[ArraySize(RTOall) - 1] = iBars(SIMBA, TF) - (i + 2);
                BMS[ArraySize(BMS) - 1] = iBars(SIMBA, TF) - (i + 2);
                BMSbreak[ArraySize(BMSbreak) - 1] = iBars(SIMBA, TF) - (i + 1);
                BMSall[ArraySize(BMSall) - 1] = BMS[ArraySize(BMS) - 1];
                BMSallnature[ArraySize(BMSallnature) - 1] = 1;
                LL[ArraySize(LL) - 1] = BMS[ArraySize(BMS) - 1];
                HH[ArraySize(HH) - 1] = iBars(SIMBA, TF) - i;
                FLOW[ArraySize(FLOW) - 1] = 1;
                OBresp[ArraySize(OBresp) - 1] = iBars(SIMBA, TF) - (i + 2);
                BREAKER[ArraySize(BREAKER) - 1] = iBars(SIMBA, TF) - (i + 1);
                RTO[ArraySize(RTO) - 1] = iBars(SIMBA, TF) - (i + 2);
                RTS[ArraySize(RTS) - 1] = iBars(SIMBA, TF) - (i + 1);
            }
            if(iClose(SIMBA, TF, i + 2) > iOpen(SIMBA, TF, i + 2) && iClose(SIMBA, TF, i + 1) < iLow(SIMBA, TF, i + 2) && iClose(SIMBA, TF, i) < iLow(SIMBA, TF, i + 1)) {
                if(DEBUGMODE == true)   Print("02");
                ArrayResize(BMSall, ArraySize(BMSall) + 1);
                ArrayResize(BMSallnature, ArraySize(BMSallnature) + 1);
                ArrayResize(RTOall, ArraySize(RTOall) + 1);
                ArrayResize(BMS, ArraySize(BMS) + 1);
                ArrayResize(BMSbreak, ArraySize(BMSbreak) + 1);
                ArrayResize(HH, ArraySize(HH) + 1);
                ArrayResize(LL, ArraySize(LL) + 1);
                ArrayResize(FLOW, ArraySize(FLOW) + 1);
                ArrayResize(OBresp, ArraySize(OBresp) + 1);
                ArrayResize(BREAKER, ArraySize(BREAKER) + 1);
                ArrayResize(RTO, ArraySize(RTO) + 1);
                ArrayResize(RTS, ArraySize(RTS) + 1);
                ArrayResize(INVALID, ArraySize(INVALID) + 1);
                int F = FVGcalc(SIMBA, TF, i, FVG, FVGnat, 2);
                RTOall[ArraySize(RTOall) - 1] = iBars(SIMBA, TF) - (i + 2);
                BMS[ArraySize(BMS) - 1] = iBars(SIMBA, TF) - (i + 2);
                BMSbreak[ArraySize(BMSbreak) - 1] = iBars(SIMBA, TF) - (i + 1);
                BMSall[ArraySize(BMSall) - 1] = BMS[ArraySize(BMS) - 1];
                BMSallnature[ArraySize(BMSallnature) - 1] = 2;
                HH[ArraySize(HH) - 1] = BMS[ArraySize(BMS) - 1];
                LL[ArraySize(LL) - 1] = iBars(SIMBA, TF) - i;
                FLOW[ArraySize(FLOW) - 1] = 2;
                OBresp[ArraySize(OBresp) - 1] = iBars(SIMBA, TF) - (i + 2);
                BREAKER[ArraySize(BREAKER) - 1] = iBars(SIMBA, TF) - (i + 1);
                RTO[ArraySize(RTO) - 1] = iBars(SIMBA, TF) - (i + 2);
                RTS[ArraySize(RTS) - 1] = iBars(SIMBA, TF) - (i + 2);
            }
            else continue;
        }
        else {
            if(FLOW[ArraySize(FLOW) - 1] == 1) {
                if(
                    (iClose(SIMBA, TF, i) < iLow(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, 1 + (HH[ArraySize(HH) - 1] - LL[ArraySize(LL) - 1]), iBars(SIMBA, TF) - HH[ArraySize(HH) - 1])))
                ) {
                    if(DEBUGMODE == true)  Print("12");
                    ArrayResize(BMSall, ArraySize(BMSall) + 1);
                    ArrayResize(BMSallnature, ArraySize(BMSallnature) + 1);
                    ArrayResize(RTOall, ArraySize(RTOall) + 1);
                    ArrayResize(BMS, ArraySize(BMS) + 1);
                    ArrayResize(BMSbreak, ArraySize(BMSbreak) + 1);
                    ArrayResize(HH, ArraySize(HH) + 1);
                    ArrayResize(LL, ArraySize(LL) + 1);
                    ArrayResize(FLOW, ArraySize(FLOW) + 1);
                    ArrayResize(OBresp, ArraySize(OBresp) + 1);
                    ArrayResize(BREAKER, ArraySize(BREAKER) + 1);
                    ArrayResize(RTO, ArraySize(RTO) + 1);
                    RTO[ArraySize(RTO) - 1] = -1;
                    RTOall[ArraySize(RTOall) - 1] = -1;
                    ArrayResize(RTS, ArraySize(RTS) + 1);
                    RTS[ArraySize(RTS) - 1] = -1;
                    ArrayResize(INVALID, ArraySize(INVALID) + 1);
                    int F = FVGcalc(SIMBA, TF, i, FVG, FVGnat, 1);
                    FLOW[ArraySize(FLOW) - 1] = 2;
                    HH[ArraySize(HH) - 1] = iBars(SIMBA, TF) - iHighest(SIMBA, TF, MODE_CLOSE, 1 + ((iBars(SIMBA, TF) - LL[ArraySize(LL) - 2]) - i), i);
                    LL[ArraySize(LL) - 1] = iBars(SIMBA, TF) - i;
                    BREAKER[ArraySize(BREAKER) - 1] = iBars(SIMBA, TF) - i;
                    int OK = 0;
                    if(BMS[ArraySize(BMS) - 1] == 0) BMS[ArraySize(BMS) - 1] = HH[ArraySize(HH) - 1];
                    for(int s = i; s <= iBars(SIMBA, TF) - BMS[ArraySize(BMS) - 2]; s++) {
                        if(iClose(SIMBA, TF, s) > iOpen(SIMBA, TF, s)) {
                            for(int f = s; f > CURRCANDX; f--) {
                                if(iClose(SIMBA, TF, f) < iLow(SIMBA, TF, s)) {
                                    BMSbreak[ArraySize(BMSbreak) - 1] = iBars(SIMBA, TF) - f;
                                    break;
                                }
                            }
                            if(BMSbreak[ArraySize(BMSbreak) - 1] != 0) {
                                BMS[ArraySize(BMS) - 1] = iBars(SIMBA, TF) - s;
                                break;
                            }
                        }
                    }
                    OBresp[ArraySize(OBresp) - 1] = LL[ArraySize(LL) - 2];
                    BMSall[ArraySize(BMSall) - 1] = BMS[ArraySize(BMS) - 1];
                    BMSallnature[ArraySize(BMSallnature) - 1] = 2;
                }
                else if(iHigh(SIMBA, TF, i) > iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1])
                       ) {
                    int F = FVGcalc(SIMBA, TF, i, FVG, FVGnat, 1);
                    if(DEBUGMODE == true)  Print("11");
                    int NEWHIGH = 0;
                    int HHprov = 0;
                    int PASS = 0;
                    for(int k = iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]; k > i; k--) {
                        if(iClose(SIMBA, TF, k) < iLow(SIMBA, TF, k + 1)) {
                            HHprov = -1;
                            break;
                        }
                    }
                    if(HHprov == -1) {
                        if(iClose(SIMBA, TF, i) > iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1])) {
                            HHprov = iBars(SIMBA, TF) - HH[ArraySize(HH) - 1];
                            NEWHIGH = 1;
                        }
                    }
                    if(NEWHIGH == 0 && HHprov == 0) {
                        int nuovo = 0;
                        HH[ArraySize(HH) - 1] = iBars(SIMBA, TF) - i;
                        for(int s = i; s < iBars(SIMBA, TF) - BMS[ArraySize(BMS) - 1]; s++) {
                            if(iClose(SIMBA, TF, s) < iOpen(SIMBA, TF, s)) {
                                for(int f = s; f > CURRCANDX; f--) {
                                    if(iClose(SIMBA, TF, f) > iHigh(SIMBA, TF, s)) {
                                        nuovo = iBars(SIMBA, TF) - f;
                                        break;
                                    }
                                }
                                if(BMSbreak[ArraySize(BMSbreak) - 1] != 0 && BMSbreak[ArraySize(BMSbreak) - 1] != nuovo && nuovo != 0) {
                                    BMS[ArraySize(BMS) - 1] = iBars(SIMBA, TF) - s;
                                    BMSbreak[ArraySize(BMSbreak) - 1] = nuovo;
                                    break;
                                }
                                if(nuovo == BMSbreak[ArraySize(BMSbreak) - 1]) break;
                            }
                        }
                    }
                    if(NEWHIGH == 1) {
                        for(int k = i; k <= HHprov; k++) {
                            if(iClose(SIMBA, TF, k) < iOpen(SIMBA, TF, k) && iHigh(SIMBA, TF, k) < iClose(SIMBA, TF, iHighest(SIMBA, TF, MODE_CLOSE, (k - i) + 1, i))
                              ) {
                                ArrayResize(BMSall, ArraySize(BMSall) + 1);
                                ArrayResize(BMSallnature, ArraySize(BMSallnature) + 1);
                                ArrayResize(RTOall, ArraySize(RTOall) + 1);
                                ArrayResize(BMS, ArraySize(BMS) + 1);
                                ArrayResize(BMSbreak, ArraySize(BMSbreak) + 1);
                                ArrayResize(HH, ArraySize(HH) + 1);
                                ArrayResize(LL, ArraySize(LL) + 1);
                                ArrayResize(FLOW, ArraySize(FLOW) + 1);
                                ArrayResize(OBresp, ArraySize(OBresp) + 1);
                                ArrayResize(BREAKER, ArraySize(BREAKER) + 1);
                                ArrayResize(RTO, ArraySize(RTO) + 1);
                                ArrayResize(RTS, ArraySize(RTS) + 1);
                                ArrayResize(INVALID, ArraySize(INVALID) + 1);
                                for(int s = i; s <= iBars(SIMBA, TF) - BMS[ArraySize(BMS) - 2]; s++) {
                                    if(iClose(SIMBA, TF, s) < iOpen(SIMBA, TF, s)) {
                                        for(int f = s; f > CURRCANDX; f--) {
                                            if(iClose(SIMBA, TF, f) > iHigh(SIMBA, TF, s)) {
                                                BMSbreak[ArraySize(BMSbreak) - 1] = iBars(SIMBA, TF) - f;
                                                break;
                                            }
                                        }
                                        if(BMSbreak[ArraySize(BMSbreak) - 1] != 0) {
                                            BMS[ArraySize(BMS) - 1] = iBars(SIMBA, TF) - s;
                                            break;
                                        }
                                    }
                                }
                                BMSall[ArraySize(BMSall) - 1] = BMS[ArraySize(BMS) - 1];
                                LL[ArraySize(LL) - 1] = iBars(SIMBA, TF) - iLowest(SIMBA, TF, MODE_CLOSE, (HHprov - i) + 1, i);
                                BMSallnature[ArraySize(BMSallnature) - 1] = 1;
                                RTOall[ArraySize(RTOall) - 1] = -1;
                                HH[ArraySize(HH) - 1] = iBars(SIMBA, TF) - i;
                                FLOW[ArraySize(FLOW) - 1] = 1;
                                OBresp[ArraySize(OBresp) - 1] = iBars(SIMBA, TF) - HHprov;
                                BREAKER[ArraySize(BREAKER) - 1] = iBars(SIMBA, TF) - i;
                                RTO[ArraySize(RTO) - 1] = -1;
                                RTS[ArraySize(RTS) - 1] = -1;
                                break;
                            }
                        }
                    }
                }
                else {
                    int F = FVGcalc(SIMBA, TF, i, FVG, FVGnat, 3);
                }
            }
            else if(FLOW[ArraySize(FLOW) - 1] == 2) {
                if(
                    (iClose(SIMBA, TF, i) > iHigh(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, 1 + (LL[ArraySize(LL) - 1] - HH[ArraySize(HH) - 1]), iBars(SIMBA, TF) - LL[ArraySize(LL) - 1])))
                ) {
                    if(DEBUGMODE == true)  Print("12");
                    ArrayResize(BMSall, ArraySize(BMSall) + 1);
                    ArrayResize(BMSallnature, ArraySize(BMSallnature) + 1);
                    ArrayResize(RTOall, ArraySize(RTOall) + 1);
                    ArrayResize(BMS, ArraySize(BMS) + 1);
                    ArrayResize(BMSbreak, ArraySize(BMSbreak) + 1);
                    ArrayResize(HH, ArraySize(HH) + 1);
                    ArrayResize(LL, ArraySize(LL) + 1);
                    ArrayResize(FLOW, ArraySize(FLOW) + 1);
                    ArrayResize(OBresp, ArraySize(OBresp) + 1);
                    ArrayResize(BREAKER, ArraySize(BREAKER) + 1);
                    ArrayResize(RTO, ArraySize(RTO) + 1);
                    RTO[ArraySize(RTO) - 1] = -1;
                    RTOall[ArraySize(RTOall) - 1] = -1;
                    ArrayResize(RTS, ArraySize(RTS) + 1);
                    RTS[ArraySize(RTS) - 1] = -1;
                    ArrayResize(INVALID, ArraySize(INVALID) + 1);
                    int F = FVGcalc(SIMBA, TF, i, FVG, FVGnat, 2);
                    FLOW[ArraySize(FLOW) - 1] = 1;
                    LL[ArraySize(LL) - 1] = iBars(SIMBA, TF) - iLowest(SIMBA, TF, MODE_CLOSE, 1 + (iBars(SIMBA, TF) - HH[ArraySize(HH) - 2]) - i, i);
                    HH[ArraySize(HH) - 1] = iBars(SIMBA, TF) - i;
                    BREAKER[ArraySize(BREAKER) - 1] = iBars(SIMBA, TF) - i;
                    int OK = 0;
                    if(BMS[ArraySize(BMS) - 1] == 0) BMS[ArraySize(BMS) - 1] = LL[ArraySize(LL) - 1];
                    for(int s = i; s <= iBars(SIMBA, TF) - BMS[ArraySize(BMS) - 2]; s++) {
                        if(iClose(SIMBA, TF, s) < iOpen(SIMBA, TF, s)) {
                            for(int f = s; f > CURRCANDX; f--) {
                                if(iClose(SIMBA, TF, f) > iHigh(SIMBA, TF, s)) {
                                    BMSbreak[ArraySize(BMSbreak) - 1] = iBars(SIMBA, TF) - f;
                                    break;
                                }
                            }
                            if(BMSbreak[ArraySize(BMSbreak) - 1] != 0) {
                                BMS[ArraySize(BMS) - 1] = iBars(SIMBA, TF) - s;
                                break;
                            }
                        }
                    }
                    OBresp[ArraySize(OBresp) - 1] = HH[ArraySize(HH) - 2];
                    if(OBresp[ArraySize(OBresp) - 1] == 0) OBresp[ArraySize(OBresp) - 1] = BMS[ArraySize(BMS) - 1];
                    BMSall[ArraySize(BMSall) - 1] = BMS[ArraySize(BMS) - 1];
                    BMSallnature[ArraySize(BMSallnature) - 1] = 1;
                }
                else if(iLow(SIMBA, TF, i) < iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1])
                       ) {
                    int F = FVGcalc(SIMBA, TF, i, FVG, FVGnat, 2);
                    if(DEBUGMODE == true)  Print("22");
                    int NEWLOW = 0;
                    int LLprov = 0;
                    int PASS = 0;
                    for(int k = iBars(SIMBA, TF) - LL[ArraySize(LL) - 1]; k > i; k--) {
                        if(iClose(SIMBA, TF, k) > iHigh(SIMBA, TF, k + 1)
                          ) {
                            LLprov = -1;
                            break;
                        }
                    }
                    if(LLprov == -1) {
                        if((iClose(SIMBA, TF, i) < iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1]))
                          ) {
                            LLprov = iBars(SIMBA, TF) - LL[ArraySize(LL) - 1];
                            NEWLOW = 1;
                        }
                    }
                    if(NEWLOW != 1 && LLprov != -1) {
                        int nuovo = 0;
                        LL[ArraySize(LL) - 1] = iBars(SIMBA, TF) - i;
                        for(int s = i; s <= iBars(SIMBA, TF) - BMS[ArraySize(BMS) - 1]; s++) {
                            if(iClose(SIMBA, TF, s) > iOpen(SIMBA, TF, s)) {
                                for(int f = s; f > CURRCANDX; f--) {
                                    if(iClose(SIMBA, TF, f) < iLow(SIMBA, TF, s)) {
                                        nuovo = iBars(SIMBA, TF) - f;
                                        break;
                                    }
                                }
                                if(BMSbreak[ArraySize(BMSbreak) - 1] != 0 && BMSbreak[ArraySize(BMSbreak) - 1] != nuovo && nuovo != 0) {
                                    BMS[ArraySize(BMS) - 1] = iBars(SIMBA, TF) - s;
                                    BMSbreak[ArraySize(BMSbreak) - 1] = nuovo;
                                    break;
                                }
                                if(nuovo == BMSbreak[ArraySize(BMSbreak) - 1]) break;
                            }
                        }
                    }
                    if(NEWLOW == 1) {
                        for(int k = i; k <= LLprov; k++) {
                            if(iClose(SIMBA, TF, k) > iOpen(SIMBA, TF, k) && iLow(SIMBA, TF, k) > iClose(SIMBA, TF, iLowest(SIMBA, TF, MODE_CLOSE, (k - i) + 1, i))
                              ) {
                                ArrayResize(BMSall, ArraySize(BMSall) + 1);
                                ArrayResize(BMSallnature, ArraySize(BMSallnature) + 1);
                                ArrayResize(RTOall, ArraySize(RTOall) + 1);
                                ArrayResize(BMS, ArraySize(BMS) + 1);
                                ArrayResize(BMSbreak, ArraySize(BMSbreak) + 1);
                                ArrayResize(HH, ArraySize(HH) + 1);
                                ArrayResize(LL, ArraySize(LL) + 1);
                                ArrayResize(FLOW, ArraySize(FLOW) + 1);
                                ArrayResize(OBresp, ArraySize(OBresp) + 1);
                                ArrayResize(BREAKER, ArraySize(BREAKER) + 1);
                                ArrayResize(RTO, ArraySize(RTO) + 1);
                                ArrayResize(RTS, ArraySize(RTS) + 1);
                                ArrayResize(INVALID, ArraySize(INVALID) + 1);
                                for(int s = i; s <= iBars(SIMBA, TF) - BMS[ArraySize(BMS) - 2]; s++) {
                                    if(iClose(SIMBA, TF, s) > iOpen(SIMBA, TF, s)) {
                                        for(int f = s; f > CURRCANDX; f--) {
                                            if(iClose(SIMBA, TF, f) < iLow(SIMBA, TF, s)) {
                                                BMSbreak[ArraySize(BMSbreak) - 1] = iBars(SIMBA, TF) - f;
                                                break;
                                            }
                                        }
                                        if(BMSbreak[ArraySize(BMSbreak) - 1] != 0) {
                                            BMS[ArraySize(BMS) - 1] = iBars(SIMBA, TF) - s;
                                            break;
                                        }
                                    }
                                }
                                BMSall[ArraySize(BMSall) - 1] = BMS[ArraySize(BMS) - 1];
                                HH[ArraySize(HH) - 1] = iBars(SIMBA, TF) - iHighest(SIMBA, TF, MODE_CLOSE, (LLprov - i) + 1, i);
                                BMSallnature[ArraySize(BMSallnature) - 1] = 2;
                                RTOall[ArraySize(RTOall) - 1] = -1;
                                LL[ArraySize(LL) - 1] = iBars(SIMBA, TF) - i;
                                FLOW[ArraySize(FLOW) - 1] = 2;
                                OBresp[ArraySize(OBresp) - 1] = iBars(SIMBA, TF) - LLprov;
                                BREAKER[ArraySize(BREAKER) - 1] = iBars(SIMBA, TF) - i;
                                RTO[ArraySize(RTO) - 1] = -1;
                                RTS[ArraySize(RTS) - 1] = -1;
                                break;
                            }
                        }
                    }
                }
                else {
                    int F = FVGcalc(SIMBA, TF, i, FVG, FVGnat, 3);
                }
            }
        }
    }
    CANDLE = iBars(SIMBA, TF) - CURRCANDX;
//FUCK
    int SOURCEinv[];
    ArrayResize(SOURCEinv, ArraySize(BMS));
    int INVALIDATIONsource = iTime(SIMBA, TF, 1) + 60 * 60 * TF;
    int MIT = MITIGATIONfunc(SIMBA, TF, CURRCANDX, FLOW, RTS, HH, LL, RTO, BREAKER, BMS, BMSbreak, SOURCEinv);
////
    if(TF == PERIOD_M1) {
        M1CANDLE = CANDLE;
        ArrayFree(M1BMSall);
        ArrayFree(M1BMSallnature);
        ArrayFree(M1BMS);
        ArrayFree(M1BMSbreak);
        ArrayFree(M1HH);
        ArrayFree(M1LL);
        ArrayFree(M1FLOW);
        ArrayFree(M1OBresp);
        ArrayFree(M1BREAKER);
        ArrayFree(M1RTO);
        ArrayFree(M1RTOall);
        ArrayFree(M1RTS);
        ArrayFree(M1FVG);
        ArrayFree(M1FVGnat);
        ArrayFree(M1INVALID);
        ArrayCopy(M1BMSall, BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M1BMSallnature, BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M1BMS, BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M1BMSbreak, BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M1HH, HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M1LL, LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M1FLOW, FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M1OBresp, OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M1BREAKER, BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M1RTO, RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M1RTOall, RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M1RTS, RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M1FVG, FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M1FVGnat, FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M1INVALID, INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_M5) {
        M5CANDLE = CANDLE;
        ArrayFree(M5BMSall);
        ArrayFree(M5BMSallnature);
        ArrayFree(M5BMS);
        ArrayFree(M5BMSbreak);
        ArrayFree(M5HH);
        ArrayFree(M5LL);
        ArrayFree(M5FLOW);
        ArrayFree(M5OBresp);
        ArrayFree(M5BREAKER);
        ArrayFree(M5RTO);
        ArrayFree(M5RTOall);
        ArrayFree(M5RTS);
        ArrayFree(M5FVG);
        ArrayFree(M5FVGnat);
        ArrayFree(M5INVALID);
        ArrayCopy(M5BMSall, BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M5BMSallnature, BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M5BMS, BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M5BMSbreak, BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M5HH, HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M5LL, LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M5FLOW, FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M5OBresp, OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M5BREAKER, BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M5RTO, RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M5RTOall, RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M5RTS, RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M5FVG, FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M5FVGnat, FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M5INVALID, INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_M15) {
        M15CANDLE = CANDLE;
        ArrayFree(M15BMSall);
        ArrayFree(M15BMSallnature);
        ArrayFree(M15BMS);
        ArrayFree(M15BMSbreak);
        ArrayFree(M15HH);
        ArrayFree(M15LL);
        ArrayFree(M15FLOW);
        ArrayFree(M15OBresp);
        ArrayFree(M15BREAKER);
        ArrayFree(M15RTO);
        ArrayFree(M15RTOall);
        ArrayFree(M15RTS);
        ArrayFree(M15FVG);
        ArrayFree(M15FVGnat);
        ArrayFree(M15INVALID);
        ArrayCopy(M15BMSall, BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M15BMSallnature, BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M15BMS, BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M15BMSbreak, BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M15HH, HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M15LL, LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M15FLOW, FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M15OBresp, OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M15BREAKER, BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M15RTO, RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M15RTOall, RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M15RTS, RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M15FVG, FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M15FVGnat, FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M15INVALID, INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_M30) {
        M30CANDLE = CANDLE;
        ArrayFree(M30BMSall);
        ArrayFree(M30BMSallnature);
        ArrayFree(M30BMS);
        ArrayFree(M30BMSbreak);
        ArrayFree(M30HH);
        ArrayFree(M30LL);
        ArrayFree(M30FLOW);
        ArrayFree(M30OBresp);
        ArrayFree(M30BREAKER);
        ArrayFree(M30RTO);
        ArrayFree(M30RTOall);
        ArrayFree(M30RTS);
        ArrayFree(M30FVG);
        ArrayFree(M30FVGnat);
        ArrayFree(M30INVALID);
        ArrayCopy(M30BMSall, BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M30BMSallnature, BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M30BMS, BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M30BMSbreak, BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M30HH, HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M30LL, LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M30FLOW, FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M30OBresp, OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M30BREAKER, BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M30RTO, RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M30RTOall, RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M30RTS, RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M30FVG, FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M30FVGnat, FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(M30INVALID, INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_H1) {
        H1CANDLE = CANDLE;
        ArrayFree(H1BMSall);
        ArrayFree(H1BMSallnature);
        ArrayFree(H1BMS);
        ArrayFree(H1BMSbreak);
        ArrayFree(H1HH);
        ArrayFree(H1LL);
        ArrayFree(H1FLOW);
        ArrayFree(H1OBresp);
        ArrayFree(H1BREAKER);
        ArrayFree(H1RTO);
        ArrayFree(H1RTOall);
        ArrayFree(H1RTS);
        ArrayFree(H1FVG);
        ArrayFree(H1FVGnat);
        ArrayFree(H1INVALID);
        ArrayCopy(H1BMSall, BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H1BMSallnature, BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H1BMS, BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H1BMSbreak, BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H1HH, HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H1LL, LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H1FLOW, FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H1OBresp, OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H1BREAKER, BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H1RTO, RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H1RTOall, RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H1RTS, RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H1FVG, FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H1FVGnat, FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H1INVALID, INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_H4) {
        H4CANDLE = CANDLE;
        ArrayFree(H4BMSall);
        ArrayFree(H4BMSallnature);
        ArrayFree(H4BMS);
        ArrayFree(H4BMSbreak);
        ArrayFree(H4HH);
        ArrayFree(H4LL);
        ArrayFree(H4FLOW);
        ArrayFree(H4OBresp);
        ArrayFree(H4BREAKER);
        ArrayFree(H4RTO);
        ArrayFree(H4RTOall);
        ArrayFree(H4RTS);
        ArrayFree(H4FVG);
        ArrayFree(H4FVGnat);
        ArrayFree(H4INVALID);
        ArrayCopy(H4BMSall, BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H4BMSallnature, BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H4BMS, BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H4BMSbreak, BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H4HH, HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H4LL, LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H4FLOW, FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H4OBresp, OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H4BREAKER, BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H4RTO, RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H4RTOall, RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H4RTS, RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H4FVG, FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H4FVGnat, FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(H4INVALID, INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_D1) {
        D1CANDLE = CANDLE;
        ArrayFree(D1BMSall);
        ArrayFree(D1BMSallnature);
        ArrayFree(D1BMS);
        ArrayFree(D1BMSbreak);
        ArrayFree(D1HH);
        ArrayFree(D1LL);
        ArrayFree(D1FLOW);
        ArrayFree(D1OBresp);
        ArrayFree(D1BREAKER);
        ArrayFree(D1RTO);
        ArrayFree(D1RTOall);
        ArrayFree(D1RTS);
        ArrayFree(D1FVG);
        ArrayFree(D1FVGnat);
        ArrayFree(D1INVALID);
        ArrayCopy(D1BMSall, BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(D1BMSallnature, BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(D1BMS, BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(D1BMSbreak, BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(D1HH, HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(D1LL, LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(D1FLOW, FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(D1OBresp, OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(D1BREAKER, BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(D1RTO, RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(D1RTOall, RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(D1RTS, RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(D1FVG, FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(D1FVGnat, FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(D1INVALID, INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_W1) {
        W1CANDLE = CANDLE;
        ArrayFree(W1BMSall);
        ArrayFree(W1BMSallnature);
        ArrayFree(W1BMS);
        ArrayFree(W1BMSbreak);
        ArrayFree(W1HH);
        ArrayFree(W1LL);
        ArrayFree(W1FLOW);
        ArrayFree(W1OBresp);
        ArrayFree(W1BREAKER);
        ArrayFree(W1RTO);
        ArrayFree(W1RTOall);
        ArrayFree(W1RTS);
        ArrayFree(W1FVG);
        ArrayFree(W1FVGnat);
        ArrayFree(W1INVALID);
        ArrayCopy(W1BMSall, BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(W1BMSallnature, BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(W1BMS, BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(W1BMSbreak, BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(W1HH, HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(W1LL, LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(W1FLOW, FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(W1OBresp, OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(W1BREAKER, BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(W1RTO, RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(W1RTOall, RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(W1RTS, RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(W1FVG, FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(W1FVGnat, FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(W1INVALID, INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_MN1) {
        MN1CANDLE = CANDLE;
        ArrayFree(MN1BMSall);
        ArrayFree(MN1BMSallnature);
        ArrayFree(MN1BMS);
        ArrayFree(MN1BMSbreak);
        ArrayFree(MN1HH);
        ArrayFree(MN1LL);
        ArrayFree(MN1FLOW);
        ArrayFree(MN1OBresp);
        ArrayFree(MN1BREAKER);
        ArrayFree(MN1RTO);
        ArrayFree(MN1RTOall);
        ArrayFree(MN1RTS);
        ArrayFree(MN1FVG);
        ArrayFree(MN1FVGnat);
        ArrayFree(MN1INVALID);
        ArrayCopy(MN1BMSall, BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(MN1BMSallnature, BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(MN1BMS, BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(MN1BMSbreak, BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(MN1HH, HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(MN1LL, LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(MN1FLOW, FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(MN1OBresp, OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(MN1BREAKER, BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(MN1RTO, RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(MN1RTOall, RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(MN1RTS, RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(MN1FVG, FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(MN1FVGnat, FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(MN1INVALID, INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(ArraySize(BMS) < 3) {
        RILANCIAfun(9, Symbol());
        return(0);
    }
    LAST_FLOW = FLOW[ArraySize(FLOW) - 1];
    if(DASHBOARD == true) DRAWYN = 0;
    if(DRAWYN != 0) {
        ObjectCreate(0, TF + "HH", OBJ_ARROW, 0, 0, 0, 0, 0); // Create an arrow
        ObjectSetInteger(0, TF + "HH", OBJPROP_ARROWCODE, 174); // Set the arrow code
        ObjectSetInteger(0, TF + "HH", OBJPROP_TIME, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1])); // Set time
        ObjectSetDouble(0, TF + "HH", OBJPROP_PRICE, iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1])); // Set price
        ObjectSetInteger(0, TF + "HH", OBJPROP_ANCHOR, ANCHOR_BOTTOM);
        ObjectSetInteger(0, TF + "HH", OBJPROP_COLOR, clrLimeGreen);
        ObjectSetInteger(0, TF + "HH", OBJPROP_HIDDEN, true);
        ObjectCreate(0, TF + "LL", OBJ_ARROW, 0, 0, 0, 0, 0); // Create an arrow
        ObjectSetInteger(0, TF + "LL", OBJPROP_ARROWCODE, 174); // Set the arrow code
        ObjectSetInteger(0, TF + "LL", OBJPROP_TIME, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1])); // Set time
        ObjectSetDouble(0, TF + "LL", OBJPROP_PRICE, iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1])); // Set price
        ObjectSetInteger(0, TF + "LL", OBJPROP_ANCHOR, ANCHOR_TOP);
        ObjectSetInteger(0, TF + "LL", OBJPROP_COLOR, clrOrange);
        ObjectSetInteger(0, TF + "LL", OBJPROP_HIDDEN, true);
    }
    LAST_LEG0 = 0;
    LAST_LEG0flow = 0;
    LAST_LEG1 = 0;
    LAST_LEG1flow = 0;
    LAST_LEG2 = 0;
    LAST_LEG2flow = 0;
    int FLOWstart = 0;
    for(int j = ArraySize(FLOW) - 1; j >= 0; j--) {
        if(LAST_LEG0flow == 0) {
            LAST_LEG0flow = 1;
        }
        if(FLOW[j] == FLOW[j - 1]) {
            LAST_LEG0flow = LAST_LEG0flow + 1;
            continue;
        }
        if(FLOW[j] != FLOW[j - 1]) {
            FLOWstart = j;
            break;
        }
    }
    if(DASHBOARD == false) {
        string BUTTON = "";
        switch(TF) {
        case 1:
            BUTTON = "M1";
            break;
        case 5 :
            BUTTON = "M5";
            break;
        case 15 :
            BUTTON = "M15";
            break;
        case 30 :
            BUTTON = "M30";
            break;
        case 60 :
            BUTTON = "H1";
            break;
        case 240 :
            BUTTON = "H4";
            break;
        case 1440 :
            BUTTON = "D1";
            break;
        case PERIOD_W1 :
            BUTTON = "W1";
            break;
        case PERIOD_MN1 :
            BUTTON = "MN1";
            break;
        }
        string FLOQ = "CHoCH";
        if(LAST_LEG0flow > 1) FLOQ = "BOS";
        ObjectSetString(0, "BUTXTD0_" + BUTTON, OBJPROP_TEXT, FLOQ);
        if(FLOQ == "BOS") ObjectSetInteger(0, "BUTXTD0_" + BUTTON, OBJPROP_COLOR, clrYellow);
        else ObjectSetInteger(0, "BUTXTD0_" + BUTTON, OBJPROP_COLOR, clrBlack);
        double EQ = (iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]) + iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1])) / 2;
        double RANGE = (iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]) - iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1]));
        double FIBER = 0;
        if(FLOW[ArraySize(FLOW) - 1] == 1) {
            FIBER = (iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]) - iClose(SIMBA, TF, CURRCANDX)) / RANGE * 100;
        }
        if(FLOW[ArraySize(FLOW) - 1] == 2) {
            FIBER = (iClose(SIMBA, TF, CURRCANDX) - iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1])) / RANGE * 100;
        }
        string WHAT = "SD";
        if(iClose(SIMBA, TF, CURRCANDX) > EQ) WHAT = DoubleToString(FIBER, 0) + " %";
        if(iClose(SIMBA, TF, CURRCANDX) < EQ) WHAT = DoubleToString(FIBER, 0) + " %";
        if(iClose(SIMBA, TF, CURRCANDX) == EQ) WHAT = "Equilibrium";
        if(FLOW[ArraySize(FLOW) - 1] == 1 && FIBER > 50) WHAT = "D " + WHAT;
        if(FLOW[ArraySize(FLOW) - 1] == 1 && FIBER < 50) WHAT = "P " + WHAT;
        if(FLOW[ArraySize(FLOW) - 1] == 2 && FIBER > 50) WHAT = "P " + WHAT;
        if(FLOW[ArraySize(FLOW) - 1] == 2 && FIBER < 50) WHAT = "D " + WHAT;
// PREMIUM DISCOUNT
        if(DRAWYN != 0) {
            int CEMENTED = 0;
            if(LAST_FLOW == 1) {
                for(int j = iBars(SIMBA, TF) - BREAKER[ArraySize(BREAKER) - 1]; j > CURRCANDX; j--) {
                    if(iClose(SIMBA, TF, j) < iLow(SIMBA, TF, j + 1)) CEMENTED = 1;
                }
            }
            if(LAST_FLOW == 2) {
                for(int j = iBars(SIMBA, TF) - BREAKER[ArraySize(BREAKER) - 1]; j > CURRCANDX; j--) {
                    if(iClose(SIMBA, TF, j) > iHigh(SIMBA, TF, j + 1)) CEMENTED = 1;
                }
            }
            if(CEMENTED == 1) {
                ObjectCreate(0, TF + "FOBRpremdis", OBJ_TREND, 0, 0, 0, 0, 0);
                ObjectSetInteger(0, TF + "FOBRpremdis", OBJPROP_RAY, false);
                ObjectSetInteger(0, TF + "FOBRpremdis", OBJPROP_HIDDEN, true);
                if(LAST_FLOW == 1) ObjectSetInteger(0, TF + "FOBRpremdis", OBJPROP_COLOR, clrPaleGreen);
                if(LAST_FLOW == 2) ObjectSetInteger(0, TF + "FOBRpremdis", OBJPROP_COLOR, clrPink);
                ObjectMove(0, TF + "FOBRpremdis", 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - (HH[ArraySize(HH) - 1] + LL[ArraySize(LL) - 1]) / 2), EQ);
                datetime EQMIT = iTime(SIMBA, TF, CURRCANDX) + 2 * PeriodSeconds();
                int RRT = -1;
                if(LAST_FLOW == 1) {
                    for(int v = (iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]) - 1; v > CURRCANDX; v--) {
                        if(iLow(SIMBA, TF, v) <= EQ) {
                            RRT = v;
                            break;
                        }
                    }
                }
                if(LAST_FLOW == 2) {
                    for(int v = (iBars(SIMBA, TF) - LL[ArraySize(LL) - 1]) - 1; v > CURRCANDX; v--) {
                        if(iHigh(SIMBA, TF, v) >= EQ) {
                            RRT = v;
                            break;
                        }
                    }
                }
                ObjectMove(0, TF + "FOBRpremdis", 1, EQMIT, EQ);
                if(RRT == -1) {
                    ObjectSetInteger(0, TF + "FOBRpremdis", OBJPROP_STYLE, STYLE_SOLID);
                    ObjectSetInteger(0, TF + "FOBRpremdis", OBJPROP_WIDTH, 2);
                }
                else {
                    ObjectSetInteger(0, TF + "FOBRpremdis", OBJPROP_STYLE, STYLE_DOT);
                    ObjectSetInteger(0, TF + "FOBRpremdis", OBJPROP_WIDTH, 1);
                }
                CREATETEXTPRICEprice(TF + "FOBRpremtext", tftransformation(TF) + " PREMIUM", iTime(SIMBA, TF, CURRCANDX) + 2 * PeriodSeconds(), EQ, clrHotPink, ANCHOR_LEFT_LOWER);
                CREATETEXTPRICEprice(TF + "FOBRdistext", tftransformation(TF) + " DISCOUNT", iTime(SIMBA, TF, CURRCANDX) + 2 * PeriodSeconds(), EQ, clrLime, ANCHOR_LEFT_UPPER);
            }
            else ObjectDelete(0, TF + "FOBRpremis");
        }
        for(int h = 0; h < ArraySize(FLOW) - 1; h++) {
            if(DRAWYN != 0) {
                ObjectCreate(0, TF + "FOBRpremdis" + h, OBJ_TREND, 0, 0, 0, 0, 0);
                ObjectSetInteger(0, TF + "FOBRpremdis" + h, OBJPROP_RAY, false);
                if(RTO[h] == -1) {
                    ObjectSetInteger(0, TF + "FOBRpremdis" + h, OBJPROP_STYLE, STYLE_SOLID);
                    ObjectSetInteger(0, TF + "FOBRpremdis" + h, OBJPROP_WIDTH, 2);
                }
                else {
                    ObjectSetInteger(0, TF + "FOBRpremdis" + h, OBJPROP_STYLE, STYLE_DOT);
                    ObjectSetInteger(0, TF + "FOBRpremdis" + h, OBJPROP_WIDTH, 1);
                }
                ObjectSetInteger(0, TF + "FOBRpremdis", OBJPROP_HIDDEN, true);
                if(FLOW[h] == 1) ObjectSetInteger(0, TF + "FOBRpremdis" + h, OBJPROP_COLOR, clrPaleGreen);
                if(FLOW[h] == 2) ObjectSetInteger(0, TF + "FOBRpremdis" + h, OBJPROP_COLOR, clrPink);
                double EQU = (iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h]) + iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h])) / 2;
                ObjectMove(0, TF + "FOBRpremdis" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - (HH[h] + LL[h]) / 2), EQU);
                datetime EQMIT = iTime(SIMBA, TF, CURRCANDX) + 2 * PeriodSeconds();
                if(RTO[h] != -1) EQMIT = iTime(SIMBA, TF, iBars(SIMBA, TF) - RTO[h]);
                ObjectMove(0, TF + "FOBRpremdis" + h, 1, EQMIT, EQU);
            }
        }
// END PREMIUM DISCOUNT
        ObjectCreate(0, TF + "HHLL", OBJ_TREND, 0, 0, 0, 0, 0);
        ObjectSetInteger(0, TF + "HHLL", OBJPROP_RAY, false);
        datetime ORAETORA = TimeCurrent();
        if(CURRCANDX != 0) ORAETORA = iTime(SIMBA, TF, CURRCANDX);
        if(FLOW[ArraySize(FLOW) - 1] == 1) {
            ObjectMove(0, TF + "HHLL", 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]));
            ObjectMove(0, TF + "HHLL", 1, ORAETORA, iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]));
            ObjectSetInteger(0, TF + "HHLL", OBJPROP_COLOR, clrLimeGreen);
        }
        if(FLOW[ArraySize(FLOW) - 1] == 2) {
            ObjectMove(0, TF + "HHLL", 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1]));
            ObjectMove(0, TF + "HHLL", 1, ORAETORA, iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1]));
            ObjectSetInteger(0, TF + "HHLL", OBJPROP_COLOR, clrOrange);
        }
        string MOTHER = "BUTXTD0_" + BUTTON;
        EditCreate(0, "BUTXTD0_" + tftransformation(TF) + "_FAREA", 0,
                   (int)ObjectGetInteger(0, MOTHER, OBJPROP_XDISTANCE), (int)ObjectGetInteger(0, MOTHER, OBJPROP_YDISTANCE) - 20 * ZOOM_PIXEL, (int)ObjectGetInteger(0, MOTHER, OBJPROP_XSIZE), (int)ObjectGetInteger(0, MOTHER, OBJPROP_YSIZE),
                   WHAT, "Arial", FONT_SIZE, ALIGN_CENTER, true, CORNER_LEFT_LOWER, clrBlack);
        EditTextChange(0, "BUTXTD0_" + tftransformation(TF) + "_FAREA", WHAT, clrBlack, clrWhite);
    }
    if(DRAWYN != 0 && 1 == 2) {
        if(LAST_LEG0flow > 1) {
            if(FLOW[ArraySize(FLOW) - 1] == 1) {
                double AO_current = iAO(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]);
                double AO_previous = iAO(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 2]);
                if(AO_current < AO_previous) {
//ObjectCreate(0,TF+"SDIV",OBJ_TREND,0,0,0,0,0);
                    ObjectSetInteger(0, TF + "SDIV", OBJPROP_HIDDEN, true);
                    ObjectSetInteger(0, TF + "SDIV", OBJPROP_RAY, false);
                    ObjectSetInteger(0, TF + "SDIV", OBJPROP_WIDTH, 1);
                    ObjectSetInteger(0, TF + "SDIV", OBJPROP_COLOR, clrMagenta);
                    ObjectMove(0, TF + "SDIV", 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 2]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 2]));
                    ObjectMove(0, TF + "SDIV", 1, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]));
                }
                else ObjectDelete(0, TF + "SDIV");
            }
            if(FLOW[ArraySize(FLOW) - 1] == 2) {
                double AO_current = iAO(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1]);
                double AO_previous = iAO(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 2]);
                if(AO_current > AO_previous) {
                    ObjectCreate(0, TF + "SDIV", OBJ_TREND, 0, 0, 0, 0, 0);
                    ObjectSetInteger(0, TF + "SDIV", OBJPROP_HIDDEN, true);
                    ObjectSetInteger(0, TF + "SDIV", OBJPROP_RAY, false);
                    ObjectSetInteger(0, TF + "SDIV", OBJPROP_WIDTH, 1);
                    ObjectSetInteger(0, TF + "SDIV", OBJPROP_COLOR, clrAqua);
                    ObjectMove(0, TF + "SDIV", 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 2]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 2]));
                    ObjectMove(0, TF + "SDIV", 1, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1]));
                }
                else ObjectDelete(0, TF + "SDIV");
            }
        }
        else ObjectDelete(0, TF + "SDIV");
    }
    GlobalVariableSet(SIMBA + TF + "RANGEh", iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]));
    GlobalVariableSet(SIMBA + TF + "RANGEl", iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1]));
    GlobalVariableSet(SIMBA + TF + "RANGEf", FLOW[ArraySize(FLOW) - 1]);
    GlobalVariableSet(SIMBA + TF + "RANGEhcandle", iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]);
    GlobalVariableSet(SIMBA + TF + "RANGElcandle", iBars(SIMBA, TF) - LL[ArraySize(LL) - 1]);
    return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ORDERBLOCKshow(string SIMBA, int TF, int CURRCANDX, int DRAWYN, int LSBYES, int DELETE, int LQshow, int FVGshow)
{
    if(DELETE == 0) {
        int LUNGA = StringLen(TF) + 1;
        int totalObjects = ObjectsTotal(0, 0, -1);
        for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
            VEDIFIBO(SIMBA, TF, 0, LAST_LL, LAST_HH, 0);
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "S")  ObjectDelete(ObjectName(i));
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "O")  ObjectDelete(ObjectName(i));
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "B")  ObjectDelete(ObjectName(i));
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "R")  ObjectDelete(ObjectName(i));
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "W")  ObjectDelete(ObjectName(i));
        }
        return(0);
    }
    else {
        int LUNGA = StringLen(TF) + 1;
        int totalObjects = ObjectsTotal(0, 0, -1);
        for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "S")  ObjectDelete(ObjectName(i));
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "O")  ObjectDelete(ObjectName(i));
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "B")  ObjectDelete(ObjectName(i));
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "R")  ObjectDelete(ObjectName(i));
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "W")  ObjectDelete(ObjectName(i));
        }
    }
    ChartSetInteger(0, CHART_FOREGROUND, 0);
    int CANDLE;
    double BMSall[];
    double BMSallnature[];
    double BMS[];
    double BMSbreak[];
    double HH[];
    double LL[];
    double FLOW[];
    double OBresp[];
    double BREAKER[];
    double RTO[];
    double RTOall[];
    double RTS[];
    double FVG[];
    double FVGnat[];
    double INVALID[];
    int MAXCAND = 0;
    switch(TF) {
    case 1 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 10)));
        break;
    case 5 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 50)));
        break;
    case 15 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 100)));
        break;
    case 30 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 200)));
        break;
    case 60 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 365)));
        break;
    case 240 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 365)));
        break;
    case 1440 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_MN1, 24)));
        break;
    case PERIOD_W1 :
        MAXCAND = iBars(SIMBA, TF) - 50;
        break;
    case PERIOD_MN1 :
        MAXCAND = iBars(SIMBA, TF) - 50;
        break;
    }
    int LOADINGlevel = 0;
    if(TF == PERIOD_M1) {
        CANDLE = M1CANDLE;
        ArrayCopy(BMSall, M1BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, M1BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, M1BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSbreak, M1BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, M1HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, M1LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, M1FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, M1OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, M1BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, M1RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, M1RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, M1RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, M1FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, M1FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, M1INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_M5) {
        CANDLE = M5CANDLE;
        ArrayCopy(BMSall, M5BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, M5BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, M5BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSbreak, M5BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, M5HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, M5LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, M5FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, M5OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, M5BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, M5RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, M5RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, M5RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, M5FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, M5FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, M5INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_M15) {
        CANDLE = M15CANDLE;
        ArrayCopy(BMSall, M15BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, M15BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, M15BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSbreak, M15BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, M15HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, M15LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, M15FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, M15OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, M15BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, M15RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, M15RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, M15RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, M15FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, M15FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, M15INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_M30) {
        CANDLE = M30CANDLE;
        ArrayCopy(BMSall, M30BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, M30BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, M30BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSbreak, M30BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, M30HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, M30LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, M30FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, M30OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, M30BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, M30RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, M30RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, M30RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, M30FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, M30FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, M30INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_H1) {
        CANDLE = H1CANDLE;
        ArrayCopy(BMSall, H1BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, H1BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, H1BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSbreak, H1BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, H1HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, H1LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, H1FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, H1OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, H1BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, H1RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, H1RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, H1RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, H1FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, H1FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, H1INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_H4) {
        CANDLE = H4CANDLE;
        ArrayCopy(BMSall, H4BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, H4BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, H4BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSbreak, H4BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, H4HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, H4LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, H4FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, H4OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, H4BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, H4RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, H4RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, H4RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, H4FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, H4FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, H4INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_D1) {
        CANDLE = D1CANDLE;
        ArrayCopy(BMSall, D1BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, D1BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, D1BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSbreak, D1BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, D1HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, D1LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, D1FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, D1OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, D1BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, D1RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, D1RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, D1RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, D1FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, D1FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, D1INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_W1) {
        CANDLE = W1CANDLE;
        ArrayCopy(BMSall, W1BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, W1BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, W1BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSbreak, W1BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, W1HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, W1LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, W1FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, W1OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, W1BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, W1RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, W1RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, W1RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, W1FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, W1FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, W1INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_MN1) {
        CANDLE = MN1CANDLE;
        ArrayCopy(BMSall, MN1BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, MN1BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, MN1BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSbreak, MN1BMSbreak, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, MN1HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, MN1LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, MN1FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, MN1OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, MN1BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, MN1RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, MN1RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, MN1RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, MN1FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, MN1FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, MN1INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(DASHBOARD == true) DRAWYN = 0;
    int MULTITF = 0;
    MULTITF = CONTEGGIOTF();
    if(MULTITF > 1) {
        int HTFX = FINDWORKINGTF(2, TF);
        if(TF < HTFX) {
            int CANDELABRO = 0;
            if(GlobalVariableGet(SIMBA + "BARRE") != 0) CANDELABRO = iBarShift(SIMBA, TF, iTime(SIMBA, GlobalVariableGet(SIMBA + "TFBARRE"), GlobalVariableGet(SIMBA + "BARRE")));
            int FLOK = GlobalVariableGet(SIMBA + HTFX + "RANGEf");
            STRA0 = 1;
        }
        else {
            STRA0 = 0;
        }
    }
    LAST_HH = 0;
    LAST_LL = 0;
    LAST_EQ = 0;
    LAST_BMS = 0;
    LAST_BMSbreak = 0;
    LAST_BMSall = 0;
    LAST_BMSallnature = 0;
    LAST_BMSoppall = 0;
    LAST_SOURCE_A = 0;
    LAST_FLOW = 0;
    LAST_FLOWprev = 0;
    LAST_HH_SUPPLY = 0;
    LAST_HH_SUPPLY_index = 0;
    LAST_LL_DEMAND = 0;
    LAST_LL_DEMAND_index = 0;
    LAST_OB_SUPPLY = 0;
    LAST_OB_DEMAND = 0;
    LAST_RTO_CHECK = 0;
    LAST_RTO = 0;
    LAST_RTS = 0;
    LAST_RTS_CHECK = 0;
    LAST_STARTER_SOURCE = 0;
    LAST_RTSFUCK = 0;
/////// A GRAFICO :
    if(ArraySize(BMS) - 2 < 0) return(0);
    int SOURCEinv[];
    ArrayResize(SOURCEinv, ArraySize(BMS));
    int INVALIDATIONsource = iTime(SIMBA, TF, 1) + 60 * 60 * TF;
    if(DRAWYN != 0) {
        ObjectCreate(0, TF + "HH", OBJ_ARROW, 0, 0, 0, 0, 0); // Create an arrow
        ObjectSetInteger(0, TF + "HH", OBJPROP_ARROWCODE, 174); // Set the arrow code
        ObjectSetInteger(0, TF + "HH", OBJPROP_TIME, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1])); // Set time
        ObjectSetDouble(0, TF + "HH", OBJPROP_PRICE, iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1])); // Set price
        ObjectSetInteger(0, TF + "HH", OBJPROP_ANCHOR, ANCHOR_BOTTOM);
        ObjectSetInteger(0, TF + "HH", OBJPROP_COLOR, clrLimeGreen);
        ObjectSetInteger(0, TF + "HH", OBJPROP_HIDDEN, true);
        ObjectCreate(0, TF + "LL", OBJ_ARROW, 0, 0, 0, 0, 0); // Create an arrow
        ObjectSetInteger(0, TF + "LL", OBJPROP_ARROWCODE, 174); // Set the arrow code
        ObjectSetInteger(0, TF + "LL", OBJPROP_TIME, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1])); // Set time
        ObjectSetDouble(0, TF + "LL", OBJPROP_PRICE, iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1])); // Set price
        ObjectSetInteger(0, TF + "LL", OBJPROP_ANCHOR, ANCHOR_TOP);
        ObjectSetInteger(0, TF + "LL", OBJPROP_COLOR, clrOrange);
        ObjectSetInteger(0, TF + "LL", OBJPROP_HIDDEN, true);
    }
    int END_SOURCES = 2;
    for(int A = ArraySize(BMS) - 1; A >= END_SOURCES; A--) {
        int ok = 0;
        int AAA = 0;
        if(ok == 0) {
            int OUT = 1;
            int MIT = MITIGATIONfunc(SIMBA, TF, CURRCANDX, FLOW, RTS, HH, LL, RTO, BREAKER, BMS, BMSbreak, SOURCEinv);
            if(OUT == 1) {
                LAST_FLOW = FLOW[A];
                LAST_FLOWprev = FLOW[A - 1];
                LAST_SOURCE_A = A;
                LAST_BMS = BMS[A];
                LAST_BMSbreak = BMSbreak[A];
                if(LAST_FLOW == 1) {
                    LAST_HH = HH[ArraySize(HH) - 1];
                    LAST_LL = LL[A];
                }
                if(LAST_FLOW == 2) {
                    LAST_LL = LL[ArraySize(LL) - 1];
                    LAST_HH = HH[A];
                }
//LAST_HH=HH[A];
//LAST_LL=LL[A];
                LAST_EQ = (iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 2]) + iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 2])) / 2;
                LAST_OBresp = OBresp[A];
                LAST_BREAKER = BREAKER[A];
                LAST_RTO = RTO[A];
                LAST_RTS = RTS[A];
                for(int h = A; h >= 0; h--) {
                    if(FLOW[h] != FLOW[h - 1]) {
                        A = h;
                        LAST_STARTER_SOURCE = A;
                        LAST_RTSFUCK = RTS[LAST_STARTER_SOURCE];
                        break;
                    }
                }
                if(DRAWYN != 0) {
                    for(int h = A; h < ArraySize(FLOW); h++) {
                        if(STRA0_MANUAL == 1) {
                            if(h != ArraySize(FLOW) - 1) continue;
                        }
                        if(STRA0 == 1) {
                            if(h != ArraySize(FLOW) - 1) continue;
                        }
// LEGS
                        if(SEE_LEGS == true) ObjectCreate(0, TF + "OBR" + h, OBJ_TREND, 0, 0, 0, 0, 0);
                        ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_RAY, false);
                        ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_WIDTH, 1);
                        ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_HIDDEN, true);
// END LEGS
// SOURCES
                        ObjectCreate(0, TF + "SOURCE" + h, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                        ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_BACK, false);
                        if(RTS[h] == -1) {
                            ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_STYLE, STYLE_SOLID);
                            ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_WIDTH, 3);
                        }
                        else {
                            ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_STYLE, STYLE_DASH);
                            ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_WIDTH, 1);
                        }
                        ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_HIDDEN, true);
// END SOURCES
//SOURCES refined
                        ObjectCreate(0, TF + "SOSline" + h, OBJ_TREND, 0, 0, 0, 0, 0);
                        ObjectSetInteger(0, TF + "SOSline" + h, OBJPROP_RAY, false);
//END SOURCES refined
// CHOCH / BOS / LSB SIGNATURE
                        ObjectCreate(0, TF + "OBresp" + h, OBJ_TREND, 0, 0, 0, 0, 0);
                        ObjectSetInteger(0, TF + "OBresp" + h, OBJPROP_RAY, false);
                        ObjectSetInteger(0, TF + "OBresp" + h, OBJPROP_HIDDEN, true);
// END CHOCH ..
// OB
                        if(RTO[h] == -1) ObjectSetInteger(0, TF + "OBPOI" + h, OBJPROP_BACK, true);
                        else ObjectSetInteger(0, TF + "OBPOI" + h, OBJPROP_BACK, false);
                        ObjectSetInteger(0, TF + "OBPOI" + h, OBJPROP_WIDTH, 1);
                        ObjectSetInteger(0, TF + "OBPOI" + h, OBJPROP_HIDDEN, true);
// END OB
//OB refined
                        ObjectSetInteger(0, TF + "SOBline" + h, OBJPROP_RAY, false);
                        ObjectSetInteger(0, TF + "SOBline" + h, OBJPROP_HIDDEN, true);
// END OB refined
                        if(SOURCEinv[h] == 0) INVALIDATIONsource = iTime(SIMBA, TF, CURRCANDX) + 60 * TF;
                        else INVALIDATIONsource = iTime(SIMBA, TF, iBars(SIMBA, TF) - SOURCEinv[h]);
                        datetime INVALIDATIONB = iTime(SIMBA, TF, iBars(SIMBA, TF) - BREAKER[h]);
                        if(LAST_FLOW == 1) {
                            ObjectMove(0, TF + "OBR" + h, 0, iTime(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, 1 + (HH[h] - LL[h]), iBars(SIMBA, TF) - HH[h])), iLow(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, 1 + (HH[h] - LL[h]), iBars(SIMBA, TF) - HH[h])));
//ObjectMove(0,TF+"OBR"+h,0,iTime(SIMBA,TF,iBars(SIMBA,TF)-LL[h]),iLow(SIMBA,TF,iBars(SIMBA,TF)-LL[h]));
                            ObjectMove(0, TF + "OBR" + h, 1, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[h]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h]));
                            ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_COLOR, clrLimeGreen);
                            ObjectMove(0, TF + "SOURCE" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[h]), iLow(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, 1 + (HH[h] - LL[h]), iBars(SIMBA, TF) - HH[h])));
                            ObjectMove(0, TF + "SOURCE" + h, 1, INVALIDATIONsource, iHigh(SIMBA, TF, iBars(SIMBA, TF) - LL[h]));
                            if(iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h]) < EQUILIBRIUM(SIMBA, TF, HH[h - 1], LL[h - 1])) ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_COLOR, clrGold);
                            else ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_COLOR, clrTan);
                            int SOSSline = LL[h];
                            int REFINED = 0;
                            for(int g = iBars(SIMBA, TF) - LL[h]; g > iBars(SIMBA, TF) - BREAKER[h]; g--) {
                                if(iOpen(SIMBA, TF, g) < iHigh(SIMBA, TF, iBars(SIMBA, TF) - LL[h]) && iOpen(SIMBA, TF, g) > iClose(SIMBA, TF, g) && iOpen(SIMBA, TF, iBars(SIMBA, TF) - SOSSline) > iOpen(SIMBA, TF, g)) {
                                    SOSSline = iBars(SIMBA, TF) - g;
                                }
                            }
                            if(iClose(SIMBA, TF, iBars(SIMBA, TF) - LL[h]) > iOpen(SIMBA, TF, iBars(SIMBA, TF) - LL[h])) {
                                SOSSline = LL[h];
                                REFINED = 1;
                            }
                            if(SOSSline != LL[h] || REFINED == 1) {
                                ObjectMove(0, TF + "SOSline" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[h]), iOpen(SIMBA, TF, iBars(SIMBA, TF) - SOSSline));
                                ObjectMove(0, TF + "SOSline" + h, 1, INVALIDATIONsource, iOpen(SIMBA, TF, iBars(SIMBA, TF) - SOSSline));
                                ObjectSetInteger(0, TF + "SOSline" + h, OBJPROP_COLOR, clrWhite);
                                ObjectSetInteger(0, TF + "SOSline" + h, OBJPROP_STYLE, STYLE_DOT);
                            }
                            if(RTS[h] != -1) {
                                ObjectCreate(0, TF + "SOSmit" + h, OBJ_ARROW, 0, 0, 0, 0, 0);
                                ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_HIDDEN, true);
                                ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_ARROWCODE, 254); // Set the arrow code
                                ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_COLOR, clrGold); // Set the arrow code
                                ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_TIME, iTime(SIMBA, TF, iBars(SIMBA, TF) - RTS[h])); // Set time
                                if(FLOW[h] == 2)  {
                                    ObjectSetDouble(0, TF + "SOSmit" + h, OBJPROP_PRICE, iLow(SIMBA, TF, (iBars(SIMBA, TF) - HH[h])));
                                    ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_ANCHOR, ANCHOR_BOTTOM);
                                }
                                if(FLOW[h] == 1)  {
                                    ObjectSetDouble(0, TF + "SOSmit" + h, OBJPROP_PRICE, iHigh(SIMBA, TF, (iBars(SIMBA, TF) - LL[h])));
                                    ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_ANCHOR, ANCHOR_TOP);
                                }
                            }
                            if(h == A) {
                                ObjectMove(0, TF + "OBresp" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]));
                                ObjectMove(0, TF + "OBresp" + h, 1, INVALIDATIONB, iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]));
                                CREATETEXTPRICEprice(TF + "OBresptext" + h, "CHoCH " + tftransformation(TF), iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]), clrYellow, ANCHOR_LEFT_LOWER);
                                ObjectSetInteger(0, TF + "OBresp" + h, OBJPROP_COLOR, clrYellow);
                            }
                            else {
                                ObjectMove(0, TF + "OBresp" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]));
                                ObjectMove(0, TF + "OBresp" + h, 1, INVALIDATIONB, iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]));
                                if(iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h]) < EQUILIBRIUM(SIMBA, TF, HH[h - 1], LL[h - 1])) CREATETEXTPRICEprice(TF + "OBresptext" + h, "BOS " + tftransformation(TF), iTime(SIMBA, TF, iBars(SIMBA, TF) - BREAKER[h]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]), clrLimeGreen, ANCHOR_RIGHT_LOWER);
                                else CREATETEXTPRICEprice(TF + "OBresptext" + h, "Minor BOS " + tftransformation(TF), iTime(SIMBA, TF, iBars(SIMBA, TF) - BREAKER[h]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]), clrLimeGreen, ANCHOR_RIGHT_LOWER);
                                ObjectSetInteger(0, TF + "OBresp" + h, OBJPROP_COLOR, clrLimeGreen);
                            }
                        }
                        if(LAST_FLOW == 2) {
                            ObjectMove(0, TF + "OBR" + h, 0, iTime(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, 1 + (LL[h] - HH[h]), iBars(SIMBA, TF) - LL[h])), iHigh(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, 1 + (LL[h] - HH[h]), iBars(SIMBA, TF) - LL[h])));
//ObjectMove(0,TF+"OBR"+h,0,iTime(SIMBA,TF,iBars(SIMBA,TF)-HH[h]),iHigh(SIMBA,TF,iBars(SIMBA,TF)-HH[h]));
                            ObjectMove(0, TF + "OBR" + h, 1, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[h]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h]));
                            ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_COLOR, clrCoral);
                            ObjectMove(0, TF + "SOURCE" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[h]), iHigh(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, 1 + (LL[h] - HH[h]), iBars(SIMBA, TF) - LL[h])));
                            ObjectMove(0, TF + "SOURCE" + h, 1, INVALIDATIONsource, iLow(SIMBA, TF, iBars(SIMBA, TF) - HH[h]));
                            if(iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h]) > EQUILIBRIUM(SIMBA, TF, HH[h - 1], LL[h - 1])) ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_COLOR, clrGold);
                            else ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_COLOR, clrTan);
                            int SOSSline = HH[h];
                            int REFINED = 0;
                            for(int g = iBars(SIMBA, TF) - HH[h]; g > iBars(SIMBA, TF) - BREAKER[h]; g--) {
                                if(iOpen(SIMBA, TF, g) > iLow(SIMBA, TF, iBars(SIMBA, TF) - HH[h]) && iOpen(SIMBA, TF, g) < iClose(SIMBA, TF, g) && iOpen(SIMBA, TF, iBars(SIMBA, TF) - SOSSline) < iOpen(SIMBA, TF, g)) {
                                    SOSSline = iBars(SIMBA, TF) - g;
                                }
                            }
                            if(iClose(SIMBA, TF, iBars(SIMBA, TF) - HH[h]) < iOpen(SIMBA, TF, iBars(SIMBA, TF) - HH[h])) {
                                SOSSline = HH[h];
                                REFINED = 1;
                            }
                            if(SOSSline != HH[h] || REFINED == 1) {
                                ObjectMove(0, TF + "SOSline" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[h]), iOpen(SIMBA, TF, iBars(SIMBA, TF) - SOSSline));
                                ObjectMove(0, TF + "SOSline" + h, 1, INVALIDATIONsource, iOpen(SIMBA, TF, iBars(SIMBA, TF) - SOSSline));
                                ObjectSetInteger(0, TF + "SOSline" + h, OBJPROP_COLOR, clrWhite);
                                ObjectSetInteger(0, TF + "SOSline" + h, OBJPROP_STYLE, STYLE_DOT);
                            }
                            if(RTS[h] != -1) {
                                ObjectCreate(0, TF + "SOSmit" + h, OBJ_ARROW, 0, 0, 0, 0, 0);
                                ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_HIDDEN, true);
                                ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_ARROWCODE, 254); // Set the arrow code
                                ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_COLOR, clrGold); // Set the arrow code
                                ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_TIME, iTime(SIMBA, TF, iBars(SIMBA, TF) - RTS[h])); // Set time
                                if(FLOW[h] == 2)  {
                                    ObjectSetDouble(0, TF + "SOSmit" + h, OBJPROP_PRICE, iLow(SIMBA, TF, (iBars(SIMBA, TF) - HH[h])));
                                    ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_ANCHOR, ANCHOR_BOTTOM);
                                }
                                if(FLOW[h] == 1)  {
                                    ObjectSetDouble(0, TF + "SOSmit" + h, OBJPROP_PRICE, iHigh(SIMBA, TF, (iBars(SIMBA, TF) - LL[h])));
                                    ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_ANCHOR, ANCHOR_TOP);
                                }
                            }
                            if(h == A) {
                                ObjectMove(0, TF + "OBresp" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]));
                                ObjectMove(0, TF + "OBresp" + h, 1, INVALIDATIONB, iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]));
                                CREATETEXTPRICEprice(TF + "OBresptext" + h, "CHoCH " + tftransformation(TF), iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]), clrYellow, ANCHOR_LEFT_UPPER);
                                ObjectSetInteger(0, TF + "OBresp" + h, OBJPROP_COLOR, clrYellow);
                            }
                            else {
                                ObjectMove(0, TF + "OBresp" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]));
                                ObjectMove(0, TF + "OBresp" + h, 1, INVALIDATIONB, iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]));
                                if(iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h]) > EQUILIBRIUM(SIMBA, TF, HH[h - 1], LL[h - 1])) CREATETEXTPRICEprice(TF + "OBresptext" + h, "BOS " + tftransformation(TF), iTime(SIMBA, TF, iBars(SIMBA, TF) - BREAKER[h]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]), clrCoral, ANCHOR_RIGHT_UPPER);
                                else CREATETEXTPRICEprice(TF + "OBresptext" + h, "Minor BOS " + tftransformation(TF), iTime(SIMBA, TF, iBars(SIMBA, TF) - BREAKER[h]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]), clrCoral, ANCHOR_RIGHT_UPPER);
                                ObjectSetInteger(0, TF + "OBresp" + h, OBJPROP_COLOR, clrCoral);
                            }
                        }
                    }
                }
                if(STRA0 == 0) {
                    for(int h = 0; h < A; h++) {
                        if(STRA0_MANUAL == 1) continue;
                        if(DASHBOARD == false && SEE_LEGS == true) ObjectCreate(0, TF + "OBR" + h, OBJ_TREND, 0, 0, 0, 0, 0);
                        ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_RAY, false);
                        ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_WIDTH, 1);
                        ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_HIDDEN, true);
                        if(FLOW[h] == 1) {
                            ObjectMove(0, TF + "OBR" + h, 0, iTime(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, 1 + (HH[h] - LL[h]), iBars(SIMBA, TF) - HH[h])), iLow(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, 1 + (HH[h] - LL[h]), iBars(SIMBA, TF) - HH[h])));
//ObjectMove(0,TF+"OBR"+h,0,iTime(SIMBA,TF,iBars(SIMBA,TF)-LL[h]),iLow(SIMBA,TF,iBars(SIMBA,TF)-LL[h]));
                            ObjectMove(0, TF + "OBR" + h, 1, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[h]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h]));
                            ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_COLOR, clrLimeGreen);
                        }
                        if(FLOW[h] == 2) {
                            ObjectMove(0, TF + "OBR" + h, 0, iTime(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, 1 + (LL[h] - HH[h]), iBars(SIMBA, TF) - LL[h])), iHigh(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, 1 + (LL[h] - HH[h]), iBars(SIMBA, TF) - LL[h])));
//ObjectMove(0,TF+"OBR"+h,0,iTime(SIMBA,TF,iBars(SIMBA,TF)-HH[h]),iHigh(SIMBA,TF,iBars(SIMBA,TF)-HH[h]));
                            ObjectMove(0, TF + "OBR" + h, 1, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[h]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h]));
                            ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_COLOR, clrCoral);
                        }
                    }
                }
                break;
            }
        }
    }
    LAST_HH_OLD = 0;
    LAST_LL_OLD = 0;
    LAST_HH_SUPPLY_index = 0;
    LAST_LL_DEMAND_index = 0;
    LAST_REV_index = 0;
    int howmany = - 1;
    int temp_flow = 0;
    int counterfirst[];
    for(int g = ArraySize(FLOW) - 1; g > 0; g--) {
        if(temp_flow == 0) {
            ArrayResize(counterfirst, ArraySize(counterfirst) + 1);
            counterfirst[ArraySize(counterfirst) - 1] = counterfirst[ArraySize(counterfirst) - 1] + 1;
            temp_flow = FLOW[g];
            continue;
        }
        if(temp_flow == FLOW[g]) {
            counterfirst[ArraySize(counterfirst) - 1] = counterfirst[ArraySize(counterfirst) - 1] + 1;
            continue;
        }
        if(temp_flow != FLOW[g]) {
            temp_flow = FLOW[g];
            howmany = howmany + 1;
            ArrayResize(counterfirst, ArraySize(counterfirst) + 1);
            counterfirst[ArraySize(counterfirst) - 1] = counterfirst[ArraySize(counterfirst) - 1] + 1;
            continue;
        }
    }
    howmany = howmany - 1;
    if(STRA0_MANUAL == 1) howmany = 0;
    if(STRA0 == 1) howmany = 0;
    int lastflower = LAST_FLOW;
    int lastsourcer = LAST_SOURCE_A;
    int ALLSTRU = DEBUGMODE;
    int firstst = 0;
    int secondst = 0;
    for(int x = 0; x < howmany; x++) {
        if(STRA5 == 0 && x == 0 && counterfirst[x] > 1) break;
        if(STRA5 == 0 && x != 0 && counterfirst[x] > 1) break;
        if(ALLSTRU == false) {
            if(firstst == 1) secondst = 1;;
            if(firstst == 0 && counterfirst[x] > 1) {
                firstst = 1;
            }
        }
        if(lastflower == 1) {
            int A = 0;
            for(int h = lastsourcer; h >= 0; h--) {
                if(FLOW[h] != FLOW[h - 1] && FLOW[h] == 2) {
                    A = h;
                    break;
                }
            }
            for(int h = A; h <= ArraySize(FLOW) - 1; h++) {
                if(FLOW[h] == 1) break;
                if(secondst == 1) {
                    if(LAST_FLOW == 1 && iClose(SIMBA, TF, iBars(SIMBA, TF) - LAST_HH) > iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h])) {
                        lastflower = FLOW[h];
                        lastsourcer = h;
                        continue;
                    }
                    if(LAST_FLOW == 2 && iClose(SIMBA, TF, iBars(SIMBA, TF) - LAST_LL) < iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h])) {
                        lastflower = FLOW[h];
                        lastsourcer = h;
                        continue;
                    }
                }
// LEGS
                if(DRAWYN != 0 && SEE_LEGS == true) ObjectCreate(0, TF + "OBR" + h, OBJ_TREND, 0, 0, 0, 0, 0);
                ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_RAY, false);
                ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_WIDTH, 1);
                ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_HIDDEN, true);
// END LEGS
// SOURCES
                if(SOURCEinv[h] == 0) {
                    if(DRAWYN != 0) ObjectCreate(0, TF + "SOURCE" + h, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                }
                if(RTS[h] == -1) {
                    ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_STYLE, STYLE_SOLID);
                    ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_WIDTH, 3);
                }
                else {
                    ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_STYLE, STYLE_DASH);
                    ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_WIDTH, 1);
                }
                ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_BACK, false);
                ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_HIDDEN, true);
// END SOURCES
//SOURCES refined
                if(SOURCEinv[h] == 0) {
                    if(DRAWYN != 0) ObjectCreate(0, TF + "SOSline" + h, OBJ_TREND, 0, 0, 0, 0, 0);
                }
                ObjectSetInteger(0, TF + "SOSline" + h, OBJPROP_RAY, false);
//END SOURCES refined
// CHOCH / BOS / LSB SIGNATURE
                if(DRAWYN != 0) ObjectCreate(0, TF + "OBresp" + h, OBJ_TREND, 0, 0, 0, 0, 0);
                ObjectSetInteger(0, TF + "OBresp" + h, OBJPROP_RAY, false);
                ObjectSetInteger(0, TF + "OBresp" + h, OBJPROP_HIDDEN, true);
// END CHOCH ..
// OB
                if(RTO[h] == -1) ObjectSetInteger(0, TF + "OBPOI" + h, OBJPROP_BACK, true);
                else ObjectSetInteger(0, TF + "OBPOI" + h, OBJPROP_BACK, false);
                ObjectSetInteger(0, TF + "OBPOI" + h, OBJPROP_WIDTH, 1);
                ObjectSetInteger(0, TF + "OBPOI" + h, OBJPROP_HIDDEN, true);
// END OB
                ObjectSetInteger(0, TF + "SOBline" + h, OBJPROP_RAY, false);
                ObjectSetInteger(0, TF + "SOBline" + h, OBJPROP_HIDDEN, true);
// END OB refined
                if(SOURCEinv[h] == 0) INVALIDATIONsource = iTime(SIMBA, TF, CURRCANDX) + 60 * TF;
                else INVALIDATIONsource = iTime(SIMBA, TF, iBars(SIMBA, TF) - SOURCEinv[h]);
                datetime INVALIDATIONB = iTime(SIMBA, TF, iBars(SIMBA, TF) - BREAKER[h]);
                ObjectMove(0, TF + "OBR" + h, 0, iTime(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, 1 + (LL[h] - HH[h]), iBars(SIMBA, TF) - LL[h])), iHigh(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, 1 + (LL[h] - HH[h]), iBars(SIMBA, TF) - LL[h])));
//ObjectMove(0,TF+"OBR"+h,0,iTime(SIMBA,TF,iBars(SIMBA,TF)-HH[h]),iHigh(SIMBA,TF,iBars(SIMBA,TF)-HH[h]));
                ObjectMove(0, TF + "OBR" + h, 1, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[h]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h]));
                ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_COLOR, clrCoral);
                ObjectMove(0, TF + "SOURCE" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[h]), iHigh(SIMBA, TF, iHighest(SIMBA, TF, MODE_HIGH, 1 + (LL[h] - HH[h]), iBars(SIMBA, TF) - LL[h])));
                ObjectMove(0, TF + "SOURCE" + h, 1, INVALIDATIONsource, iLow(SIMBA, TF, iBars(SIMBA, TF) - HH[h]));
                if(iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h]) > EQUILIBRIUM(SIMBA, TF, HH[h - 1], LL[h - 1])) ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_COLOR, clrGold);
                else ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_COLOR, clrTan);
                int SOSSline = HH[h];
                int REFINED = 0;
                for(int g = iBars(SIMBA, TF) - HH[h]; g > iBars(SIMBA, TF) - BREAKER[h]; g--) {
                    if(iOpen(SIMBA, TF, g) > iLow(SIMBA, TF, iBars(SIMBA, TF) - HH[h]) && iOpen(SIMBA, TF, g) < iClose(SIMBA, TF, g) && iOpen(SIMBA, TF, iBars(SIMBA, TF) - SOSSline) < iOpen(SIMBA, TF, g)) {
                        SOSSline = iBars(SIMBA, TF) - g;
                    }
                }
                if(iClose(SIMBA, TF, iBars(SIMBA, TF) - HH[h]) < iOpen(SIMBA, TF, iBars(SIMBA, TF) - HH[h])) {
                    SOSSline = HH[h];
                    REFINED = 1;
                }
                if(SOSSline != HH[h] || REFINED == 1) {
                    ObjectMove(0, TF + "SOSline" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[h]), iOpen(SIMBA, TF, iBars(SIMBA, TF) - SOSSline));
                    ObjectMove(0, TF + "SOSline" + h, 1, INVALIDATIONsource, iOpen(SIMBA, TF, iBars(SIMBA, TF) - SOSSline));
                    ObjectSetInteger(0, TF + "SOSline" + h, OBJPROP_COLOR, clrWhite);
                    ObjectSetInteger(0, TF + "SOSline" + h, OBJPROP_STYLE, STYLE_DOT);
                }
                if(RTS[h] != -1 && SOURCEinv[h] == 0) {
                    if(DRAWYN != 0) ObjectCreate(0, TF + "SOSmit" + h, OBJ_ARROW, 0, 0, 0, 0, 0);
                    ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_HIDDEN, true);
                    ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_ARROWCODE, 254); // Set the arrow code
                    ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_COLOR, clrGold); // Set the arrow code
                    ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_TIME, iTime(SIMBA, TF, iBars(SIMBA, TF) - RTS[h])); // Set time
                    if(FLOW[h] == 2)  {
                        ObjectSetDouble(0, TF + "SOSmit" + h, OBJPROP_PRICE, iLow(SIMBA, TF, (iBars(SIMBA, TF) - HH[h])));
                        ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_ANCHOR, ANCHOR_BOTTOM);
                    }
                    if(FLOW[h] == 1)  {
                        ObjectSetDouble(0, TF + "SOSmit" + h, OBJPROP_PRICE, iHigh(SIMBA, TF, (iBars(SIMBA, TF) - LL[h])));
                        ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_ANCHOR, ANCHOR_TOP);
                    }
                }
                if(h == A) {
                    ObjectMove(0, TF + "OBresp" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]));
                    ObjectMove(0, TF + "OBresp" + h, 1, INVALIDATIONB, iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]));
                    if(DRAWYN != 0) CREATETEXTPRICEprice(TF + "OBresptext" + h, "CHoCH " + tftransformation(TF), iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]), clrYellow, ANCHOR_LEFT_UPPER);
                    ObjectSetInteger(0, TF + "OBresp" + h, OBJPROP_COLOR, clrYellow);
                }
                else {
                    ObjectMove(0, TF + "OBresp" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]));
                    ObjectMove(0, TF + "OBresp" + h, 1, INVALIDATIONB, iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]));
                    if(DRAWYN != 0) {
                        if(iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h]) > EQUILIBRIUM(SIMBA, TF, HH[h - 1], LL[h - 1])) CREATETEXTPRICEprice(TF + "OBresptext" + h, "BOS " + tftransformation(TF), iTime(SIMBA, TF, iBars(SIMBA, TF) - BREAKER[h]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]), clrCoral, ANCHOR_RIGHT_UPPER);
                        else CREATETEXTPRICEprice(TF + "OBresptext" + h, "Minor BOS " + tftransformation(TF), iTime(SIMBA, TF, iBars(SIMBA, TF) - BREAKER[h]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h - 1]), clrCoral, ANCHOR_RIGHT_UPPER);
                    }
                    ObjectSetInteger(0, TF + "OBresp" + h, OBJPROP_COLOR, clrCoral);
                }
                if(ALLSTRU == false) {
                    if(LAST_FLOW == 1) {
                        if(LAST_REV_index == 0 || h > LAST_REV_index) {
                            if(iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h]) > iClose(SIMBA, TF, iHighest(SIMBA, TF, MODE_CLOSE, (LAST_HH - BMSbreak[h]), iBars(SIMBA, TF) - LAST_HH))) {
                                LAST_REV_index = h;
                                LAST_HH_SUPPLY = HH[h];
                                LAST_LL_DEMAND = LL[h];
                                LAST_BMSoppall = BMS[h];
                                x = howmany - 1;
                            }
                        }
                    }
                    if(LAST_FLOW == 2) {
                        if(LAST_REV_index == 0 || h > LAST_REV_index) {
                            if(iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h]) < iClose(SIMBA, TF, iLowest(SIMBA, TF, MODE_CLOSE, (LAST_LL - BMSbreak[h]), iBars(SIMBA, TF) - LAST_LL))) {
                                LAST_REV_index = h;
                                LAST_HH_SUPPLY = HH[h];
                                LAST_LL_DEMAND = LL[h];
                                LAST_BMSoppall = BMS[h];
                                x = howmany - 1;
                            }
                        }
                    }
                }
                lastflower = FLOW[h];
                lastsourcer = h;
            }
            continue;
        }
///////////////////
        if(lastflower == 2) {
            int A = 0;
            for(int h = lastsourcer; h >= 0; h--) {
                if(FLOW[h] != FLOW[h - 1] && FLOW[h] == 1) {
                    A = h;
                    break;
                }
            }
            for(int h = A; h <= ArraySize(FLOW) - 1; h++) {
                if(FLOW[h] == 2) break;
                if(secondst == 1) {
                    if(LAST_FLOW == 1 && iClose(SIMBA, TF, iBars(SIMBA, TF) - LAST_HH) > iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h])) {
                        lastflower = FLOW[h];
                        lastsourcer = h;
                        continue;
                    }
                    if(LAST_FLOW == 2 && iClose(SIMBA, TF, iBars(SIMBA, TF) - LAST_LL) < iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h])) {
                        lastflower = FLOW[h];
                        lastsourcer = h;
                        continue;
                    }
                }
// LEGS
                if(DRAWYN != 0 && SEE_LEGS == true) ObjectCreate(0, TF + "OBR" + h, OBJ_TREND, 0, 0, 0, 0, 0);
                ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_RAY, false);
                ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_WIDTH, 1);
                ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_HIDDEN, true);
// END LEGS
// SOURCES
                if(SOURCEinv[h] == 0) {
                    if(DRAWYN != 0) ObjectCreate(0, TF + "SOURCE" + h, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
                }
                if(RTS[h] == -1) {
                    ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_STYLE, STYLE_SOLID);
                    ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_WIDTH, 3);
                }
                else {
                    ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_STYLE, STYLE_DASH);
                    ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_WIDTH, 1);
                }
                ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_BACK, false);
                ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_HIDDEN, true);
// END SOURCES
//SOURCES refined
                if(SOURCEinv[h] == 0) {
                    if(DRAWYN != 0) ObjectCreate(0, TF + "SOSline" + h, OBJ_TREND, 0, 0, 0, 0, 0);
                }
                ObjectSetInteger(0, TF + "SOSline" + h, OBJPROP_RAY, false);
//END SOURCES refined
// CHOCH / BOS / LSB SIGNATURE
                if(DRAWYN != 0) ObjectCreate(0, TF + "OBresp" + h, OBJ_TREND, 0, 0, 0, 0, 0);
                ObjectSetInteger(0, TF + "OBresp" + h, OBJPROP_RAY, false);
                ObjectSetInteger(0, TF + "OBresp" + h, OBJPROP_HIDDEN, true);
// END CHOCH ..
                if(RTO[h] == -1) ObjectSetInteger(0, TF + "OBPOI" + h, OBJPROP_BACK, true);
                else ObjectSetInteger(0, TF + "OBPOI" + h, OBJPROP_BACK, false);
                ObjectSetInteger(0, TF + "OBPOI" + h, OBJPROP_WIDTH, 1);
                ObjectSetInteger(0, TF + "OBPOI" + h, OBJPROP_HIDDEN, true);
// END OB
                ObjectSetInteger(0, TF + "SOBline" + h, OBJPROP_RAY, false);
                ObjectSetInteger(0, TF + "SOBline" + h, OBJPROP_HIDDEN, true);
// END OB refined
                if(SOURCEinv[h] == 0) INVALIDATIONsource = iTime(SIMBA, TF, CURRCANDX) + 60 * TF;
                else INVALIDATIONsource = iTime(SIMBA, TF, iBars(SIMBA, TF) - SOURCEinv[h]);
                datetime INVALIDATIONB = iTime(SIMBA, TF, iBars(SIMBA, TF) - BREAKER[h]);
                ObjectMove(0, TF + "OBR" + h, 0, iTime(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, 1 + (HH[h] - LL[h]), iBars(SIMBA, TF) - HH[h])), iLow(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, 1 + (HH[h] - LL[h]), iBars(SIMBA, TF) - HH[h])));
//ObjectMove(0,TF+"OBR"+h,0,iTime(SIMBA,TF,iBars(SIMBA,TF)-LL[h]),iLow(SIMBA,TF,iBars(SIMBA,TF)-LL[h]));
                ObjectMove(0, TF + "OBR" + h, 1, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[h]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h]));
                ObjectSetInteger(0, TF + "OBR" + h, OBJPROP_COLOR, clrLimeGreen);
                ObjectMove(0, TF + "SOURCE" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[h]), iLow(SIMBA, TF, iLowest(SIMBA, TF, MODE_LOW, 1 + (HH[h] - LL[h]), iBars(SIMBA, TF) - HH[h])));
                ObjectMove(0, TF + "SOURCE" + h, 1, INVALIDATIONsource, iHigh(SIMBA, TF, iBars(SIMBA, TF) - LL[h]));
                if(iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h]) < EQUILIBRIUM(SIMBA, TF, HH[h - 1], LL[h - 1])) ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_COLOR, clrGold);
                else ObjectSetInteger(0, TF + "SOURCE" + h, OBJPROP_COLOR, clrTan);
                int SOSSline = LL[h];
                int REFINED = 0;
                for(int g = iBars(SIMBA, TF) - LL[h]; g > iBars(SIMBA, TF) - BREAKER[h]; g--) {
                    if(iOpen(SIMBA, TF, g) < iHigh(SIMBA, TF, iBars(SIMBA, TF) - LL[h]) && iOpen(SIMBA, TF, g) > iClose(SIMBA, TF, g) && iOpen(SIMBA, TF, iBars(SIMBA, TF) - SOSSline) > iOpen(SIMBA, TF, g)) {
                        SOSSline = iBars(SIMBA, TF) - g;
                    }
                }
                if(iClose(SIMBA, TF, iBars(SIMBA, TF) - LL[h]) > iOpen(SIMBA, TF, iBars(SIMBA, TF) - LL[h])) {
                    SOSSline = LL[h];
                    REFINED = 1;
                }
                if(SOSSline != LL[h] || REFINED == 1) {
                    ObjectMove(0, TF + "SOSline" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[h]), iOpen(SIMBA, TF, iBars(SIMBA, TF) - SOSSline));
                    ObjectMove(0, TF + "SOSline" + h, 1, INVALIDATIONsource, iOpen(SIMBA, TF, iBars(SIMBA, TF) - SOSSline));
                    ObjectSetInteger(0, TF + "SOSline" + h, OBJPROP_COLOR, clrWhite);
                    ObjectSetInteger(0, TF + "SOSline" + h, OBJPROP_STYLE, STYLE_DOT);
                }
                if(RTS[h] != -1 && SOURCEinv[h] == 0) {
                    if(DRAWYN != 0) ObjectCreate(0, TF + "SOSmit" + h, OBJ_ARROW, 0, 0, 0, 0, 0);
                    ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_HIDDEN, true);
                    ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_ARROWCODE, 254); // Set the arrow code
                    ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_COLOR, clrGold); // Set the arrow code
                    ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_TIME, iTime(SIMBA, TF, iBars(SIMBA, TF) - RTS[h])); // Set time
                    if(FLOW[h] == 2)  {
                        ObjectSetDouble(0, TF + "SOSmit" + h, OBJPROP_PRICE, iLow(SIMBA, TF, (iBars(SIMBA, TF) - HH[h])));
                        ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_ANCHOR, ANCHOR_BOTTOM);
                    }
                    if(FLOW[h] == 1)  {
                        ObjectSetDouble(0, TF + "SOSmit" + h, OBJPROP_PRICE, iHigh(SIMBA, TF, (iBars(SIMBA, TF) - LL[h])));
                        ObjectSetInteger(0, TF + "SOSmit" + h, OBJPROP_ANCHOR, ANCHOR_TOP);
                    }
                }
                if(h == A) {
                    ObjectMove(0, TF + "OBresp" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]));
                    ObjectMove(0, TF + "OBresp" + h, 1, INVALIDATIONB, iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]));
                    if(DRAWYN != 0) CREATETEXTPRICEprice(TF + "OBresptext" + h, "CHoCH " + tftransformation(TF), iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]), clrYellow, ANCHOR_LEFT_LOWER);
                    ObjectSetInteger(0, TF + "OBresp" + h, OBJPROP_COLOR, clrYellow);
                }
                else {
                    ObjectMove(0, TF + "OBresp" + h, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]));
                    ObjectMove(0, TF + "OBresp" + h, 1, INVALIDATIONB, iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]));
                    if(DRAWYN != 0) {
                        if(iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h]) < EQUILIBRIUM(SIMBA, TF, HH[h - 1], LL[h - 1])) CREATETEXTPRICEprice(TF + "OBresptext" + h, "BOS " + tftransformation(TF), iTime(SIMBA, TF, iBars(SIMBA, TF) - BREAKER[h]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]), clrLimeGreen, ANCHOR_RIGHT_LOWER);
                        else CREATETEXTPRICEprice(TF + "OBresptext" + h, "Minor BOS " + tftransformation(TF), iTime(SIMBA, TF, iBars(SIMBA, TF) - BREAKER[h]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h - 1]), clrLimeGreen, ANCHOR_RIGHT_LOWER);
                    }
                    ObjectSetInteger(0, TF + "OBresp" + h, OBJPROP_COLOR, clrLimeGreen);
                }
                if(ALLSTRU == false) {
                    if(LAST_FLOW == 1) {
                        if(LAST_REV_index == 0 || h > LAST_REV_index) {
                            if(iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[h]) > iClose(SIMBA, TF, iHighest(SIMBA, TF, MODE_CLOSE, (LAST_HH - BMSbreak[h]), iBars(SIMBA, TF) - LAST_HH))) {
                                LAST_REV_index = h;
                                LAST_HH_SUPPLY = HH[h];
                                LAST_LL_DEMAND = LL[h];
                                LAST_BMSoppall = BMS[h];
                                x = howmany - 1;
                            }
                        }
                    }
                    if(LAST_FLOW == 2) {
                        if(LAST_REV_index == 0 || h > LAST_REV_index) {
                            if(iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[h]) < iClose(SIMBA, TF, iLowest(SIMBA, TF, MODE_CLOSE, (LAST_LL - BMSbreak[h]), iBars(SIMBA, TF) - LAST_LL))) {
                                LAST_REV_index = h;
                                LAST_HH_SUPPLY = HH[h];
                                LAST_LL_DEMAND = LL[h];
                                LAST_BMSoppall = BMS[h];
                                x = howmany - 1;
                            }
                        }
                    }
                }
                lastflower = FLOW[h];
                lastsourcer = h;
            }
            continue;
        }
    }
    LAST_RTO_CHECK = RTO[LAST_REV_index];
    LAST_RTS_CHECK = RTS[LAST_REV_index];
    LAST_BMSall = BMSall[ArraySize(BMSall) - 1];
    LAST_TF = TF;
    if(DRAWYN != 0 && 1 == 2) {
        if(LAST_LEG0flow > 1) {
            if(FLOW[ArraySize(FLOW) - 1] == 1) {
                double AO_current = iAO(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]);
                double AO_previous = iAO(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 2]);
                if(AO_current < AO_previous) {
                    ObjectCreate(0, TF + "SDIV", OBJ_TREND, 0, 0, 0, 0, 0);
                    ObjectSetInteger(0, TF + "SDIV", OBJPROP_HIDDEN, true);
                    ObjectSetInteger(0, TF + "SDIV", OBJPROP_RAY, false);
                    ObjectSetInteger(0, TF + "SDIV", OBJPROP_WIDTH, 1);
                    ObjectSetInteger(0, TF + "SDIV", OBJPROP_COLOR, clrMagenta);
                    ObjectMove(0, TF + "SDIV", 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 2]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 2]));
                    ObjectMove(0, TF + "SDIV", 1, iTime(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]));
                }
                else ObjectDelete(0, TF + "SDIV");
            }
            if(FLOW[ArraySize(FLOW) - 1] == 2) {
                double AO_current = iAO(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1]);
                double AO_previous = iAO(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 2]);
                if(AO_current > AO_previous) {
                    if(DRAWYN != 0) ObjectCreate(0, TF + "SDIV", OBJ_TREND, 0, 0, 0, 0, 0);
                    ObjectSetInteger(0, TF + "SDIV", OBJPROP_HIDDEN, true);
                    ObjectSetInteger(0, TF + "SDIV", OBJPROP_RAY, false);
                    ObjectSetInteger(0, TF + "SDIV", OBJPROP_WIDTH, 1);
                    ObjectSetInteger(0, TF + "SDIV", OBJPROP_COLOR, clrAqua);
                    ObjectMove(0, TF + "SDIV", 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 2]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 2]));
                    ObjectMove(0, TF + "SDIV", 1, iTime(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1]), iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1]));
                }
                else ObjectDelete(0, TF + "SDIV");
            }
        }
        else ObjectDelete(0, TF + "SDIV");
    }
    if(INTERNAL_STRUCTURE == true) {
        int val000 = LSBfunc(SIMBA, TF, HH[ArraySize(HH) - 1], LL[ArraySize(LL) - 1], FLOW[ArraySize(FLOW) - 1], BMS[ArraySize(BMS) - 1], BMSbreak[ArraySize(BMSbreak) - 1], 0, CURRCANDX, "OBLAST");
        if(DASHBOARD == false) {
            int val111 = LSBfunc(SIMBA, TF, HH[ArraySize(HH) - 1], LL[ArraySize(LL) - 1], FLOW[ArraySize(FLOW) - 1], BMS[ArraySize(BMS) - 1], BMSbreak[ArraySize(BMSbreak) - 1], 1, CURRCANDX, "OBLASTOPP");
        }
    }
    VEDIFIBO(Symbol(), LAST_TF, STRA1, LAST_LL, LAST_HH, LAST_FLOW);
    return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ORDERBLOCKshowliq(string SIMBA, int TF, int CURRCANDX, int DRAWYN, int LSBYES, int DELETE, int LQshow, int FVGshow)
{
    int LUNGA = StringLen(TF) + 4;
    int totalObjects = ObjectsTotal(0, 0, -1);
    for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
        if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "XLIQ")  ObjectDelete(ObjectName(i));
    }
    if(LQshow == 0) {
        totalObjects = ObjectsTotal(0, 0, -1);
        for(int i = totalObjects - 1 ;  i >= 0 ;  i--) {
            if(StringSubstr(ObjectName(i), 0, LUNGA) == TF + "XLIQ")  ObjectDelete(ObjectName(i));
        }
        return(0);
    }
    ChartSetInteger(0, CHART_FOREGROUND, 0);
    int CANDLE;
    double BMSall[];
    double BMSallnature[];
    double BMS[];
    double HH[];
    double LL[];
    double FLOW[];
    double OBresp[];
    double BREAKER[];
    double RTO[];
    double RTOall[];
    double RTS[];
    double FVG[];
    double FVGnat[];
    double INVALID[];
    int MAXCAND = 0;
    switch(TF) {
    case 1 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 10)));
        break;
    case 5 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 50)));
        break;
    case 15 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 100)));
        break;
    case 30 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 200)));
        break;
    case 60 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 365)));
        break;
    case 240 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_D1, 365)));
        break;
    case 1440 :
        MAXCAND = MathMin(iBars(SIMBA, TF) - 50, iBarShift(SIMBA, TF, iTime(SIMBA, PERIOD_MN1, 48)));
        break;
    case PERIOD_W1 :
        MAXCAND = iBars(SIMBA, TF) - 50;
        break;
    case PERIOD_MN1 :
        MAXCAND = iBars(SIMBA, TF) - 50;
        break;
    }
    int LOADINGlevel = 0;
    if(TF == PERIOD_M1) {
        CANDLE = M1CANDLE;
        ArrayCopy(BMSall, M1BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, M1BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, M1BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, M1HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, M1LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, M1FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, M1OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, M1BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, M1RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, M1RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, M1RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, M1FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, M1FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, M1INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_M5) {
        CANDLE = M5CANDLE;
        ArrayCopy(BMSall, M5BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, M5BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, M5BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, M5HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, M5LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, M5FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, M5OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, M5BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, M5RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, M5RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, M5RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, M5FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, M5FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, M5INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_M15) {
        CANDLE = M15CANDLE;
        ArrayCopy(BMSall, M15BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, M15BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, M15BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, M15HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, M15LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, M15FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, M15OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, M15BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, M15RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, M15RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, M15RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, M15FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, M15FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, M15INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_M30) {
        CANDLE = M30CANDLE;
        ArrayCopy(BMSall, M30BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, M30BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, M30BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, M30HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, M30LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, M30FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, M30OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, M30BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, M30RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, M30RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, M30RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, M30FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, M30FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, M30INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_H1) {
        CANDLE = H1CANDLE;
        ArrayCopy(BMSall, H1BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, H1BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, H1BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, H1HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, H1LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, H1FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, H1OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, H1BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, H1RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, H1RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, H1RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, H1FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, H1FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, H1INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_H4) {
        CANDLE = H4CANDLE;
        ArrayCopy(BMSall, H4BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, H4BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, H4BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, H4HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, H4LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, H4FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, H4OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, H4BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, H4RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, H4RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, H4RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, H4FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, H4FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, H4INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_D1) {
        CANDLE = D1CANDLE;
        ArrayCopy(BMSall, D1BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, D1BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, D1BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, D1HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, D1LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, D1FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, D1OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, D1BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, D1RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, D1RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, D1RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, D1FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, D1FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, D1INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_W1) {
        CANDLE = W1CANDLE;
        ArrayCopy(BMSall, W1BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, W1BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, W1BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, W1HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, W1LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, W1FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, W1OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, W1BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, W1RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, W1RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, W1RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, W1FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, W1FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, W1INVALID, 0, 0, WHOLE_ARRAY);
    }
    if(TF == PERIOD_MN1) {
        CANDLE = MN1CANDLE;
        ArrayCopy(BMSall, MN1BMSall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMSallnature, MN1BMSallnature, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BMS, MN1BMS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(HH, MN1HH, 0, 0, WHOLE_ARRAY);
        ArrayCopy(LL, MN1LL, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FLOW, MN1FLOW, 0, 0, WHOLE_ARRAY);
        ArrayCopy(OBresp, MN1OBresp, 0, 0, WHOLE_ARRAY);
        ArrayCopy(BREAKER, MN1BREAKER, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTO, MN1RTO, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTOall, MN1RTOall, 0, 0, WHOLE_ARRAY);
        ArrayCopy(RTS, MN1RTS, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVG, MN1FVG, 0, 0, WHOLE_ARRAY);
        ArrayCopy(FVGnat, MN1FVGnat, 0, 0, WHOLE_ARRAY);
        ArrayCopy(INVALID, MN1INVALID, 0, 0, WHOLE_ARRAY);
    }
// LIQUIDITY
    int START = MathMax(LL[ArraySize(LL) - 1], HH[ArraySize(HH) - 1]);
    int END = MathMin(LL[ArraySize(LL) - 1], HH[ArraySize(HH) - 1]);
    double INTFLOW[1];
    double INTHH[1];
    double INTLL[1];
    double INTEQ[1];
    double MITIGATO[1];
    int QUANT = 0;
    for(int g = ArraySize(FLOW) - 2; g > 0; g--) {
        if(FLOW[ArraySize(FLOW) - 1] == 1 && iClose(SIMBA, TF, iBars(SIMBA, TF) - HH[ArraySize(HH) - 1]) < iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[g])) {
            QUANT = g;
            break;
        }
        if(FLOW[ArraySize(FLOW) - 1] == 2 && iClose(SIMBA, TF, iBars(SIMBA, TF) - LL[ArraySize(LL) - 1]) > iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[g])) {
            QUANT = g;
            break;
        }
    }
    if(QUANT == 0) QUANT = ArraySize(FLOW) - 2;
    for(int s = QUANT; s > 1; s--) {
        if(FLOW[s] != FLOW[s + 1]) {
            QUANT = s + 1;
            break;
        }
    }
    INTFLOW[0] = FLOW[QUANT];
    INTHH[0] = HH[QUANT];
    INTLL[0] = LL[QUANT];
    INTEQ[0] = (iHigh(SIMBA, TF, iBars(SIMBA, TF) - HH[QUANT]) + iLow(SIMBA, TF, iBars(SIMBA, TF) - LL[QUANT])) / 2;
    MITIGATO[0] = -1;
    START = MathMax(LL[QUANT], HH[QUANT]);
    END = MathMin(LL[QUANT], HH[QUANT]);
    for(int j = iBars(SIMBA, TF) - START; j > CURRCANDX; j--) {
        if(INTFLOW[ArraySize(INTFLOW) - 1] == 1) {
            if(iClose(SIMBA, TF, j) < iLow(SIMBA, TF, j + 1)) {
                ArrayResize(INTFLOW, ArraySize(INTFLOW) + 1);
                ArrayResize(INTHH, ArraySize(INTHH) + 1);
                ArrayResize(INTLL, ArraySize(INTLL) + 1);
                ArrayResize(INTEQ, ArraySize(INTEQ) + 1);
                ArrayResize(MITIGATO, ArraySize(MITIGATO) + 1);
                MITIGATO[ArraySize(MITIGATO) - 1] = -1;
                INTFLOW[ArraySize(INTFLOW) - 1] = 2;
                INTHH[ArraySize(INTHH) - 1] = iBars(SIMBA, TF) - iHighest(SIMBA, TF, MODE_HIGH, 1 + (iBars(SIMBA, TF) - INTHH[ArraySize(INTHH) - 2]) - j, j);
                INTLL[ArraySize(INTLL) - 1] = iBars(SIMBA, TF) - j;
                INTEQ[ArraySize(INTEQ) - 1] = (iHigh(SIMBA, TF, iBars(SIMBA, TF) - INTHH[ArraySize(INTHH) - 1]) + iLow(SIMBA, TF, iBars(SIMBA, TF) - INTLL[ArraySize(INTLL) - 1])) / 2;
                continue;
            }
            else if(iHigh(SIMBA, TF, j) > iHigh(SIMBA, TF, iBars(SIMBA, TF) - INTHH[ArraySize(INTHH) - 1])) {
                INTHH[ArraySize(INTHH) - 1] = iBars(SIMBA, TF) - j;
                INTEQ[ArraySize(INTEQ) - 1] = (iHigh(SIMBA, TF, iBars(SIMBA, TF) - INTHH[ArraySize(INTHH) - 1]) + iLow(SIMBA, TF, iBars(SIMBA, TF) - INTLL[ArraySize(INTLL) - 1])) / 2;
                continue;
            }
        }
        if(INTFLOW[ArraySize(INTFLOW) - 1] == 2) {
            if(iClose(SIMBA, TF, j) > iHigh(SIMBA, TF, j + 1)) {
                ArrayResize(INTFLOW, ArraySize(INTFLOW) + 1);
                ArrayResize(INTHH, ArraySize(INTHH) + 1);
                ArrayResize(INTLL, ArraySize(INTLL) + 1);
                ArrayResize(INTEQ, ArraySize(INTEQ) + 1);
                ArrayResize(MITIGATO, ArraySize(MITIGATO) + 1);
                MITIGATO[ArraySize(MITIGATO) - 1] = -1;
                INTFLOW[ArraySize(INTFLOW) - 1] = 1;
                INTLL[ArraySize(INTLL) - 1] = iBars(SIMBA, TF) - iLowest(SIMBA, TF, MODE_LOW, 1 + (iBars(SIMBA, TF) - INTLL[ArraySize(INTLL) - 2]) - j, j);
                INTHH[ArraySize(INTHH) - 1] = iBars(SIMBA, TF) - j;
                INTEQ[ArraySize(INTEQ) - 1] = (iHigh(SIMBA, TF, iBars(SIMBA, TF) - INTHH[ArraySize(INTHH) - 1]) + iLow(SIMBA, TF, iBars(SIMBA, TF) - INTLL[ArraySize(INTLL) - 1])) / 2;
                continue;
            }
            else if(iLow(SIMBA, TF, j) < iLow(SIMBA, TF, iBars(SIMBA, TF) - INTLL[ArraySize(INTLL) - 1])) {
                INTLL[ArraySize(INTLL) - 1] = iBars(SIMBA, TF) - j;
                INTEQ[ArraySize(INTEQ) - 1] = (iHigh(SIMBA, TF, iBars(SIMBA, TF) - INTHH[ArraySize(INTHH) - 1]) + iLow(SIMBA, TF, iBars(SIMBA, TF) - INTLL[ArraySize(INTLL) - 1])) / 2;
                continue;
            }
        }
    }
    for(int j = 0; j < ArraySize(MITIGATO); j++) {
        if(INTFLOW[j] == 1) {
            for(int k = (iBars(SIMBA, TF) - INTHH[j]) - 1; k > CURRCANDX; k--) {
                if(iLow(SIMBA, TF, k) <= INTEQ[j]) {
                    MITIGATO[j] = iBars(SIMBA, TF) - k;
                    break;
                }
            }
        }
        if(INTFLOW[j] == 2) {
            for(int k = (iBars(SIMBA, TF) - INTLL[j]) - 1; k > CURRCANDX; k--) {
                if(iHigh(SIMBA, TF, k) >= INTEQ[j]) {
                    MITIGATO[j] = iBars(SIMBA, TF) - k;
                    break;
                }
            }
        }
    }
    if(DASHBOARD == true) DRAWYN = 0;
    for(int i = 1; i < ArraySize(INTFLOW); i++) {
        datetime INVLIQ = iTime(SIMBA, 0, 1) + PeriodSeconds(); //60*60*PeriodSeconds(TF);
        if(CURRCANDX != 0) INVLIQ = iTime(SIMBA, TF, CURRCANDX);
        int LIQtaken = 0;
        if(INTFLOW[i] == 1) {
            for(int k = (iBars(SIMBA, TF) - INTLL[i]) - 1; k > CURRCANDX; k--) {
                if(iLow(SIMBA, TF, k) <= iLow(SIMBA, TF, iBars(SIMBA, TF) - INTLL[i])) {
                    LIQtaken = iBars(SIMBA, TF) - k;
                    INVLIQ = 0;
                    break;
                }
            }
            datetime MITO = iTime(SIMBA, TF, CURRCANDX) + 60 * Period();
            if(MITIGATO[i] != -1) MITO = iTime(SIMBA, TF, iBars(SIMBA, TF) - MITIGATO[i]);
            if(DRAWYN == true) ObjectCreate(0, TF + "XLIQUIDITYLinternal" + i, OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectMove(0, TF + "XLIQUIDITYLinternal" + i, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - INTLL[i]), iLow(SIMBA, TF, iBars(SIMBA, TF) - INTLL[i]));
            ObjectMove(0, TF + "XLIQUIDITYLinternal" + i, 1, iTime(SIMBA, TF, iBars(SIMBA, TF) - INTHH[i]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - INTHH[i]));
            ObjectSetInteger(0, TF + "XLIQUIDITYLinternal" + i, OBJPROP_RAY, false);
            if(MITIGATO[i] == -1) ObjectSetInteger(0, TF + "XLIQUIDITYLinternal" + i, OBJPROP_STYLE, STYLE_SOLID);
            else ObjectSetInteger(0, TF + "XLIQUIDITYLinternal" + i, OBJPROP_STYLE, STYLE_DOT);
            ObjectSetInteger(0, TF + "XLIQUIDITYLinternal" + i, OBJPROP_COLOR, clrLime);
            ObjectSetInteger(0, TF + "XLIQUIDITYLinternal" + i, OBJPROP_HIDDEN, true);
            if(DRAWYN == true) ObjectCreate(0, TF + "XLIQUIDITYLinternalEQ" + i, OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectMove(0, TF + "XLIQUIDITYLinternalEQ" + i, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - (INTLL[i] + INTHH[i]) / 2), INTEQ[i]);
            ObjectMove(0, TF + "XLIQUIDITYLinternalEQ" + i, 1, MITO, INTEQ[i]);
            ObjectSetInteger(0, TF + "XLIQUIDITYLinternalEQ" + i, OBJPROP_RAY, false);
            if(MITIGATO[i] == -1) ObjectSetInteger(0, TF + "XLIQUIDITYLinternalEQ" + i, OBJPROP_STYLE, STYLE_SOLID);
            else ObjectSetInteger(0, TF + "XLIQUIDITYLinternalEQ" + i, OBJPROP_STYLE, STYLE_DOT);
            ObjectSetInteger(0, TF + "XLIQUIDITYLinternalEQ" + i, OBJPROP_COLOR, clrLime);
            ObjectSetInteger(0, TF + "XLIQUIDITYLinternalEQ" + i, OBJPROP_HIDDEN, true);
            if(MITIGATO[i] == -1) {
                CREATETEXTPRICEprice(TF + "XLIQUIDITYLtext" + i, "intSSL", MITO, INTEQ[i], clrWhite, ANCHOR_RIGHT_UPPER);
            }
            else {
                CREATETEXTPRICEprice(TF + "XLIQUIDITYLtext" + i, "int$", MITO, INTEQ[i], clrWhite, ANCHOR_RIGHT_UPPER);
            }
            if(DRAWYN == true) ObjectCreate(0, TF + "XLIQUIDITYL" + i, OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectMove(0, TF + "XLIQUIDITYL" + i, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - INTLL[i]), iLow(SIMBA, TF, iBars(SIMBA, TF) - INTLL[i]));
            if(LIQtaken == 0) ObjectMove(0, TF + "XLIQUIDITYL" + i, 1, INVLIQ, iLow(SIMBA, TF, iBars(SIMBA, TF) - INTLL[i]));
            if(LIQtaken != 0) ObjectMove(0, TF + "XLIQUIDITYL" + i, 1, iTime(SIMBA, TF, iBars(SIMBA, TF) - LIQtaken), iLow(SIMBA, TF, iBars(SIMBA, TF) - INTLL[i]));
            if(DRAWYN != 0) CREATETEXTPRICEprice(TF + "XLIQUIDITYL" + i + "text", "$", (int)ObjectGetInteger(0, TF + "XLIQUIDITYL" + i, OBJPROP_TIME2), ObjectGetDouble(0, TF + "XLIQUIDITYL" + i, OBJPROP_PRICE1), clrWhite, ANCHOR_RIGHT_LOWER);
            ObjectSetInteger(0, TF + "XLIQUIDITYL" + i, OBJPROP_RAY, false);
            ObjectSetInteger(0, TF + "XLIQUIDITYL" + i, OBJPROP_STYLE, STYLE_DOT);
            ObjectSetInteger(0, TF + "XLIQUIDITYL" + i, OBJPROP_COLOR, clrGray);
            ObjectSetInteger(0, TF + "XLIQUIDITYL" + i, OBJPROP_HIDDEN, true);
        }
        if(INTFLOW[i] == 2) {
            for(int k = (iBars(SIMBA, TF) - INTHH[i]) - 1; k > CURRCANDX; k--) {
                if(iHigh(SIMBA, TF, k) >= iHigh(SIMBA, TF, iBars(SIMBA, TF) - INTHH[i])) {
                    LIQtaken = iBars(SIMBA, TF) - k;
                    INVLIQ = 0;
                    break;
                }
            }
            datetime MITO = iTime(SIMBA, TF, CURRCANDX) + 60 * Period();
            if(MITIGATO[i] != -1) MITO = iTime(SIMBA, TF, iBars(SIMBA, TF) - MITIGATO[i]);
            if(DRAWYN == true) ObjectCreate(0, TF + "XLIQUIDITYLinternal" + i, OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectMove(0, TF + "XLIQUIDITYLinternal" + i, 1, iTime(SIMBA, TF, iBars(SIMBA, TF) - INTLL[i]), iLow(SIMBA, TF, iBars(SIMBA, TF) - INTLL[i]));
            ObjectMove(0, TF + "XLIQUIDITYLinternal" + i, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - INTHH[i]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - INTHH[i]));
            ObjectSetInteger(0, TF + "XLIQUIDITYLinternal" + i, OBJPROP_RAY, false);
            if(MITIGATO[i] == -1) ObjectSetInteger(0, TF + "XLIQUIDITYLinternal" + i, OBJPROP_STYLE, STYLE_SOLID);
            else ObjectSetInteger(0, TF + "XLIQUIDITYLinternal" + i, OBJPROP_STYLE, STYLE_DOT);
            ObjectSetInteger(0, TF + "XLIQUIDITYLinternal" + i, OBJPROP_COLOR, clrHotPink);
            ObjectSetInteger(0, TF + "XLIQUIDITYLinternal" + i, OBJPROP_HIDDEN, true);
            if(DRAWYN == true) ObjectCreate(0, TF + "XLIQUIDITYLinternalEQ" + i, OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectMove(0, TF + "XLIQUIDITYLinternalEQ" + i, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - (INTLL[i] + INTHH[i]) / 2), INTEQ[i]);
            ObjectMove(0, TF + "XLIQUIDITYLinternalEQ" + i, 1, MITO, INTEQ[i]);
            ObjectSetInteger(0, TF + "XLIQUIDITYLinternalEQ" + i, OBJPROP_RAY, false);
            if(MITIGATO[i] == -1) ObjectSetInteger(0, TF + "XLIQUIDITYLinternalEQ" + i, OBJPROP_STYLE, STYLE_SOLID);
            else ObjectSetInteger(0, TF + "XLIQUIDITYLinternalEQ" + i, OBJPROP_STYLE, STYLE_DOT);
            ObjectSetInteger(0, TF + "XLIQUIDITYLinternalEQ" + i, OBJPROP_COLOR, clrHotPink);
            ObjectSetInteger(0, TF + "XLIQUIDITYLinternalEQ" + i, OBJPROP_HIDDEN, true);
            if(MITIGATO[i] == -1) {
                CREATETEXTPRICEprice(TF + "XLIQUIDITYLtext" + i, "intBSL", MITO, INTEQ[i], clrWhite, ANCHOR_RIGHT_LOWER);
            }
            else {
                CREATETEXTPRICEprice(TF + "XLIQUIDITYLtext" + i, "int$", MITO, INTEQ[i], clrWhite, ANCHOR_RIGHT_LOWER);
            }
            if(DRAWYN == true) ObjectCreate(0, TF + "XLIQUIDITYL" + i, OBJ_TREND, 0, 0, 0, 0, 0);
            ObjectMove(0, TF + "XLIQUIDITYL" + i, 0, iTime(SIMBA, TF, iBars(SIMBA, TF) - INTHH[i]), iHigh(SIMBA, TF, iBars(SIMBA, TF) - INTHH[i]));
            if(LIQtaken == 0) ObjectMove(0, TF + "XLIQUIDITYL" + i, 1, INVLIQ, iHigh(SIMBA, TF, iBars(SIMBA, TF) - INTHH[i]));
            if(LIQtaken != 0) ObjectMove(0, TF + "XLIQUIDITYL" + i, 1, iTime(SIMBA, TF, iBars(SIMBA, TF) - LIQtaken), iHigh(SIMBA, TF, iBars(SIMBA, TF) - INTHH[i]));
            if(DRAWYN != 0) CREATETEXTPRICEprice(TF + "XLIQUIDITYL" + i + "text", "$", (int)ObjectGetInteger(0, TF + "XLIQUIDITYL" + i, OBJPROP_TIME2), ObjectGetDouble(0, TF + "XLIQUIDITYL" + i, OBJPROP_PRICE1), clrWhite, ANCHOR_RIGHT_LOWER);
            ObjectSetInteger(0, TF + "XLIQUIDITYL" + i, OBJPROP_RAY, false);
            ObjectSetInteger(0, TF + "XLIQUIDITYL" + i, OBJPROP_STYLE, STYLE_DOT);
            ObjectSetInteger(0, TF + "XLIQUIDITYL" + i, OBJPROP_COLOR, clrGray);
            ObjectSetInteger(0, TF + "XLIQUIDITYL" + i, OBJPROP_HIDDEN, true);
        }
    }
    return(0);
}
//+------------------------------------------------------------------+
