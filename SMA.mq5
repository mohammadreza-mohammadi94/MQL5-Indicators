//+------------------------------------------------------------------+
//|                        Simple Moving Average Indicator (SMA.mq5) |
//|                         Author: Mohammadreza Mohammadi          |
//|                         Email: mr.mhmdi93@gmail.com             |
//+------------------------------------------------------------------+

#property copyright "Mohammadreza Mohammadi"
#property link      "mr.mhmdi93@gmail.com"
#property version   "1.00"
#property indicator_chart_window        // This indicator will be displayed in the main chart window
#property indicator_buffers 1           // Defining one buffer for storing indicator values
#property indicator_plots   1           // Defining one plot for visualization

//--- Defining the properties of the indicator plot (Moving Average Line)
#property indicator_label1  "MA"        // Label for the indicator
#property indicator_type1   DRAW_LINE   // Drawing type: Line
#property indicator_color1  clrRed      // Line color: Red
#property indicator_style1  STYLE_SOLID // Line style: Solid
#property indicator_width1  1           // Line width: 1

//--- Input parameters for the indicator
input int MA_Period=15;    // Moving Average period (number of bars used in calculation)
input int MA_Shift=0;      // Horizontal shift in bars (delays the MA line)

//--- Buffer to store computed moving average values
double MABuffer[];

//+------------------------------------------------------------------+
//| Initialization function (runs once when the indicator is loaded) |
//+------------------------------------------------------------------+
int OnInit()
  {
   //--- Mapping the buffer to the indicator
   SetIndexBuffer(0, MABuffer,INDICATOR_DATA);
   
   //--- Ensuring the indicator starts drawing from a valid bar (avoiding early gaps)
   PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, MA_Period);
   
   //--- Applying horizontal shift to the indicator (if any)
   PlotIndexSetInteger(0, PLOT_SHIFT, MA_Shift);

   //--- Initialization successful
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Iterative calculation function (executes on each new tick)       |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[])
  {
   //--- Ensure we have enough data to compute the moving average
   if (rates_total < begin + MA_Period - 1)
    {
        return (0); // Not enough data, exit function
    }
   
   int first, bar, iii;
   double SUM, SMA;
   
   //--- Determine the starting point for calculations
   if(prev_calculated == 0)
     {
        first  = begin + MA_Period - 1; // Start from the first valid index
     }
   else
     {
        first = prev_calculated - 1; // Resume from the last calculated bar
     }
   
   //--- Loop through bars and compute SMA
   for(bar = first; bar < rates_total; bar++)
     {
        SUM = 0.0;  // Reset sum for each bar
        
        //--- Sum up the prices over the MA period
        for(iii=0; iii < MA_Period; iii++)
            {
                SUM += price[bar - iii];
            }
        
        //--- Compute SMA value
        SMA = SUM / MA_Period;
        
        //--- Store computed SMA in the buffer
        MABuffer[bar] = SMA;
     }
        
   //--- Return the total number of bars processed for the next execution
   return(rates_total);
  }
