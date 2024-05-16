package cz.muni.fi.pv168.project.model;

import cz.muni.fi.pv168.project.ui.model.EventTableModel;

import java.time.LocalDate;

/**
 * Functionality for generation of repeatable events between dates
 * in interval selected by user when adding a repeatable event.
 */
public class RepeatableEventsGenerator {
    public static void generate(RepeatableEventModel repeatableEventModel, EventTableModel eventTableModel){
        LocalDate from = repeatableEventModel.getFrom();
        LocalDate to = repeatableEventModel.getTo();
        EventIntervalOptions interval = repeatableEventModel.getInterval();

        for (LocalDate date = incrementDate(interval, from); date.isBefore(to) || date.isEqual(to); date = incrementDate(interval, date))
        {
            EventModel newEvent = copyEvent(repeatableEventModel.getEventModelList().get(0), date);
            eventTableModel.addRow(newEvent);
            repeatableEventModel.getEventModelList().add(newEvent);
        }
    }

    private static LocalDate incrementDate(EventIntervalOptions interval, LocalDate date){
        if (interval == EventIntervalOptions.MONTHS){
            date = date.plusMonths(1);
        } else if (interval == EventIntervalOptions.WEEKS){
            date = date.plusWeeks(1);
        }
        else {
            date = date.plusDays(1);
        }
        return date;
    }

    private static EventModel copyEvent(EventModel eventModel, LocalDate date){
        return new EventModel(date,eventModel.getDuration(),
                eventModel.getName(),eventModel.getDescription(),
                eventModel.getStatus(), eventModel.getCategoryModel());
    }
}
