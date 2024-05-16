package cz.muni.fi.pv168.project.model;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Model representing repeatable events, added via Event+ button by user.
 * Events are repeated between given dates in given interval.
 */
public class RepeatableEventModel {

    private final List<EventModel> eventModelList = new ArrayList<>();
    private LocalDate from;
    private LocalDate to;
    private EventIntervalOptions interval;

    public void setFrom(LocalDate from) {
        this.from = from;
    }

    public LocalDate getFrom() { return this.from; }

    public void setTo(LocalDate to) {
        this.to = to;
    }

    public LocalDate getTo() { return this.to; }

    public void setInterval(EventIntervalOptions interval) {
        this.interval = interval;
    }

    public EventIntervalOptions getInterval() {return this.interval; }

    public List<EventModel> getEventModelList() {
        return eventModelList;
    }
}
