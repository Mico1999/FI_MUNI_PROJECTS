package cz.muni.fi.pv168.project.model;

import java.time.LocalDate;

/**
 * Model representing filter for events, used by user via Set Filter button. User can filter events
 * by event status, date range and category.
 */
public class FilterModel {
    private boolean planned;
    private boolean done;
    private boolean inProgress;
    private LocalDate from;
    private LocalDate to;
    private String category;

    public void setPlanned(boolean value) {
        this.planned = value;
    }

    public void setDone(boolean value) {
        this.done = value;
    }

    public void setInProgress(boolean value) {
        this.inProgress = value;
    }

    public void setFrom(LocalDate from) {
        this.from = from;
    }

    public void setTo(LocalDate to) {
        this.to = to;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public boolean getPlanned() {
        return this.planned;
    }

    public boolean getDone() {
        return this.done;
    }

    public boolean getInProgress() {
        return this.inProgress;
    }

    public LocalDate getFrom() {
        return this.from;
    }

    public LocalDate getTo() {
        return this.to;
    }

    public String getCategory() {
        return this.category;
    }

}
