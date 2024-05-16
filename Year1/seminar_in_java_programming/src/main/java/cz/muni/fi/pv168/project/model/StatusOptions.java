package cz.muni.fi.pv168.project.model;

/**
 * Status options in {@link EventModel} to track progress of an event.
 */
public enum StatusOptions {
    PLANNED("Planned"),
    DOING("Doing"),
    DONE("Done");

    private final String text;

    StatusOptions(String text){
        this.text = text;
    }

    public static StatusOptions parse(String str){
        StatusOptions status;
        try {
            status = StatusOptions.valueOf(str == null ? "INVALID" : str);
        }
        catch(IllegalArgumentException e){
            throw e;
        }
        return status;
    }

    public String getText() {
        return text;
    }
}