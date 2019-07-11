#property copyright "Copyright 2019, R.Cocetta <r.cocetta@gmail.com>"
#property version "1.00"
#property strict

extern int MinTicksPerPeriod = 60;
int ticksPerPeriod     = 0;
int checkedPeriods     = 0;
int periodsNum         = 0;
int problematicPeriods = 0;
int lastCheckedPeriod  = NULL;

int lastCheckedDayOfWeek;
int lastCheckedDay;
int lastCheckedHour;

void OnInit() {
   Print("Data checker started");
   lastCheckedDayOfWeek = DayOfWeek();
   lastCheckedHour = Hour();
   lastCheckedDay = 0;
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

int CheckMissingDay(){
      
   int diff = Day() - lastCheckedDay;
   if ((diff > 1) && (lastCheckedDayOfWeek != FRIDAY))
      return diff;
      
   if (diff > 2) return diff;

   return 0;
} 


void OnTick() {
   int dayDiff;
   if (!hasPeriodChanged()) {
      ticksPerPeriod++;
   } else {
      //close the period
      if (ticksPerPeriod < MinTicksPerPeriod) {
         PrintFormat("Problem: %d-%d-%d h%d - this period has less than the expected number of ticks (%d / %d)", Year(), Month(), Day(), Hour(), ticksPerPeriod, MinTicksPerPeriod);
         problematicPeriods++;
         ticksPerPeriod = 0;
      }
      PrintFormat("%d-%d", lastCheckedDay, Day());
      dayDiff = CheckMissingDay();
      if (dayDiff  > 0) {
         PrintFormat("Missing %d Days before %d-%d-%d ", dayDiff, Year(), Month(), Day());
         problematicPeriods+=dayDiff;
      }
      lastCheckedDayOfWeek = DayOfWeek();
      lastCheckedDay = Day();
   }
}


void OnDeinit(const int reason) {
   Print("Report ----- "); 
   Print("Periods Checked: " + checkedPeriods);
   Print("Problematic Periods: " + problematicPeriods);
   Print("TODO: Number of expected periods");
    
}