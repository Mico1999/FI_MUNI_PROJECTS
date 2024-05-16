package cz.muni.fi.pv168.project.ui.model;

import cz.muni.fi.pv168.project.model.EventModel;
import cz.muni.fi.pv168.project.model.StatusOptions;

import javax.swing.*;

/**
 * Functionality for stats calculation, displayed on the bottom of the application.
 * Calculates the number of events in progress, done events and total events.
 */
public final class EventStats {

    private EventStats(){
        throw new AssertionError();
    }

    public static Integer getAllEventsCount(JTable table){
        EventTableModel eventTableModel = (EventTableModel) table.getModel();
        return eventTableModel.getEvents().size();
    }

    public static Integer getEventsCount(JTable table, StatusOptions status){
        EventTableModel eventTableModel = (EventTableModel) table.getModel();
        Integer count = 0;
        for (EventModel event : eventTableModel.getEvents()) {
            if (event.getStatus() == status){
                count++;
            }
        }
        return count;
    }
}
