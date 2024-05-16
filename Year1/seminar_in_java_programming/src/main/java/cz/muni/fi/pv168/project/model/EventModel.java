package cz.muni.fi.pv168.project.model;

import java.time.LocalDate;
import java.util.Objects;

/**
 * Model representing events in database, added via Event+ button or importing from CSV file by user.
 * Attribute status represents progress of an event.
 */
public class EventModel {
    private LocalDate date;

    private DurationModel duration;

    private String name;

    private String description;

    private CategoryModel categoryModel;

    private StatusOptions status;

    private Long id;

    public EventModel(LocalDate date, DurationModel duration, String name, String description,
                      StatusOptions status, CategoryModel categoryModel, Long id) {
        setDate(date);
        setDuration(duration);
        setName(name);
        setDescription(description);
        setCategoryModel(categoryModel);
        setStatus(status);
        setId(id);
    }

    public EventModel(LocalDate date, DurationModel duration, String name, String description,
                      StatusOptions status, CategoryModel categoryModel) {
        setDate(date);
        setDuration(duration);
        setName(name);
        setDescription(description);
        setCategoryModel(categoryModel);
        setStatus(status);
    }

    public EventModel() {}

    public LocalDate getDate() {
        return this.date;
    }

    public void setDate(LocalDate date) {

        this.date = Objects.requireNonNull(date, "date must not be null");
    }

    public DurationModel getDuration() {
        return this.duration;
    }

    public void setDuration(Integer value, DurationOption option) {
        this.duration = new DurationModel(value, option);
    }

     public void setDuration(DurationModel duration){
        if (duration == null){
            this.duration = new DurationModel();
        } else {
            this.setDuration(duration.getValue(), duration.getOption());
        }
     }

    public String getDurationText(){
        if (duration == null) {
            this.duration = new DurationModel();
        }
        return this.duration.getDurationText();
    }

    public void setDurationOption(DurationOption durationOption) {
        this.setDuration(this.duration.getValue(), durationOption);
    }

    public String getName() { return this.name; }

    public void setName(String name) {

        this.name = Objects.requireNonNull(name, "name must not be null");
    }

    public String getDescription() { return this.description; }

    public void setDescription(String description) {
        this.description = Objects.requireNonNullElse(description, "");
    }

    public CategoryModel getCategoryModel() { return this.categoryModel; }

    public void setCategoryModel(CategoryModel categoryModel) {
        this.categoryModel = categoryModel;
    }

    public StatusOptions getStatus() { return this.status; }

    public String getStatusText() { return this.status.getText(); }

    public void setStatus(StatusOptions status) {
        this.status = status;
    }

    public Long getId() {
        return this.id;
    }

    public void setId(Long id) {
        this.id = Objects.requireNonNull(id, "when setting id, it must not be null");
    }

}
