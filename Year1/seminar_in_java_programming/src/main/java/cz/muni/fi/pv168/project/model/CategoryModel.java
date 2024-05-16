package cz.muni.fi.pv168.project.model;

import java.awt.Color;
import java.util.List;
import java.util.Objects;

/**
 * Model representing a category, which is added directly via Category+ button
 * or importing from CSV file by user.
 */
public class CategoryModel {
    private String name;
    private DurationModel defaultDuration;
    private Color defaultColor;
    private Long id;

    public static final java.util.List<Color> COLORS = List.of(
            Color.decode("#EE82EE"), Color.decode("#FA8072"),
            Color.decode("#FFA500"), Color.decode("#EEE8AA"),
            Color.decode("#98FB98"), Color.decode("#AFEEEE"),
            Color.decode("#6495ED"), Color.decode("#F5DEB3")
    );

    public CategoryModel(String name, DurationModel defaultDuration, Color defaultColor) {
        setName(name);
        setDefaultDuration(defaultDuration);
        setDefaultColor(defaultColor);
    }

    public CategoryModel(String name, DurationModel defaultDuration, Color defaultColor, Long id) {
        setName(name);
        setDefaultDuration(defaultDuration);
        setDefaultColor(defaultColor);
        setId(id);
    }

    public CategoryModel() {}

    public void setName(String name) {
        this.name = Objects.requireNonNull(name, "Name must not be null.");
    }

    public String getName() {
        return this.name;
    }

    public void setDefaultDuration(Integer value, DurationOption option) {
        this.defaultDuration = new DurationModel(value, option);
    }

    public void setDefaultDuration(DurationModel duration){
        if (duration == null){
            this.defaultDuration = new DurationModel();
        } else {
            this.setDefaultDuration(duration.getValue(), duration.getOption());
        }
    }

    public DurationModel getDefaultDuration() {
        return this.defaultDuration;
    }

    public String getDefaultDurationText(){
        return this.defaultDuration.getDurationText();
    }

    public void setDefaultColor(Color color) {
        this.defaultColor = Objects.requireNonNull(color, "Default color must not be null.");
    }

    public Color getDefaultColor() {
        return (this.defaultColor == null)? Color.white : this.defaultColor;
    }

    public String getDefaultColorText() {
        return "";
    }

    public Long getId() {
        return this.id;
    }

    public void setId(Long id) {
        this.id = Objects.requireNonNull(id, "when setting id, it must not be null");
    }

    @Override
    public String toString() {
        return name;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof CategoryModel other)) {
            return false;
        }
        if (this.name == null) {
            return false;
        }
        return name.equals(other.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name);
    }

    public int getColorIdx(Color clr){
        for(int i = 0; i < COLORS.size(); i++){
            if (COLORS.get(i).equals(clr)){
                return i;
            }
        }
        return -1;
    }

    public static Color getColorBasedOnIxd(int idx){
        if(idx > COLORS.size() || idx < 0){
            return Color.white;
        }
        return COLORS.get(idx);
    }

    public static Color getColorBasedOnIxd(String strIdx){
        int idx;
        try{
            idx = Integer.parseInt(strIdx);
        }catch (NumberFormatException ex){
            return getColorBasedOnIxd(-1);
        }
        return getColorBasedOnIxd(idx);
    }
}
