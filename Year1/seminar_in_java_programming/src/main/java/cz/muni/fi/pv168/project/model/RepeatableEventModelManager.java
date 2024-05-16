package cz.muni.fi.pv168.project.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Functionality for adding, deleting and working with repeatable events.
 */
public class RepeatableEventModelManager {
    private List<RepeatableEventModel> repeatableEventModelList = new ArrayList<>();

    public void add(RepeatableEventModel repeatableEventModel){
        repeatableEventModelList.add(repeatableEventModel);
    }

    public void delete(RepeatableEventModel repeatableEventModel){
        repeatableEventModelList.remove(repeatableEventModel);
    }

    public RepeatableEventModel getRepeatableEventModel(EventModel eventModel){
        for (RepeatableEventModel repeatableEventModel: repeatableEventModelList) {
            if (repeatableEventModel.getEventModelList().contains(eventModel)){
                return repeatableEventModel;
            }
        }
        return null;
    }
}
