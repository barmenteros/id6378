# GitHub Copilot Custom Instructions for Web24hub EA Project

## Project Overview
This is a MetaTrader 4 (MT4) Expert Advisor modification project. We've modified an existing EA (originally called "FXOB EA") to create "Web24hub EA" - an automated trading system based on Smart Money Concepts (SMC) and Inner Circle Trader (ICT) methodologies. The EA name and metadata have been updated to reflect the new project identity.

## Core Architecture
- **Language**: MQL4
- **Base**: Modified from original FXOB EA codebase (12,000+ lines of MQL4 code)
- **Current Name**: Web24hub EA (updated `#property` fields and `string vers` variable)
- **Approach**: Modification and enhancement of existing proven codebase
- **Target Timeframes**: Primarily M15 and H1
- **Scope**: Single currency pair EA

## Trading Logic Implementation
### Entry Conditions
- **Buy Trades**: Demand Zone (DZ) OR Order Block (OB) + Fair Value Gap (FVG) simultaneously
- **Sell Trades**: Supply Zone (SZ) OR Order Block (OB) + Fair Value Gap (FVG) simultaneously

### Exit Conditions
- **Buy Trades**: Take Profit reached OR Higher High (HH) formation
- **Sell Trades**: Take Profit reached OR Lower Low (LL) formation
- **Both**: Change of Character (CHoCH) during active trade
- **BOS Handling**: Differentiate minor vs major Break of Structure (ignore minor BOS)

### Key Functions to Leverage
- `ORDERBLOCK` - Order block detection
- `FVGfunc` - Fair Value Gap identification
- `ORDERBLOCKshow` - Structure analysis including CHoCH/BOS
- `TAKEPROFIT_signature` - TP calculations
- `RISKSIZE_TMANAGER` and `calcolosize` - Lot sizing

## Risk Management Parameters
- Default 1% risk per trade (adjustable via `Risk Lotsize Percentage`)
- Maximum market orders limit (`max` parameter)
- Maximum drawdown protection (auto-close all trades)
- Step profit trailing stop (`ltrailingstop`, `strailingstop`)
- Hidden SL/TP options (`hidesl`, `hidetp`)

## Alert System Requirements
### Alert Types Needed
- Trades opened
- BOS occurrences
- CHoCH occurrences
- Supply/Demand zone activation
- Order Block formation
- Mitigation alerts (already exists)

### Implementation
- Individual on/off toggles for each alert type
- Dual delivery: MT4 terminal (`Alert()`) + mobile (`SendNotification()`)
- Use existing `ALERT_PUSH` and `ALERTPOPUP` functions

## Critical Input Parameters
```mql4
input string TicketComment;
input int Magic;
input int max; // max market orders
input double Risk_Lotsize_Percentage = 1.0;
input bool isbrokerecn;
input bool hidesl, hidetp;
input int lstoploss, sstoploss; // pips
input int ltrailingstop, strailingstop; // pips
input int slippage;
input bool sleeping;
input int sleepingminutes;
```

## Key Functions and Components
- **Trade Management**: `TDMNG`, `protect`, `protect_new`
- **Risk Management**: `CLOSE_ALL_AT_EQUITY`, `CloseOrderALL`
- **GUI Elements**: `Create_Button`, `BUTXTD1_NUMB`
- **Structure Detection**: `LAST_LEG0flow`, `CHoCHorBOS`
- **Sessions**: Asia, London, NY timing indicators

## Performance Considerations
- Monitor multiple SMC/ICT objects across timeframes efficiently
- Optimize `OnTick` function for real-time analysis
- Prevent lag while processing complex algorithms
- Handle 12,000+ lines of existing code without regressions

## Development Context
- **Timeline**: ~2 months development cycle
- **Testing Requirements**: Unit tests, integration tests, backtesting via Strategy Tester
- **Broker Compatibility**: ECN and standard broker support
- **Project ID**: 3RYNCTGDJ6DYLE6R1XOX2K2O

## Common Issue Areas to Watch
- Trade entry timing with multiple condition validation
- BOS/CHoCH detection accuracy and timing
- Hidden SL/TP management without broker integration
- Multi-timeframe object synchronization
- Alert system reliability across terminal and mobile
- Lot size calculations based on risk percentage
- Performance optimization with complex real-time analysis

When addressing issues, always consider the existing Web24hub EA structure and leverage its proven components rather than rebuilding functionality.
