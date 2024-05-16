package cz.muni.fi.pv168.project.data.storage.entity;

import cz.muni.fi.pv168.project.model.CategoryModel;
import cz.muni.fi.pv168.project.model.DurationModel;
import cz.muni.fi.pv168.project.model.StatusOptions;

import java.time.LocalDate;

/**
 * Data class for event.
 */
public record EventEntity(
        Long Id,
        LocalDate date,
        DurationModel duration,
        String name,
        String description,
        Long categoryId,
        StatusOptions status
) {
//    public EventEntity(
//            LocalDate date,
//            DurationModel duration,
//            String name,
//            String description,
//            CategoryModel categoryModel,
//            StatusOptions status
//    ) {
//        this(date, duration, name, description, categoryModel, status);
//    }
}
