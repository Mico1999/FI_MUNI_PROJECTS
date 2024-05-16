package cz.muni.fi.pv168.project.model;

/**
 * Interval options for events.
 */
public enum EventIntervalOptions {
    DAYS("days"),
    WEEKS("weeks"),
    MONTHS("months");

    private final String text;

    EventIntervalOptions(String text){
        this.text = text;
    }

    public String getText() {
        return text;
    }
}
