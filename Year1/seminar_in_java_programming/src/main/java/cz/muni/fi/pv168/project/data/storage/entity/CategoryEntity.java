package cz.muni.fi.pv168.project.data.storage.entity;

import cz.muni.fi.pv168.project.model.DurationModel;

import java.awt.Color;

/**
 * Data class for category.
 */
public record CategoryEntity(
        Long Id,
        String name,
        DurationModel defaultDuration,
        Color defaultColor) {

}
