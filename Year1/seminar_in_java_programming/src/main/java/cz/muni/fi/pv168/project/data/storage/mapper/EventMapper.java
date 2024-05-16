package cz.muni.fi.pv168.project.data.storage.mapper;

import cz.muni.fi.pv168.project.data.storage.entity.CategoryEntity;
import cz.muni.fi.pv168.project.data.storage.entity.EventEntity;
import cz.muni.fi.pv168.project.data.storage.repository.Repository;
import cz.muni.fi.pv168.project.model.CategoryModel;
import cz.muni.fi.pv168.project.model.EventModel;

import java.util.Optional;

/**
 * Maps {@link EventEntity} to {@link EventModel} and vice versa.
 */
public class EventMapper implements EntityMapper<EventEntity, EventModel> {

    @FunctionalInterface
    public interface Lookup<T> {
        Optional<T> get(Long id);
    }

    private final Lookup<CategoryModel> categorySupplier;

    public EventMapper(Repository<CategoryModel> categories) {
        this(categories::findById);
    }

    public EventMapper(Lookup<CategoryModel> categorySupplier) {
        this.categorySupplier = categorySupplier;
    }

    @Override
    public EventModel mapToModel(EventEntity entity) {
        CategoryModel category = null;
        if (entity.categoryId() != null){
            category = categorySupplier.get(entity.categoryId()).orElseThrow();
        }

        return new EventModel(
                entity.date(),
                entity.duration(),
                entity.name(),
                entity.description(),
                entity.status(),
                category,
                entity.Id()
        );
    }

    @Override
    public EventEntity mapToEntity(EventModel source) {
        Long categoryModelId = null;
        if (source.getCategoryModel() != null){
            categoryModelId = source.getCategoryModel().getId();
        }
        return new EventEntity(
                source.getId(),
                source.getDate(),
                source.getDuration(),
                source.getName(),
                source.getDescription(),
                categoryModelId,
                source.getStatus()
        );
    }
}
