package cz.muni.fi.pv168.project.model;

/**
 * Options for duration field used in {@link DurationModel}
 */
public enum DurationOption {
    NONE("none"),
    DAYS("days"),
    HOURS("hours"),
    MINUTES("mins");

    private String text;
    DurationOption(String text){
        this.text = text;
    }

    public String getText() {
        return text;
    }
}
