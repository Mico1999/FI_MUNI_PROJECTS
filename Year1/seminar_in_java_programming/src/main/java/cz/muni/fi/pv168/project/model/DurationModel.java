package cz.muni.fi.pv168.project.model;

import java.util.Objects;

/**
 * Model for duration of events and categories in database.
 */
public class DurationModel {
    private Integer value;
    private DurationOption option;

    public DurationModel(Integer value ,DurationOption option){
        setValue(value);
        setOption(option);
    }

    public DurationModel(){
        setOption(DurationOption.NONE);
    }

    public static DurationModel parse(String str){
        if (isStringDuration(str)){
            var value = str.split(" ")[0];
            var option = str.split(" ")[1];
            return new DurationModel(Integer.parseInt(value), DurationOption.valueOf(option));
        }
        return null;
    }

    public Integer getValue(){ return this.value; }

    void setValue(Integer value){
        this.value = value;
    }

    public DurationOption getOption(){ return this.option; }

    void setOption(DurationOption option){
        this.option = Objects.requireNonNull(option, "Duration option must not be null");
    }

    private static boolean isStringDuration(String str){
        if(str == null || (!str.contains(" "))){
            return false;
        }
        try{
            Integer.valueOf(str.split(" ")[0]);
            DurationOption.valueOf(str.split(" ")[1]);
        }catch (IllegalArgumentException e){
            return false;
        }
        return true;
    }

    public String getDurationText(){
        if (this.value == null || this.option == DurationOption.NONE){
            return "";
        } else if (this.option == DurationOption.DAYS){
            return this.value * 24 + " h";
        } else if (this.option == DurationOption.HOURS){
            return this.value + " h";
        } else {
            if (this.value >= 60){
                if (this.value % 60 == 0){
                    return this.value / 60 + " h";
                } else {
                    return this.value / 60 + " h " + this.value % 60 +" min";
                }
            }
            return this.value + " min";
        }
    }
}
