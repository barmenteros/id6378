//+------------------------------------------------------------------+
//|                                                    AlertSystem.mqh |
//|                                                   Copyright 2025 |
//|                             https://web24hub.example.com/support |
//+------------------------------------------------------------------+

#property copyright "Copyright 2025 Web24hub EA Team"
#property link      "https://web24hub.example.com/support"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Alert System Global Variables                                    |
//+------------------------------------------------------------------+

// Alert Configuration Variables
bool ALERT_SYSTEM_popup = true;
bool ALERT_SYSTEM_mobile = true;
bool ALERT_SYSTEMING = false;
int ALERT_POI = PERIOD_H4;
int ALERT_SETUP = PERIOD_M15;

// Internal Alert Variables
int ALSYS = 0;

datetime NEWBAR = Time[0];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ALERTPOPUP(string SIMBA, int TF, int zLAST_FLOW, int zLAST_HH, int zLAST_LL, int zLAST_BREAKER, int zLAST_LEG0flow)
{
    bool newBar = false;
    if (NEWBAR != Time[0]) {
        NEWBAR = Time[0];
        newBar = true;
    }

    if(newBar == true) {
        if(iBars(SIMBA, TF) - zLAST_BREAKER == 1) {

            // === DETERMINE STRUCTURE TYPE ===
            string structureType = "CHoCH";
            string alertType = "CHOCH";  // For universal toggle system
            if(zLAST_LEG0flow > 1) {
                structureType = "BOS";
                alertType = "BOS";  // For universal toggle system
            }

            // === DETERMINE FLOW DIRECTION ===
            string flowDirection = "";
            string flowIndicator = "";
            if(zLAST_FLOW == 1) {
                flowDirection = "Bullish";
                flowIndicator = "[BUY]";
            }
            else if(zLAST_FLOW == 2) {
                flowDirection = "Bearish";
                flowIndicator = "[SELL]";
            }

            // === CREATE ENHANCED ALERT MESSAGES ===
            string terminalAlert = ">>> " + structureType + " FORMATION <<<\n" +
                                   "Symbol: " + SIMBA + " | Timeframe: " + tftransformation(TF) + "\n" +
                                   "Direction: " + flowDirection + " " + flowIndicator + "\n" +
                                   "Structure: " + structureType + " confirmed\n";

            string mobileAlert = "[" + structureType + "] " + SIMBA + " " + tftransformation(TF) +
                                 " | " + flowDirection + " " + flowIndicator;

            // === ADD SPECIFIC CONTEXT BASED ON ALERT TYPE ===
            if(alertType == "BOS") {
                // Enhanced BOS alert with configuration checks
                if(ALERT_MAJOR_BOS_ONLY) {
                    terminalAlert += "Type: MAJOR Break of Structure\n";
                    mobileAlert += " - MAJOR BOS";
                }
                else {
                    terminalAlert += "Type: Break of Structure\n";
                    mobileAlert += " - BOS";
                }

                if(ALERT_BOS_SHOW_LEVELS) {
                    double currentPrice = (zLAST_FLOW == 1) ? Ask : Bid;
                    terminalAlert += "Current Price: " + DoubleToString(currentPrice, Digits) + "\n";
                }
            }
            else if(alertType == "CHOCH") {
                // Enhanced CHoCH alert with emergency mode
                if(ALERT_CHOCH_EMERGENCY_MODE) {
                    terminalAlert = "🚨 EMERGENCY: " + terminalAlert;
                    mobileAlert = "🚨 " + mobileAlert;
                }

                terminalAlert += "*** CHANGE OF CHARACTER - MARKET SHIFT DETECTED ***\n";

                if(ALERT_CHOCH_SHOW_IMPACT) {
                    terminalAlert += "Impact: Existing trades should be reviewed\n";
                }

                mobileAlert += " - CHoCH SHIFT";
            }

            // === SEND ALERTS USING UNIVERSAL TOGGLE SYSTEM ===
            SendUniversalAlert(alertType, terminalAlert, mobileAlert);

            // === EVENT-DRIVEN LOGGING (FOLLOWING EA LOGGING PRINCIPLES) ===
            Print("*** ", structureType, " ALERT SENT: ", SIMBA, " ", tftransformation(TF),
                  " - ", flowDirection, " flow confirmed ***");

            return(1);
        }
    }

    return(0);
}

