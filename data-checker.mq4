#property copyright "Copyright 2019, R.Cocetta <r.cocetta@gmail.com>"
#property version "1.00"
#property strict

extern int MinTicksPerPeriod = 60;
int ticksPerPeriod     = 0;
int checkedPeriods     = 0;
int periodsNum         = 0;
int problematicPeriods = 0;
int lastCheckedPeriod  = NULL;

void OnInit() {
   Print("Data checker started");
}

bool hasPeriodChanged() {
   if (Period() == PERIOD_H1) {
      
      if (lastCheckedPeriod != Hour()) {
         lastCheckedPeriod = Hour();
         checkedPeriods++;
         return true;
      };
      return false;
   }
   return false;
}

void OnTick() {
   if (!hasPeriodChanged()) {
      ticksPerPeriod++;
   } else {
      //close the period
      if (ticksPerPeriod < MinTicksPerPeriod) {
         PrintFormat("Problem: %d-%d-%d h%d - this period has less than the expected number of ticks (%d / %d)", Year(), Month(), Day(), Hour(), ticksPerPeriod, MinTicksPerPeriod);
         problematicPeriods++;
         ticksPerPeriod = 0;
      }
   }
}


void OnDeinit(const int reason) {
   Print("Report ----- "); 
   Print("Periods Checked: " + checkedPeriods);
   Print("Problematic Periods: " + problematicPeriods);
   Print("TODO: Number of expected periods");
    
}