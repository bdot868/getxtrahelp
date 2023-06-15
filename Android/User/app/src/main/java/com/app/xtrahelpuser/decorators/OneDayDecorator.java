package com.app.xtrahelpuser.decorators;

import android.graphics.Typeface;
import android.os.Build;
import android.text.style.RelativeSizeSpan;
import android.text.style.StyleSpan;

import androidx.annotation.RequiresApi;

import com.prolificinteractive.materialcalendarview.CalendarDay;
import com.prolificinteractive.materialcalendarview.DayViewDecorator;
import com.prolificinteractive.materialcalendarview.DayViewFacade;

import java.time.LocalDate;


/**
 * Decorate a day by making the text big and bold
 */
public class OneDayDecorator implements DayViewDecorator {

  private CalendarDay date;

  public OneDayDecorator() {
    date = CalendarDay.today();
  }

  @Override
  public boolean shouldDecorate(CalendarDay day) {
    return date != null && day.equals(date);
  }

  @Override
  public void decorate(DayViewFacade view) {
    view.addSpan(new StyleSpan(Typeface.BOLD));
    view.addSpan(new RelativeSizeSpan(1.4f));
  }



  @RequiresApi(api = Build.VERSION_CODES.O)
  public void setDate(LocalDate date) {
    this.date = CalendarDay.from(date.getYear(),date.getMonthValue(),date.getDayOfMonth());
  }
}