//+------------------------------------------------------------------+
//| ALERT_PUSH - Advanced alert system for POI mitigations         |
//+------------------------------------------------------------------+
int ALERT_PUSH(string SIMBA, int TFA, int CURRCANDX, int SETUP, int LTF, int SL, int PICCO)
{
    int CANDPOI = GlobalVariableGet(SIMBA + "POIT" + TFA);
    int CANDPOIopp = GlobalVariableGet(SIMBA + "POIVST" + TFA);
    int CANDSOURCE = GlobalVariableGet(SIMBA + "SOURCET" + TFA);
    int CANDSOURCEopp = GlobalVariableGet(SIMBA + "SOURCEVST" + TFA);
    int DONE = 0;
    int HtfFlow = LAST_FLOW;
    int HtfRto = LAST_RTO;
    int HtfRts = LAST_RTS;
    int HtfRtoc = LAST_RTO_CHECK;
    int HtfRtsc = LAST_RTS_CHECK;
    int HtfS = MathMin(LAST_LL, LAST_HH);
    int HtfSc = MathMax(LAST_LL_DEMAND, LAST_HH_SUPPLY);
    int HtfBms = LAST_BMS;
    int HtfBmsopp = LAST_BMSoppall;
    int uno = ORDERBLOCK(Symbol(), LTF, 0, 0, 0, 1);
    int due = ORDERBLOCKshow(Symbol(), LTF, 0, 0, 0, 1, 0, 0);

// === ENHANCED BULLISH FLOW SD ZONE ALERTS ===
    if(HtfFlow == 1 && iBars(SIMBA, LTF) - LAST_BREAKER == 1) {

        // === ENHANCED BULLISH ORDER BLOCK MITIGATION ===
        if(HtfRto != CANDPOI) {
            if(iLow(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_LL) < iOpen(SIMBA, TFA, iBars(SIMBA, TFA) - HtfBms) &&
                    iLow(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_LL) > iLow(SIMBA, TFA, iBars(SIMBA, TFA) - HtfBms) &&
                    LAST_FLOW == 1 && iBars(SIMBA, LTF) - LAST_BREAKER == 1) {

                VEDIFIBO(SIMBA, TFA, 1, LAST_LL, LAST_HH, 1);

                // === ENHANCED ORDER BLOCK ALERT ===
                double orderBlockPrice = iLow(SIMBA, TFA, iBars(SIMBA, TFA) - HtfBms);
                double currentPrice = iLow(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_LL);
                string obDescription = GetOrderBlockTypeDescription(1, orderBlockPrice, SIMBA, TFA);
                string tradingGuidance = GetOrderBlockTradingGuidance(1, orderBlockPrice, SIMBA, true);
                string obStrength = GetOrderBlockStrength(SIMBA, TFA, 1, orderBlockPrice);

                // Enhanced Terminal Alert for Order Block
                string terminalAlert = ">>> BULLISH ORDER BLOCK MITIGATED <<<\n" +
                                       "Symbol: " + SIMBA + " | Timeframe: " + tftransformation(TFA) + "\n" +
                                       "Order Block Type: " + obDescription + "\n" +
                                       "OB Strength: " + obStrength + "\n" +
                                       "Order Block Level: " + DoubleToString(orderBlockPrice, Digits) + "\n" +
                                       "Mitigation Price: " + DoubleToString(currentPrice, Digits) + "\n" +
                                       tradingGuidance + "\n" +
                                       "*** INSTITUTIONAL BUYING ZONE ACTIVATED ***";

                // Enhanced Mobile Alert for Order Block
                string mobileAlert = "[BULLISH OB] " + SIMBA + " " + tftransformation(TFA) +
                                     " | Order Block mitigated @ " + DoubleToString(orderBlockPrice, Digits) +
                                     " - BUY SETUP";

                // === SEND USING UNIVERSAL TOGGLE SYSTEM ===
                SendUniversalAlert("OB", terminalAlert, mobileAlert);

                // Enhanced logging for Order Block
                Print("*** BULLISH ORDER BLOCK MITIGATION ALERT SENT ***");
                Print("- Order Block Level: ", DoubleToString(orderBlockPrice, Digits));
                Print("- OB Strength: ", obStrength);
                Print("- Institutional buying zone activated");

                DONE = 1;
                GlobalVariableSet(SIMBA + "POIT" + TFA, HtfRto);
            }
        }

        // === BULLISH SOURCE MITIGATION (Critical SD Zone) ===
        if(HtfRts != CANDSOURCE) {
            if(iLow(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_LL) < iOpen(SIMBA, TFA, iBars(SIMBA, TFA) - HtfS) &&
                    iLow(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_LL) > iLow(SIMBA, TFA, iBars(SIMBA, TFA) - HtfS) &&
                    LAST_FLOW == 1 && iBars(SIMBA, LTF) - LAST_BREAKER == 1) {

                VEDIFIBO(SIMBA, TFA, 1, LAST_LL, LAST_HH, 1);

                // === ENHANCED SOURCE ALERT ===
                double currentPrice = iLow(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_LL);
                string zoneDescription = GetSDZoneTypeDescription(1, true, true);
                string setupGuidance = GetSDZoneSetupGuidance(1, true, true, SIMBA, currentPrice);
                string zoneStrength = GetSDZoneStrength(SIMBA, TFA, 1, true);

                // Enhanced Terminal Alert for SOURCE
                string terminalAlert = ">>> CRITICAL: DEMAND SOURCE MITIGATED <<<\n" +
                                       "Symbol: " + SIMBA + " | Timeframe: " + tftransformation(TFA) + "\n" +
                                       "Zone Type: " + zoneDescription + "\n" +
                                       "Zone Strength: " + zoneStrength + "\n" +
                                       "SOURCE Price: " + DoubleToString(currentPrice, Digits) + "\n" +
                                       setupGuidance + "\n" +
                                       "*** HIGHEST PRIORITY INSTITUTIONAL SETUP ***";

                // Enhanced Mobile Alert for SOURCE
                string mobileAlert = "[BULLISH SOURCE] " + SIMBA + " " + tftransformation(TFA) +
                                     " | Demand SOURCE mitigated @ " + DoubleToString(currentPrice, Digits) +
                                     " - HIGH PRIORITY!";

                // === SEND USING UNIVERSAL TOGGLE SYSTEM ===
                SendUniversalAlert("SD", terminalAlert, mobileAlert);

                Print("*** CRITICAL BULLISH SOURCE MITIGATION ALERT SENT ***");
                Print("- SOURCE ZONE - Highest Priority SD Alert");
                Print("- Zone Strength: ", zoneStrength);
                Print("- SOURCE Price: ", DoubleToString(currentPrice, Digits));

                DONE = 1;
                GlobalVariableSet(SIMBA + "SOURCET" + TFA, HtfRts);
            }
        }

        // === ENHANCED COUNTER-TREND ORDER BLOCK INTERACTION ===
        if(HtfRtoc != CANDPOIopp) {
            if(iLow(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_LL) < iOpen(SIMBA, TFA, iBars(SIMBA, TFA) - HtfBmsopp) &&
                    iLow(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_LL) > iLow(SIMBA, TFA, iBars(SIMBA, TFA) - HtfBmsopp) &&
                    LAST_FLOW == 1 && iBars(SIMBA, LTF) - LAST_BREAKER == 1) {

                VEDIFIBO(SIMBA, TFA, 1, LAST_LL, LAST_HH, 1);

                // === ENHANCED COUNTER-TREND ORDER BLOCK ALERT ===
                double orderBlockPrice = iLow(SIMBA, TFA, iBars(SIMBA, TFA) - HtfBmsopp);
                double currentPrice = iLow(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_LL);
                string obDescription = GetOrderBlockTypeDescription(1, orderBlockPrice, SIMBA, TFA);
                string tradingGuidance = GetOrderBlockTradingGuidance(1, orderBlockPrice, SIMBA, false);
                string obStrength = GetOrderBlockStrength(SIMBA, TFA, 1, orderBlockPrice);

                // Enhanced Terminal Alert
                string terminalAlert = ">>> BULLISH ORDER BLOCK INTERACTION (COUNTER-TREND) <<<\n" +
                                       "Symbol: " + SIMBA + " | Timeframe: " + tftransformation(TFA) + "\n" +
                                       "Order Block Type: " + obDescription + "\n" +
                                       "OB Strength: " + obStrength + "\n" +
                                       "Order Block Level: " + DoubleToString(orderBlockPrice, Digits) + "\n" +
                                       "Interaction Price: " + DoubleToString(currentPrice, Digits) + "\n" +
                                       tradingGuidance + "\n" +
                                       "*** COUNTER-TREND INSTITUTIONAL SETUP ***";

                // Enhanced Mobile Alert
                string mobileAlert = "[COUNTER OB] " + SIMBA + " " + tftransformation(TFA) +
                                     " | Counter-trend OB @ " + DoubleToString(orderBlockPrice, Digits) +
                                     " - BUY SETUP (Higher Risk)";

                // === SEND USING UNIVERSAL TOGGLE SYSTEM ===
                SendUniversalAlert("OB", terminalAlert, mobileAlert);

                Print("*** COUNTER-TREND ORDER BLOCK INTERACTION ALERT SENT ***");
                Print("- Counter-trend institutional setup");
                Print("- OB Strength: ", obStrength);

                DONE = 1;
                GlobalVariableSet(SIMBA + "POIVST" + TFA, HtfRtoc);
            }
        }

        // === BULLISH COUNTER-TREND SOURCE INTERACTION ===
        if(HtfRtsc != CANDSOURCEopp) {
            if(iHigh(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_HH) > iOpen(SIMBA, TFA, iBars(SIMBA, TFA) - HtfSc) &&
                    iHigh(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_HH) < iHigh(SIMBA, TFA, iBars(SIMBA, TFA) - HtfSc) &&
                    LAST_FLOW == 2 && iBars(SIMBA, LTF) - LAST_BREAKER == 1) {

                VEDIFIBO(SIMBA, TFA, 1, LAST_LL, LAST_HH, 2);

                // === ENHANCED COUNTER-TREND SOURCE ALERT ===
                double currentPrice = iHigh(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_HH);
                string zoneDescription = GetSDZoneTypeDescription(2, true, false);
                string setupGuidance = GetSDZoneSetupGuidance(2, true, false, SIMBA, currentPrice);
                string zoneStrength = GetSDZoneStrength(SIMBA, TFA, 2, true);

                // Enhanced Terminal Alert for Counter-trend SOURCE
                string terminalAlert = ">>> CRITICAL: SUPPLY SOURCE MITIGATED (REVERSAL) <<<\n" +
                                       "Symbol: " + SIMBA + " | Timeframe: " + tftransformation(TFA) + "\n" +
                                       "Zone Type: " + zoneDescription + "\n" +
                                       "Zone Strength: " + zoneStrength + "\n" +
                                       "SOURCE Price: " + DoubleToString(currentPrice, Digits) + "\n" +
                                       setupGuidance + "\n" +
                                       "*** POTENTIAL TREND REVERSAL SIGNAL ***";

                // Enhanced Mobile Alert for Counter-trend SOURCE
                string mobileAlert = "[REVERSAL SOURCE] " + SIMBA + " " + tftransformation(TFA) +
                                     " | Supply SOURCE mitigated @ " + DoubleToString(currentPrice, Digits) +
                                     " - REVERSAL SETUP!";

                // === SEND USING UNIVERSAL TOGGLE SYSTEM ===
                SendUniversalAlert("SD", terminalAlert, mobileAlert);

                Print("*** CRITICAL SUPPLY SOURCE REVERSAL ALERT SENT ***");
                Print("- REVERSAL SOURCE - Potential trend change");
                Print("- Zone Strength: ", zoneStrength);

                DONE = 1;
                GlobalVariableSet(SIMBA + "SOURCEVST" + TFA, HtfRtsc);
            }
        }
    }

// === ENHANCED BEARISH FLOW SD ZONE ALERTS ===
    if(HtfFlow == 2 && iBars(SIMBA, LTF) - LAST_BREAKER == 1) {

        // === ENHANCED BEARISH ORDER BLOCK MITIGATION ===
        if(HtfRto != CANDPOI) {
            if(iHigh(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_HH) > iOpen(SIMBA, TFA, iBars(SIMBA, TFA) - HtfBms) &&
                    iHigh(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_HH) < iHigh(SIMBA, TFA, iBars(SIMBA, TFA) - HtfBms) &&
                    LAST_FLOW == 2 && iBars(SIMBA, LTF) - LAST_BREAKER == 1) {

                VEDIFIBO(SIMBA, TFA, 1, LAST_LL, LAST_HH, 2);

                // === ENHANCED BEARISH ORDER BLOCK ALERT ===
                double orderBlockPrice = iHigh(SIMBA, TFA, iBars(SIMBA, TFA) - HtfBms);
                double currentPrice = iHigh(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_HH);
                string obDescription = GetOrderBlockTypeDescription(2, orderBlockPrice, SIMBA, TFA);
                string tradingGuidance = GetOrderBlockTradingGuidance(2, orderBlockPrice, SIMBA, true);
                string obStrength = GetOrderBlockStrength(SIMBA, TFA, 2, orderBlockPrice);

                // Enhanced Terminal Alert for Bearish Order Block
                string terminalAlert = ">>> BEARISH ORDER BLOCK MITIGATED <<<\n" +
                                       "Symbol: " + SIMBA + " | Timeframe: " + tftransformation(TFA) + "\n" +
                                       "Order Block Type: " + obDescription + "\n" +
                                       "OB Strength: " + obStrength + "\n" +
                                       "Order Block Level: " + DoubleToString(orderBlockPrice, Digits) + "\n" +
                                       "Mitigation Price: " + DoubleToString(currentPrice, Digits) + "\n" +
                                       tradingGuidance + "\n" +
                                       "*** INSTITUTIONAL SELLING ZONE ACTIVATED ***";

                // Enhanced Mobile Alert for Bearish Order Block
                string mobileAlert = "[BEARISH OB] " + SIMBA + " " + tftransformation(TFA) +
                                     " | Order Block mitigated @ " + DoubleToString(orderBlockPrice, Digits) +
                                     " - SELL SETUP";

                // === SEND USING UNIVERSAL TOGGLE SYSTEM ===
                SendUniversalAlert("OB", terminalAlert, mobileAlert);

                // Enhanced logging for Bearish Order Block
                Print("*** BEARISH ORDER BLOCK MITIGATION ALERT SENT ***");
                Print("- Order Block Level: ", DoubleToString(orderBlockPrice, Digits));
                Print("- OB Strength: ", obStrength);
                Print("- Institutional selling zone activated");

                DONE = 1;
                GlobalVariableSet(SIMBA + "POIT" + TFA, HtfRto);
            }
        }

        // === BEARISH SOURCE MITIGATION (Critical SD Zone) ===
        if(HtfRts != CANDSOURCE) {
            if(iHigh(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_HH) > iOpen(SIMBA, TFA, iBars(SIMBA, TFA) - HtfS) &&
                    iHigh(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_HH) < iHigh(SIMBA, TFA, iBars(SIMBA, TFA) - HtfS) &&
                    LAST_FLOW == 2 && iBars(SIMBA, LTF) - LAST_BREAKER == 1) {

                VEDIFIBO(SIMBA, TFA, 1, LAST_LL, LAST_HH, 2);

                // === ENHANCED BEARISH SOURCE ALERT ===
                double currentPrice = iHigh(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_HH);
                string zoneDescription = GetSDZoneTypeDescription(2, true, true);
                string setupGuidance = GetSDZoneSetupGuidance(2, true, true, SIMBA, currentPrice);
                string zoneStrength = GetSDZoneStrength(SIMBA, TFA, 2, true);

                // Enhanced Terminal Alert for Bearish SOURCE
                string terminalAlert = ">>> CRITICAL: SUPPLY SOURCE MITIGATED <<<\n" +
                                       "Symbol: " + SIMBA + " | Timeframe: " + tftransformation(TFA) + "\n" +
                                       "Zone Type: " + zoneDescription + "\n" +
                                       "Zone Strength: " + zoneStrength + "\n" +
                                       "SOURCE Price: " + DoubleToString(currentPrice, Digits) + "\n" +
                                       setupGuidance + "\n" +
                                       "*** HIGHEST PRIORITY INSTITUTIONAL SETUP ***";

                // Enhanced Mobile Alert for Bearish SOURCE
                string mobileAlert = "[BEARISH SOURCE] " + SIMBA + " " + tftransformation(TFA) +
                                     " | Supply SOURCE mitigated @ " + DoubleToString(currentPrice, Digits) +
                                     " - HIGH PRIORITY!";

                // === SEND USING UNIVERSAL TOGGLE SYSTEM ===
                SendUniversalAlert("SD", terminalAlert, mobileAlert);

                Print("*** CRITICAL BEARISH SOURCE MITIGATION ALERT SENT ***");
                Print("- SOURCE ZONE - Highest Priority SD Alert");
                Print("- Zone Strength: ", zoneStrength);
                Print("- SOURCE Price: ", DoubleToString(currentPrice, Digits));

                DONE = 1;
                GlobalVariableSet(SIMBA + "SOURCET" + TFA, HtfRts);
            }
        }

        // === BEARISH COUNTER-TREND ORDER BLOCK INTERACTION ===
        if(HtfRtoc != CANDPOIopp) {
            if(iHigh(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_HH) > iOpen(SIMBA, TFA, iBars(SIMBA, TFA) - HtfBmsopp) &&
                    iHigh(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_HH) < iHigh(SIMBA, TFA, iBars(SIMBA, TFA) - HtfBmsopp) &&
                    LAST_FLOW == 2 && iBars(SIMBA, LTF) - LAST_BREAKER == 1) {

                VEDIFIBO(SIMBA, TFA, 1, LAST_LL, LAST_HH, 2);

                // === ENHANCED BEARISH COUNTER-TREND ORDER BLOCK ALERT ===
                double orderBlockPrice = iHigh(SIMBA, TFA, iBars(SIMBA, TFA) - HtfBmsopp);
                double currentPrice = iHigh(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_HH);
                string obDescription = GetOrderBlockTypeDescription(2, orderBlockPrice, SIMBA, TFA);
                string tradingGuidance = GetOrderBlockTradingGuidance(2, orderBlockPrice, SIMBA, false);
                string obStrength = GetOrderBlockStrength(SIMBA, TFA, 2, orderBlockPrice);

                // Enhanced Terminal Alert
                string terminalAlert = ">>> BEARISH ORDER BLOCK INTERACTION (COUNTER-TREND) <<<\n" +
                                       "Symbol: " + SIMBA + " | Timeframe: " + tftransformation(TFA) + "\n" +
                                       "Order Block Type: " + obDescription + "\n" +
                                       "OB Strength: " + obStrength + "\n" +
                                       "Order Block Level: " + DoubleToString(orderBlockPrice, Digits) + "\n" +
                                       "Interaction Price: " + DoubleToString(currentPrice, Digits) + "\n" +
                                       tradingGuidance + "\n" +
                                       "*** COUNTER-TREND INSTITUTIONAL SETUP ***";

                // Enhanced Mobile Alert
                string mobileAlert = "[COUNTER OB] " + SIMBA + " " + tftransformation(TFA) +
                                     " | Counter-trend OB @ " + DoubleToString(orderBlockPrice, Digits) +
                                     " - SELL SETUP (Higher Risk)";

                // === SEND USING UNIVERSAL TOGGLE SYSTEM ===
                SendUniversalAlert("OB", terminalAlert, mobileAlert);

                Print("*** BEARISH COUNTER-TREND ORDER BLOCK INTERACTION ALERT SENT ***");
                Print("- Counter-trend institutional setup");
                Print("- OB Strength: ", obStrength);

                DONE = 1;
                GlobalVariableSet(SIMBA + "POIVST" + TFA, HtfRtoc);
            }
        }

        // === BEARISH COUNTER-TREND SOURCE INTERACTION ===
        if(HtfRtsc != CANDSOURCEopp) {
            if(iLow(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_LL) < iOpen(SIMBA, TFA, iBars(SIMBA, TFA) - HtfSc) &&
                    iLow(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_LL) > iLow(SIMBA, TFA, iBars(SIMBA, TFA) - HtfSc) &&
                    LAST_FLOW == 1 && iBars(SIMBA, LTF) - LAST_BREAKER == 1) {

                VEDIFIBO(SIMBA, TFA, 1, LAST_LL, LAST_HH, 1);

                // === ENHANCED BEARISH COUNTER-TREND SOURCE ALERT ===
                double currentPrice = iLow(SIMBA, LTF, iBars(SIMBA, LTF) - LAST_LL);
                string zoneDescription = GetSDZoneTypeDescription(1, true, false);
                string setupGuidance = GetSDZoneSetupGuidance(1, true, false, SIMBA, currentPrice);
                string zoneStrength = GetSDZoneStrength(SIMBA, TFA, 1, true);

                // Enhanced Terminal Alert for Counter-trend SOURCE
                string terminalAlert = ">>> CRITICAL: DEMAND SOURCE MITIGATED (REVERSAL) <<<\n" +
                                       "Symbol: " + SIMBA + " | Timeframe: " + tftransformation(TFA) + "\n" +
                                       "Zone Type: " + zoneDescription + "\n" +
                                       "Zone Strength: " + zoneStrength + "\n" +
                                       "SOURCE Price: " + DoubleToString(currentPrice, Digits) + "\n" +
                                       setupGuidance + "\n" +
                                       "*** POTENTIAL TREND REVERSAL SIGNAL ***";

                // Enhanced Mobile Alert for Counter-trend SOURCE
                string mobileAlert = "[REVERSAL SOURCE] " + SIMBA + " " + tftransformation(TFA) +
                                     " | Demand SOURCE mitigated @ " + DoubleToString(currentPrice, Digits) +
                                     " - REVERSAL SETUP!";

                // === SEND USING UNIVERSAL TOGGLE SYSTEM ===
                SendUniversalAlert("SD", terminalAlert, mobileAlert);

                Print("*** CRITICAL DEMAND SOURCE REVERSAL ALERT SENT ***");
                Print("- REVERSAL SOURCE - Potential trend change");
                Print("- Zone Strength: ", zoneStrength);

                DONE = 1;
                GlobalVariableSet(SIMBA + "SOURCEVST" + TFA, HtfRtsc);
            }
        }
    }

    return DONE;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetBOSAlertStats()
{
    static int majorBOSCount = 0;
    static int minorBOSFiltered = 0;
    static datetime lastResetTime = 0;

// Reset daily statistics
    if(TimeDay(Time[0]) != TimeDay(lastResetTime)) {
        majorBOSCount = 0;
        minorBOSFiltered = 0;
        lastResetTime = Time[0];
    }

    string stats = "BOS ALERTS: Major(" + IntegerToString(majorBOSCount) +
                   ") Filtered(" + IntegerToString(minorBOSFiltered) + ")";

    return stats;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ValidateBOSAlertSettings()
{
    if(ALERT_BOS_MIN_POINTS < 10 || ALERT_BOS_MIN_POINTS > 500) {
        Print("WARNING: ALERT_BOS_MIN_POINTS should be between 10-500. Current: ", ALERT_BOS_MIN_POINTS);
        return false;
    }

    return true;
}

//+------------------------------------------------------------------+
//| Initialize Alert System Variables                               |
//+------------------------------------------------------------------+
void InitializeTradeOpeningAlerts()
{
// Legacy support - maintain existing ALERT_SYSTEM global variables
// These are now synchronized with the new granular controls
    GlobalVariableSet("ALERT_SYSTEM_popup", ALERT_TRADE_OPENED_POPUP ? 1 : 0);
    GlobalVariableSet("ALERT_SYSTEM_mobile", ALERT_TRADE_OPENED_MOBILE ? 1 : 0);

// Event-driven logging for initialization
    Print("*** TRADE OPENING ALERTS INITIALIZED (UNIVERSAL CONTROL) ***");
    Print("- Terminal Alerts: ", (ALERT_TRADE_OPENED_POPUP ? "ENABLED" : "DISABLED"));
    Print("- Mobile Alerts: ", (ALERT_TRADE_OPENED_MOBILE ? "ENABLED" : "DISABLED"));
    Print("- Alert Status: ", GetAlertSystemStatus());
    Print("- Universal Status: ", GetUniversalAlertStatus());
}

//+------------------------------------------------------------------+
//| Alert System Status Display Function                            |
//+------------------------------------------------------------------+
string GetAlertSystemStatus()
{
    string status = "ALERTS: ";

    bool terminalEnabled = (GlobalVariableGet("ALERT_SYSTEM_popup") == 1);
    bool mobileEnabled = (GlobalVariableGet("ALERT_SYSTEM_mobile") == 1);

    if(terminalEnabled && mobileEnabled) {
        status += "BOTH ENABLED";
    }
    else if(terminalEnabled) {
        status += "TERMINAL ONLY";
    }
    else if(mobileEnabled) {
        status += "MOBILE ONLY";
    }
    else {
        status += "DISABLED";
    }

    return status;
}

//+------------------------------------------------------------------+
//| Initialize Enhanced BOS Alert System                            |
//+------------------------------------------------------------------+
void InitializeEnhancedBOSAlerts()
{
// Validate BOS alert settings
    if(!ValidateBOSAlertSettings()) {
        Print("BOS Alert settings validation failed - using defaults");
    }

// Event-driven logging for BOS alert initialization
    Print("*** ENHANCED BOS ALERTS INITIALIZED ***");
    Print("- Major BOS Only: ", (ALERT_MAJOR_BOS_ONLY ? "ENABLED" : "DISABLED"));
    Print("- Show Price Levels: ", (ALERT_BOS_SHOW_LEVELS ? "ENABLED" : "DISABLED"));
    Print("- Minimum Points: ", ALERT_BOS_MIN_POINTS);
    Print("- Minor BOS will be ", (ALERT_MAJOR_BOS_ONLY ? "FILTERED OUT" : "INCLUDED"));
}

//+------------------------------------------------------------------+
//| Get CHoCH Market Impact Assessment             |
//+------------------------------------------------------------------+
string GetCHoCHMarketImpact(string symbol, int timeframe, int new_flow, int old_flow)
{
    string impact = "";
    string from_direction = "";
    string to_direction = "";

// Determine flow direction changes
    if(old_flow == 1) from_direction = "BULLISH";
    else if(old_flow == 2) from_direction = "BEARISH";
    else from_direction = "NEUTRAL";

    if(new_flow == 1) to_direction = "BULLISH";
    else if(new_flow == 2) to_direction = "BEARISH";
    else to_direction = "NEUTRAL";

// Assess the significance of the change
    if((old_flow == 1 && new_flow == 2) || (old_flow == 2 && new_flow == 1)) {
        impact = "CRITICAL REVERSAL: " + from_direction + " to " + to_direction;
    }
    else if(old_flow == 0) {
        impact = "TREND INITIATION: " + to_direction + " flow established";
    }
    else {
        impact = "STRUCTURE CHANGE: " + from_direction + " to " + to_direction;
    }

    return impact;
}

//+------------------------------------------------------------------+
//| Count Active Trades Affected by CHoCH         |
//+------------------------------------------------------------------+
string GetCHoCHTradeImpact()
{
    int buyTrades = 0;
    int sellTrades = 0;
    int totalTrades = 0;
    double totalExposure = 0.0;
    double unrealizedPL = 0.0;

    for(int i = OrdersTotal() - 1; i >= 0; i--) {
        if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if(OrderSymbol() != Symbol()) continue;

            string comment = OrderComment();
            if(StringFind(comment, "AUTO_BUY_") == 0) {
                buyTrades++;
                totalTrades++;
                totalExposure += OrderLots();
                unrealizedPL += OrderProfit() + OrderSwap() + OrderCommission();
            }
            else if(StringFind(comment, "AUTO_SELL_") == 0) {
                sellTrades++;
                totalTrades++;
                totalExposure += OrderLots();
                unrealizedPL += OrderProfit() + OrderSwap() + OrderCommission();
            }
        }
    }

    if(totalTrades == 0) {
        return "No automated trades affected";
    }

    string impact = IntegerToString(totalTrades) + " trades affected: " +
                    IntegerToString(buyTrades) + " BUY, " +
                    IntegerToString(sellTrades) + " SELL | " +
                    "Risk: " + DoubleToString(totalExposure, 2) + " lots | " +
                    "P/L: " + DoubleToString(unrealizedPL, 2);

    return impact;
}

//+------------------------------------------------------------------+
//| CHoCH Alert Priority System                                     |
//+------------------------------------------------------------------+
void ProcessCHoCHAlertWithPriority(string symbol, int timeframe, int flow, double price)
{
// CHoCH alerts have HIGHEST PRIORITY - bypass normal alert queuing
    static datetime lastCHoCHAlert = 0;
    datetime currentTime = Time[0];

// Prevent duplicate alerts on the same bar (but allow immediate processing)
    if(currentTime == lastCHoCHAlert) return;
    lastCHoCHAlert = currentTime;

    string timeframeStr = tftransformation(timeframe);
    string flowDirection = (flow == 1 ? "BULLISH" : (flow == 2 ? "BEARISH" : "NEUTRAL"));

// === IMMEDIATE HIGH-PRIORITY ALERT ===
    string criticalAlert = "!!! CHoCH EMERGENCY !!!\n" +
                           symbol + " " + timeframeStr + " CHoCH to " + flowDirection + "\n" +
                           "Price: " + DoubleToString(price, Digits) + "\n" +
                           "CLOSE ALL TRADES NOW!";

// Send immediately regardless of other alert settings
    Alert(criticalAlert);
    SendNotification("[EMERGENCY] CHoCH: " + symbol + " " + timeframeStr + " - CLOSE TRADES!");

// Log the emergency alert
    Print("*** CHoCH EMERGENCY ALERT SENT ***");
    Print("- HIGHEST PRIORITY alert for immediate action");
    Print("- All normal alert queuing bypassed");
}

//+------------------------------------------------------------------+
//| CHoCH Alert Statistics and Monitoring                          |
//+------------------------------------------------------------------+
string GetCHoCHAlertStats()
{
    static int chochAlertsToday = 0;
    static datetime lastResetTime = 0;

// Reset daily statistics
    if(TimeDay(Time[0]) != TimeDay(lastResetTime)) {
        chochAlertsToday = 0;
        lastResetTime = Time[0];
    }

// Increment counter when CHoCH detected
    if(LAST_LEG0flow == 1) {
        chochAlertsToday++;
    }

    string stats = "CHoCH ALERTS: " + IntegerToString(chochAlertsToday) + " today | " +
                   "Status: " + (LAST_LEG0flow == 1 ? "ACTIVE" : "MONITORING");

    return stats;
}

//+------------------------------------------------------------------+
//| CHoCH Alert Configuration Validation                           |
//+------------------------------------------------------------------+
bool ValidateCHoCHAlertSettings()
{
// Ensure CHoCH alerts are always enabled for safety
    if(GlobalVariableGet("SCANNERALERT") != 1 && GlobalVariableGet("SCANNERALERTMOBILE") != 1) {
        Print("WARNING: Both terminal and mobile alerts are disabled!");
        Print("CHoCH alerts are CRITICAL for trade safety - consider enabling at least one method");
        return false;
    }

    return true;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void InitializeEnhancedCHoCHAlerts()
{
// Validate CHoCH alert settings
    if(!ValidateCHoCHAlertSettings()) {
        Print("CHoCH Alert validation failed - review alert settings");
    }

// Event-driven logging for CHoCH alert initialization
    Print("*** ENHANCED CHoCH ALERTS INITIALIZED ***");
    Print("- Emergency Mode: ", (ALERT_CHOCH_EMERGENCY_MODE ? "ENABLED" : "DISABLED"));
    Print("- Show Trade Impact: ", (ALERT_CHOCH_SHOW_IMPACT ? "ENABLED" : "DISABLED"));
    Print("- Auto-Exit Confirmation: ", (ALERT_CHOCH_AUTO_CONFIRM ? "ENABLED" : "DISABLED"));
    Print("- Integration with Task 10: ACTIVE");
    Print("- CHoCH Detection: Monitoring LAST_LEG0flow for value = 1");
}

//+------------------------------------------------------------------+
//| Get SD Zone Type Description                   |
//+------------------------------------------------------------------+
string GetSDZoneTypeDescription(int flow, bool isSOURCE, bool isOnTrend)
{
    string zoneType = "";
    string zoneCharacter = "";
    string trendContext = "";

// Determine zone type based on flow direction
    if(flow == 1) {
        zoneType = "Bullish Demand Zone";
        zoneCharacter = "[BUYING PRESSURE]";
    }
    else if(flow == 2) {
        zoneType = "Bearish Supply Zone";
        zoneCharacter = "[SELLING PRESSURE]";
    }
    else {
        zoneType = "Neutral Zone";
        zoneCharacter = "[UNCLEAR BIAS]";
    }

// Add SOURCE designation if applicable
    if(isSOURCE) {
        zoneType = "KEY " + zoneType + " (SOURCE)";
    }

// Add trend context
    if(isOnTrend) {
        trendContext = " - On Trend";
    }
    else {
        trendContext = " - Counter Trend";
    }

    return zoneType + " " + zoneCharacter + trendContext;
}

//+------------------------------------------------------------------+
//| Get Trading Setup Guidance                     |
//+------------------------------------------------------------------+
string GetSDZoneSetupGuidance(int flow, bool isSOURCE, bool isOnTrend, string symbol, double currentPrice)
{
    string guidance = "";
    string setupType = "";
    string riskLevel = "";

// Determine setup type and risk level
    if(isSOURCE && isOnTrend) {
        setupType = "HIGH PROBABILITY SETUP";
        riskLevel = "MODERATE RISK";
    }
    else if(isSOURCE && !isOnTrend) {
        setupType = "REVERSAL SETUP";
        riskLevel = "HIGHER RISK";
    }
    else if(!isSOURCE && isOnTrend) {
        setupType = "CONTINUATION SETUP";
        riskLevel = "LOWER RISK";
    }
    else {
        setupType = "COUNTER-TREND SETUP";
        riskLevel = "HIGH RISK";
    }

// Create specific guidance based on flow
    if(flow == 1) {
        guidance = ">>> POTENTIAL BUY OPPORTUNITY <<<\n" +
                   "Setup: " + setupType + " | Risk: " + riskLevel + "\n" +
                   "Action: Look for bullish confirmation at " + DoubleToString(currentPrice, Digits);
    }
    else if(flow == 2) {
        guidance = ">>> POTENTIAL SELL OPPORTUNITY <<<\n" +
                   "Setup: " + setupType + " | Risk: " + riskLevel + "\n" +
                   "Action: Look for bearish confirmation at " + DoubleToString(currentPrice, Digits);
    }
    else {
        guidance = ">>> NEUTRAL ZONE INTERACTION <<<\n" +
                   "Setup: WAIT FOR DIRECTION | Risk: UNDEFINED\n" +
                   "Action: Monitor for clear bias development";
    }

    return guidance;
}

//+------------------------------------------------------------------+
//| Calculate Zone Strength                        |
//+------------------------------------------------------------------+
string GetSDZoneStrength(string symbol, int timeframe, int flow, bool isSOURCE)
{
    string strength = "";

// Base strength on zone type and timeframe
    int timeframeWeight = 1;
    switch(timeframe) {
    case 1440:
        timeframeWeight = 5;
        break;    // D1 - Very Strong
    case 240:
        timeframeWeight = 4;
        break;    // H4 - Strong
    case 60:
        timeframeWeight = 3;
        break;    // H1 - Moderate-Strong
    case 15:
        timeframeWeight = 2;
        break;    // M15 - Moderate
    case 5:
        timeframeWeight = 1;
        break;    // M5 - Weak
    case 1:
        timeframeWeight = 1;
        break;    // M1 - Weak
    default:
        timeframeWeight = 2;
        break;
    }

    int zoneScore = timeframeWeight;

// Increase score for SOURCE zones
    if(isSOURCE) {
        zoneScore += 2;
    }

// Increase score for clear directional flow
    if(flow == 1 || flow == 2) {
        zoneScore += 1;
    }

// Classify strength
    if(zoneScore >= 6) {
        strength = "VERY STRONG";
    }
    else if(zoneScore >= 4) {
        strength = "STRONG";
    }
    else if(zoneScore >= 3) {
        strength = "MODERATE";
    }
    else {
        strength = "WEAK";
    }

    return strength + " (" + IntegerToString(zoneScore) + "/7)";
}

//+------------------------------------------------------------------+
//| SD Zone Alert Statistics and Monitoring                        |
//+------------------------------------------------------------------+
string GetSDZoneAlertStats()
{
    static int sourceAlertsToday = 0;
    static int poiAlertsToday = 0;
    static datetime lastResetTime = 0;

// Reset daily statistics
    if(TimeDay(Time[0]) != TimeDay(lastResetTime)) {
        sourceAlertsToday = 0;
        poiAlertsToday = 0;
        lastResetTime = Time[0];
    }

    string stats = "SD ALERTS: SOURCE(" + IntegerToString(sourceAlertsToday) +
                   ") POI(" + IntegerToString(poiAlertsToday) + ") today";

    return stats;
}

//+------------------------------------------------------------------+
//| Initialize Enhanced SD Zone Alert System                       |
//+------------------------------------------------------------------+
void InitializeEnhancedSDZoneAlerts()
{
// Event-driven logging for SD zone alert initialization
    Print("*** ENHANCED SD ZONE ALERTS INITIALIZED ***");
    Print("- Show Zone Strength: ", (ALERT_SD_SHOW_STRENGTH ? "ENABLED" : "DISABLED"));
    Print("- Setup Guidance: ", (ALERT_SD_SHOW_SETUP_GUIDANCE ? "ENABLED" : "DISABLED"));
    Print("- Prioritize SOURCE: ", (ALERT_SD_PRIORITIZE_SOURCE ? "ENABLED" : "DISABLED"));
    Print("- Filter Weak Zones: ", (ALERT_SD_FILTER_WEAK_ZONES ? "ENABLED" : "DISABLED"));
    Print("- Integration with ALERT_PUSH: ACTIVE");
    Print("- SOURCE mitigation events: HIGHEST PRIORITY");
}

//+------------------------------------------------------------------+
//| Get Order Block Type and Characteristics       |
//+------------------------------------------------------------------+
string GetOrderBlockTypeDescription(int flow, double obPrice, string symbol, int timeframe)
{
    string obType = "";
    string obCharacter = "";
    string priceContext = "";

// Determine Order Block type based on flow direction
    if(flow == 1) {
        obType = "Bullish Order Block";
        obCharacter = "[INSTITUTIONAL BUYING]";
    }
    else if(flow == 2) {
        obType = "Bearish Order Block";
        obCharacter = "[INSTITUTIONAL SELLING]";
    }
    else {
        obType = "Neutral Order Block";
        obCharacter = "[UNCLEAR DIRECTION]";
    }

// Add price context
    double currentPrice = (flow == 1) ? Ask : Bid;
    double distancePoints = MathAbs(currentPrice - obPrice) / Point;

    if(distancePoints <= 50) {
        priceContext = " - IMMEDIATE PROXIMITY";
    }
    else if(distancePoints <= 150) {
        priceContext = " - CLOSE INTERACTION";
    }
    else {
        priceContext = " - DISTANT MITIGATION";
    }

    return obType + " " + obCharacter + priceContext;
}

//+------------------------------------------------------------------+
//| Get Order Block Trading Implications           |
//+------------------------------------------------------------------+
string GetOrderBlockTradingGuidance(int flow, double obPrice, string symbol, bool isInstitutional)
{
    string guidance = "";
    string setupQuality = "";
    string riskAssessment = "";

// Determine setup quality based on institutional nature
    if(isInstitutional) {
        setupQuality = "HIGH QUALITY INSTITUTIONAL SETUP";
        riskAssessment = "MODERATE RISK";
    }
    else {
        setupQuality = "STANDARD ORDER BLOCK SETUP";
        riskAssessment = "STANDARD RISK";
    }

// Create specific guidance based on flow
    if(flow == 1) {
        guidance = ">>> BULLISH ORDER BLOCK OPPORTUNITY <<<\n" +
                   "Setup Quality: " + setupQuality + " | Risk: " + riskAssessment + "\n" +
                   "Action: Look for BULLISH CONFIRMATION at " + DoubleToString(obPrice, Digits) + "\n" +
                   "Strategy: BUY on retest with proper risk management";
    }
    else if(flow == 2) {
        guidance = ">>> BEARISH ORDER BLOCK OPPORTUNITY <<<\n" +
                   "Setup Quality: " + setupQuality + " | Risk: " + riskAssessment + "\n" +
                   "Action: Look for BEARISH CONFIRMATION at " + DoubleToString(obPrice, Digits) + "\n" +
                   "Strategy: SELL on retest with proper risk management";
    }
    else {
        guidance = ">>> NEUTRAL ORDER BLOCK INTERACTION <<<\n" +
                   "Setup Quality: UNDEFINED | Risk: HIGH\n" +
                   "Action: WAIT for clear directional bias\n" +
                   "Strategy: Monitor for trend development";
    }

    return guidance;
}

//+------------------------------------------------------------------+
//| Calculate Order Block Strength                 |
//+------------------------------------------------------------------+
string GetOrderBlockStrength(string symbol, int timeframe, int flow, double obPrice)
{
    string strength = "";
    int strengthScore = 0;

// Base strength on timeframe importance
    switch(timeframe) {
    case 1440:
        strengthScore += 5;
        break;    // D1 - Very Strong
    case 240:
        strengthScore += 4;
        break;    // H4 - Strong
    case 60:
        strengthScore += 3;
        break;    // H1 - Moderate-Strong
    case 15:
        strengthScore += 2;
        break;    // M15 - Moderate
    case 5:
        strengthScore += 1;
        break;    // M5 - Weak
    case 1:
        strengthScore += 1;
        break;    // M1 - Weak
    default:
        strengthScore += 2;
        break;
    }

// Increase score for clear directional flow
    if(flow == 1 || flow == 2) {
        strengthScore += 2;
    }

// Increase score based on price proximity (closer = more relevant)
    double currentPrice = (flow == 1) ? Ask : Bid;
    double distancePoints = MathAbs(currentPrice - obPrice) / Point;

    if(distancePoints <= 30) {
        strengthScore += 2;  // Very close
    }
    else if(distancePoints <= 100) {
        strengthScore += 1;  // Close
    }

// Classify final strength
    if(strengthScore >= 7) {
        strength = "VERY STRONG";
    }
    else if(strengthScore >= 5) {
        strength = "STRONG";
    }
    else if(strengthScore >= 3) {
        strength = "MODERATE";
    }
    else {
        strength = "WEAK";
    }

    return strength + " (" + IntegerToString(strengthScore) + "/9)";
}

//+------------------------------------------------------------------+
//| Order Block Alert Statistics and Monitoring                     |
//+------------------------------------------------------------------+
string GetOrderBlockAlertStats()
{
    static int bullishOBAlertsToday = 0;
    static int bearishOBAlertsToday = 0;
    static datetime lastResetTime = 0;

// Reset daily statistics
    if(TimeDay(Time[0]) != TimeDay(lastResetTime)) {
        bullishOBAlertsToday = 0;
        bearishOBAlertsToday = 0;
        lastResetTime = Time[0];
    }

    string stats = "OB ALERTS: Bullish(" + IntegerToString(bullishOBAlertsToday) +
                   ") Bearish(" + IntegerToString(bearishOBAlertsToday) + ") today";

    return stats;
}

//+------------------------------------------------------------------+
//| Validate Order Block Alert Settings                            |
//+------------------------------------------------------------------+
bool ValidateOrderBlockAlertSettings()
{
    if(ALERT_OB_MIN_STRENGTH < 1 || ALERT_OB_MIN_STRENGTH > 9) {
        Print("WARNING: ALERT_OB_MIN_STRENGTH should be between 1-9. Current: ", ALERT_OB_MIN_STRENGTH);
        return false;
    }

    return true;
}

//+------------------------------------------------------------------+
//| Initialize Enhanced Order Block Alert System                   |
//+------------------------------------------------------------------+
void InitializeEnhancedOrderBlockAlerts()
{
// Validate Order Block alert settings
    if(!ValidateOrderBlockAlertSettings()) {
        Print("Order Block Alert settings validation failed - using defaults");
    }

// Event-driven logging for Order Block alert initialization
    Print("*** ENHANCED ORDER BLOCK ALERTS INITIALIZED ***");
    Print("- Show OB Strength: ", (ALERT_OB_SHOW_STRENGTH ? "ENABLED" : "DISABLED"));
    Print("- Institutional Focus: ", (ALERT_OB_INSTITUTIONAL_FOCUS ? "ENABLED" : "DISABLED"));
    Print("- Show Price Levels: ", (ALERT_OB_SHOW_PRICE_LEVELS ? "ENABLED" : "DISABLED"));
    Print("- Minimum Strength: ", ALERT_OB_MIN_STRENGTH);
    Print("- Integration with ALERT_PUSH POI: ACTIVE");
    Print("- Order Block mitigation events: INSTITUTIONAL PRIORITY");
}

//+------------------------------------------------------------------+
//| Initialize Universal Alert Toggle Controls                      |
//+------------------------------------------------------------------+
void InitializeUniversalAlertToggles()
{
// Set global variables for granular alert controls
// Using Symbol() prefix to make settings chart-specific
    GlobalVariableSet(Symbol() + "_ALERT_TRADE_OPENED_POPUP", ALERT_TRADE_OPENED_POPUP ? 1 : 0);
    GlobalVariableSet(Symbol() + "_ALERT_TRADE_OPENED_MOBILE", ALERT_TRADE_OPENED_MOBILE ? 1 : 0);
    GlobalVariableSet(Symbol() + "_ALERT_BOS_POPUP", ALERT_BOS_POPUP ? 1 : 0);
    GlobalVariableSet(Symbol() + "_ALERT_BOS_MOBILE", ALERT_BOS_MOBILE ? 1 : 0);
    GlobalVariableSet(Symbol() + "_ALERT_CHOCH_POPUP", ALERT_CHOCH_POPUP ? 1 : 0);
    GlobalVariableSet(Symbol() + "_ALERT_CHOCH_MOBILE", ALERT_CHOCH_MOBILE ? 1 : 0);
    GlobalVariableSet(Symbol() + "_ALERT_SD_POPUP", ALERT_SD_POPUP ? 1 : 0);
    GlobalVariableSet(Symbol() + "_ALERT_SD_MOBILE", ALERT_SD_MOBILE ? 1 : 0);
    GlobalVariableSet(Symbol() + "_ALERT_OB_POPUP", ALERT_OB_POPUP ? 1 : 0);
    GlobalVariableSet(Symbol() + "_ALERT_OB_MOBILE", ALERT_OB_MOBILE ? 1 : 0);

// Event-driven logging for initialization (following logging principles)
    Print("*** UNIVERSAL ALERT TOGGLES INITIALIZED ***");
    Print("- Trade Opened: Popup=", (ALERT_TRADE_OPENED_POPUP ? "ON" : "OFF"),
          " | Mobile=", (ALERT_TRADE_OPENED_MOBILE ? "ON" : "OFF"));
    Print("- BOS Alerts: Popup=", (ALERT_BOS_POPUP ? "ON" : "OFF"),
          " | Mobile=", (ALERT_BOS_MOBILE ? "ON" : "OFF"));
    Print("- CHoCH Alerts: Popup=", (ALERT_CHOCH_POPUP ? "ON" : "OFF"),
          " | Mobile=", (ALERT_CHOCH_MOBILE ? "ON" : "OFF"));
    Print("- SD Zone Alerts: Popup=", (ALERT_SD_POPUP ? "ON" : "OFF"),
          " | Mobile=", (ALERT_SD_MOBILE ? "ON" : "OFF"));
    Print("- Order Block Alerts: Popup=", (ALERT_OB_POPUP ? "ON" : "OFF"),
          " | Mobile=", (ALERT_OB_MOBILE ? "ON" : "OFF"));
    Print("- Universal Alert Control Status: ", GetUniversalAlertStatus());
}

//+------------------------------------------------------------------+
//| Get Universal Alert System Status                               |
//+------------------------------------------------------------------+
string GetUniversalAlertStatus()
{
    int totalPopupEnabled = 0;
    int totalMobileEnabled = 0;
    int totalAlertTypes = 5; // Trade, BOS, CHoCH, SD, OB

// Count enabled alert types
    if(GlobalVariableGet(Symbol() + "_ALERT_TRADE_OPENED_POPUP") == 1) totalPopupEnabled++;
    if(GlobalVariableGet(Symbol() + "_ALERT_BOS_POPUP") == 1) totalPopupEnabled++;
    if(GlobalVariableGet(Symbol() + "_ALERT_CHOCH_POPUP") == 1) totalPopupEnabled++;
    if(GlobalVariableGet(Symbol() + "_ALERT_SD_POPUP") == 1) totalPopupEnabled++;
    if(GlobalVariableGet(Symbol() + "_ALERT_OB_POPUP") == 1) totalPopupEnabled++;

    if(GlobalVariableGet(Symbol() + "_ALERT_TRADE_OPENED_MOBILE") == 1) totalMobileEnabled++;
    if(GlobalVariableGet(Symbol() + "_ALERT_BOS_MOBILE") == 1) totalMobileEnabled++;
    if(GlobalVariableGet(Symbol() + "_ALERT_CHOCH_MOBILE") == 1) totalMobileEnabled++;
    if(GlobalVariableGet(Symbol() + "_ALERT_SD_MOBILE") == 1) totalMobileEnabled++;
    if(GlobalVariableGet(Symbol() + "_ALERT_OB_MOBILE") == 1) totalMobileEnabled++;

    string status = "UNIVERSAL ALERTS: ";
    status += "Popup(" + IntegerToString(totalPopupEnabled) + "/" + IntegerToString(totalAlertTypes) + ") ";
    status += "Mobile(" + IntegerToString(totalMobileEnabled) + "/" + IntegerToString(totalAlertTypes) + ")";

    return status;
}

//+------------------------------------------------------------------+
//| Validate Universal Alert Settings                               |
//+------------------------------------------------------------------+
bool ValidateUniversalAlertSettings()
{
// Check if at least one delivery method is enabled for critical alerts
    bool criticalAlertsEnabled = false;

// CHoCH and Trade Opening alerts are considered critical for safety
    if((GlobalVariableGet(Symbol() + "_ALERT_CHOCH_POPUP") == 1 ||
            GlobalVariableGet(Symbol() + "_ALERT_CHOCH_MOBILE") == 1) &&
            (GlobalVariableGet(Symbol() + "_ALERT_TRADE_OPENED_POPUP") == 1 ||
             GlobalVariableGet(Symbol() + "_ALERT_TRADE_OPENED_MOBILE") == 1)) {
        criticalAlertsEnabled = true;
    }

    if(!criticalAlertsEnabled) {
        Print("WARNING: Critical alerts (CHoCH and Trade Opening) should have at least one delivery method enabled!");
        Print("Consider enabling either popup or mobile notifications for safety.");
        return false;
    }

    return true;
}

//+------------------------------------------------------------------+
//| Check if specific alert type is enabled for popup delivery      |
//+------------------------------------------------------------------+
bool IsAlertPopupEnabled(string alertType)
{
    string globalVarName = Symbol() + "_ALERT_" + alertType + "_POPUP";
    return (GlobalVariableGet(globalVarName) == 1);
}

//+------------------------------------------------------------------+
//| Check if specific alert type is enabled for mobile delivery     |
//+------------------------------------------------------------------+
bool IsAlertMobileEnabled(string alertType)
{
    string globalVarName = Symbol() + "_ALERT_" + alertType + "_MOBILE";
    return (GlobalVariableGet(globalVarName) == 1);
}

//+------------------------------------------------------------------+
//| Enhanced alert delivery function with granular controls         |
//+------------------------------------------------------------------+
void SendUniversalAlert(string alertType, string terminalMessage, string mobileMessage)
{
// Check master alert switches first (existing behavior)
    bool masterPopupEnabled = (GlobalVariableGet("SCANNERALERT") == 1);
    bool masterMobileEnabled = (GlobalVariableGet("SCANNERALERTMOBILE") == 1);

// Check specific alert type toggles
    bool specificPopupEnabled = IsAlertPopupEnabled(alertType);
    bool specificMobileEnabled = IsAlertMobileEnabled(alertType);

// Send popup alert if both master and specific toggles are enabled
    if(masterPopupEnabled && specificPopupEnabled) {
        Alert(terminalMessage);
    }

// Send mobile notification if both master and specific toggles are enabled
    if(masterMobileEnabled && specificMobileEnabled) {
        SendNotification(mobileMessage);
    }

// Log alert delivery status for debugging (only if DEBUGMODE is enabled)
    if(DEBUGMODE) {
        Print("ALERT DELIVERY [", alertType, "]: Popup=",
              (masterPopupEnabled && specificPopupEnabled ? "SENT" : "BLOCKED"),
              " | Mobile=",
              (masterMobileEnabled && specificMobileEnabled ? "SENT" : "BLOCKED"));
    }
}

//+------------------------------------------------------------------+
//| Get SD Zone Strength Assessment                                 |
//+------------------------------------------------------------------+
string GetSDZoneStrength(string symbol, int timeframe, int flow, double price, bool isSOURCE)
{
    string strength = "";
    int zoneScore = 0;

// Base score from timeframe
    int timeframeWeight = 0;
    switch(timeframe) {
    case PERIOD_H4:
    case PERIOD_D1:
        timeframeWeight = 3;
        break;    // Strong timeframes
    case PERIOD_H1:
        timeframeWeight = 2;
        break;    // Medium timeframes
    case PERIOD_M15:
    case PERIOD_M30:
        timeframeWeight = 1;
        break;    // Weaker timeframes
    default:
        timeframeWeight = 1;
        break;
    }

    zoneScore = timeframeWeight;

// Increase score for SOURCE zones
    if(isSOURCE) {
        zoneScore += 3;
    }

// Increase score for clear directional flow
    if(flow == 1 || flow == 2) {
        zoneScore += 1;
    }

// Classify strength
    if(zoneScore >= 6) {
        strength = "VERY STRONG";
    }
    else if(zoneScore >= 4) {
        strength = "STRONG";
    }
    else if(zoneScore >= 3) {
        strength = "MODERATE";
    }
    else {
        strength = "WEAK";
    }

    return strength + " (" + IntegerToString(zoneScore) + "/7)";
}

//+------------------------------------------------------------------+
//| Get SD Zone Trading Guidance                                    |
//+------------------------------------------------------------------+
string GetSDZoneTradingGuidance(int flow, double price, string symbol, bool isSOURCE)
{
    string guidance = "";
    string setupType = "";
    string riskLevel = "";

    if(isSOURCE) {
        setupType = "PREMIUM SOURCE ZONE SETUP";
        riskLevel = "LOW RISK";
    }
    else {
        setupType = "STANDARD SD ZONE SETUP";
        riskLevel = "MODERATE RISK";
    }

    if(flow == 1) {
        guidance = setupType + " - BUY OPPORTUNITY | " + riskLevel;
    }
    else if(flow == 2) {
        guidance = setupType + " - SELL OPPORTUNITY | " + riskLevel;
    }
    else {
        guidance = setupType + " - NEUTRAL ZONE | HIGHER RISK";
    }

    return guidance;
}
//+------------------------------------------------------------------+
