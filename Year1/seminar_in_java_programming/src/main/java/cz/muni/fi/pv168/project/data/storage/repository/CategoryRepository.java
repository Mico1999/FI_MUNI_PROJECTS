package cz.muni.fi.pv168.project.data.storage.repository;

import cz.muni.fi.pv168.project.data.storage.DataStorageException;
import cz.muni.fi.pv168.project.data.storage.dao.CategoryDao;
import cz.muni.fi.pv168.project.data.storage.entity.CategoryEntity;
import cz.muni.fi.pv168.project.data.storage.mapper.CategoryMapper;
import cz.muni.fi.pv168.project.data.storage.mapper.EntityMapper;
import cz.muni.fi.pv168.project.model.CategoryModel;

import javax.swing.JOptionPane;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Represents a storage for categories.
 */
public class CategoryRepository implements Repository<CategoryModel> {
    private final CategoryDao dao;
    private final EntityMapper<CategoryEntity, CategoryModel> mapper;

    private List<CategoryModel> categories = new ArrayList<>();

    public CategoryRepository(
            CategoryDao dao,
            EntityMapper<CategoryEntity, CategoryModel> mapper
    ) {
        this.dao = dao;
        this.mapper = mapper;
        this.refresh();
    }

    @Override
    public int getSize() {
        return categories.size();
    }

    @Override
    public Optional<CategoryModel> findById(long id) {
        return categories.stream().filter(e -> e.getId() == id).findFirst();
    }

    @Override
    public Optional<CategoryModel> findByIndex(int index) {
        if (index < getSize())
            return Optional.of(categories.get(index));
        return Optional.empty();
    }

    @Override
    public List<CategoryModel> findAll() {
        return Collections.unmodifiableList(categories);
    }

    @Override
    public void refresh() {
        categories = fetchAllEntities();
    }

    @Override
    public void create(CategoryModel newEntity) {
        CategoryMapper categoryMapper = new CategoryMapper();
        for (CategoryModel _category : dao.findAll().stream().map(categoryMapper::mapToModel).toList()){
            if(_category.getName().equals(newEntity.getName())){
                JOptionPane.showMessageDialog(null, "Cannot create Category with already existing name!");
                throw new DataStorageException("Cannot create");
            }
        }
        Stream.of(newEntity)
                .map(mapper::mapToEntity)
                .map(dao::create)
                .map(mapper::mapToModel)
                .forEach(e -> categories.add(e));
    }

    @Override
    public void update(CategoryModel entity) {
        CategoryMapper categoryMapper = new CategoryMapper();
        for (CategoryModel _category : dao.findAll().stream().map(categoryMapper::mapToModel).toList()){
            if(_category.equals(entity) &&
                    !Objects.equals(categoryMapper.mapToEntity(entity).Id(),
                            categoryMapper.mapToEntity(_category).Id())){
                JOptionPane.showMessageDialog(null,
                        "Cannot update Category with already existing name!");
                throw new DataStorageException("Cannot update");
            }
        }
        int index = categories.indexOf(entity);
        Stream.of(entity)
                .map(mapper::mapToEntity)
                .map(dao::update)
                .map(mapper::mapToModel)
                .forEach(e -> categories.set(index, e));
    }

    @Override
    public void deleteByIndex(int index) {
        this.deleteEntityByIndex(index);
        categories.remove(index);
    }

    private List<CategoryModel> fetchAllEntities() {
        return dao.findAll().stream()
                .map(mapper::mapToModel)
                .collect(Collectors.toCollection(ArrayList::new));
    }

    private void deleteEntityByIndex(int index) {
        dao.deleteById(categories.get(index).getId());
    }
}