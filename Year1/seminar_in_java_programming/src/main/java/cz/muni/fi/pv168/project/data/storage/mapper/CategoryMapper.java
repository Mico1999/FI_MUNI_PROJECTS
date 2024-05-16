package cz.muni.fi.pv168.project.data.storage.mapper;

import cz.muni.fi.pv168.project.data.storage.entity.CategoryEntity;
import cz.muni.fi.pv168.project.model.CategoryModel;

/**
 * Maps {@link CategoryEntity} to {@link CategoryModel} and vice versa.
 */
public class CategoryMapper implements EntityMapper<CategoryEntity, CategoryModel>{

    @Override
    public CategoryModel mapToModel(CategoryEntity entity) {

        return new CategoryModel(
                entity.name(),
                entity.defaultDuration(),
                entity.defaultColor(),
                entity.Id()
        );
    }

    @Override
    public CategoryEntity mapToEntity(CategoryModel source) {

        return new CategoryEntity(
                source.getId(),
                source.getName(),
                source.getDefaultDuration(),
                source.getDefaultColor()
        );
    }
}
