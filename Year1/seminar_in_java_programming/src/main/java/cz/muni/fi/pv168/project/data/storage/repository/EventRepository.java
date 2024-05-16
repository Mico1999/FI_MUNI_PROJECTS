package cz.muni.fi.pv168.project.data.storage.repository;

import cz.muni.fi.pv168.project.data.storage.dao.EventDao;
import cz.muni.fi.pv168.project.data.storage.entity.EventEntity;
import cz.muni.fi.pv168.project.data.storage.mapper.EntityMapper;
import cz.muni.fi.pv168.project.model.EventModel;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Represents a storage for events.
 */
public class EventRepository implements Repository<EventModel> {
    private final EventDao dao;
    private final EntityMapper<EventEntity, EventModel> mapper;

    private List<EventModel> events = new ArrayList<>();

    public EventRepository(
            EventDao dao,
            EntityMapper<EventEntity, EventModel> mapper
    ) {
        this.dao = dao;
        this.mapper = mapper;
        this.refresh();
    }

    @Override
    public int getSize() {
        return events.size();
    }

    @Override
    public Optional<EventModel> findById(long id) {
        return events.stream().filter(e -> e.getId() == id).findFirst();
    }

    @Override
    public Optional<EventModel> findByIndex(int index) {
        if (index < getSize())
            return Optional.of(events.get(index));
        return Optional.empty();
    }

    @Override
    public List<EventModel> findAll() {
        return Collections.unmodifiableList(events);
    }

    @Override
    public void refresh() {
        events = fetchAllEntities();
    }

    @Override
    public void create(EventModel newEntity) {
        Stream.of(newEntity)
                .map(mapper::mapToEntity)
                .map(dao::create)
                .map(mapper::mapToModel)
                .forEach(e -> events.add(e));
    }

    @Override
    public void update(EventModel entity) {
        int index = events.indexOf(entity);
        Stream.of(entity)
                .map(mapper::mapToEntity)
                .map(dao::update)
                .map(mapper::mapToModel)
                .forEach(e -> events.set(index, e));
    }

    @Override
    public void deleteByIndex(int index) {
        this.deleteEntityByIndex(index);
        events.remove(index);
    }

    private List<EventModel> fetchAllEntities() {
        return dao.findAll().stream()
                .map(mapper::mapToModel)
                .collect(Collectors.toCollection(ArrayList::new));
    }

    private void deleteEntityByIndex(int index) {
        dao.deleteById(events.get(index).getId());
    }
}
