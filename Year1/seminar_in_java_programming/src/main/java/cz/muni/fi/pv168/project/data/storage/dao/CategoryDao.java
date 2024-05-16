package cz.muni.fi.pv168.project.data.storage.dao;

import cz.muni.fi.pv168.project.data.storage.DataStorageException;
import cz.muni.fi.pv168.project.data.storage.db.ConnectionHandler;
import cz.muni.fi.pv168.project.data.storage.entity.CategoryEntity;
import cz.muni.fi.pv168.project.model.DurationModel;
import cz.muni.fi.pv168.project.model.DurationOption;

import java.awt.Color;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Supplier;

import static java.sql.Types.BLOB;

/**
 * Functionality for working with category table in the
 * database, executing SQL statements.
 */
public final class CategoryDao implements DataAccessObject<CategoryEntity>{
    private final Supplier<ConnectionHandler> connections;

    public CategoryDao(Supplier<ConnectionHandler> connections) {
        this.connections = connections;
    }

    @Override
    public CategoryEntity create(CategoryEntity entity) {
        var sql = """
                INSERT INTO Category(
                    name,
                    defaultDurationValue,
                    defaultDurationOption,
                    defaultColor
                )
                VALUES (?, ?, ?, ?);
                """;

        try (
                var connection = connections.get();
                var statement = connection.use().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {
            statement.setString(1, entity.name());
            if (entity.defaultDuration().getValue() == null) {
                statement.setNull(2, BLOB);
            } else {
                statement.setInt(2, entity.defaultDuration().getValue());
            }
            if (entity.defaultDuration().getOption() == null) {
                statement.setNull(3, BLOB);
            } else {
                statement.setInt(3, entity.defaultDuration().getOption().ordinal());
            }
            statement.setString(4, String.valueOf(entity.defaultColor().getRGB()));

            statement.executeUpdate();

            try (var keyResultSet = statement.getGeneratedKeys()) {
                long categoryId;

                if (keyResultSet.next()) {
                    categoryId = keyResultSet.getLong(1);
                } else {
                    throw new DataStorageException("Failed to fetch generated key for: " + entity);
                }
                if (keyResultSet.next()) {
                    throw new DataStorageException("Multiple keys returned for: " + entity);
                }

                return findById(categoryId).orElseThrow();
            }
        } catch (SQLException ex) {
            throw new DataStorageException("Failed to store: " + entity, ex);
        }
    }

    @Override
    public Collection<CategoryEntity> findAll() {
        var sql = """
                SELECT id,
                    name,
                    defaultDurationValue,
                    defaultDurationOption,
                    defaultColor
                    FROM Category
                """;

        try (
                var connection = connections.get();
                var statement = connection.use().prepareStatement(sql)) {

            List<CategoryEntity> categories = new ArrayList<>();
            try (var resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    var category = categoryFromResultSet(resultSet);
                    categories.add(category);
                }
            }

            return categories;
        } catch (SQLException ex) {
            throw new DataStorageException("Failed to load all categories", ex);
        }
    }

    @Override
    public Optional<CategoryEntity> findById(long id) {
        var sql = """
                SELECT id,
                    name,
                    defaultDurationValue,
                    defaultDurationOption,
                    defaultColor
                    FROM Category
                    WHERE id = ?
                """;

        try (
                var connection = connections.get();
                var statement = connection.use().prepareStatement(sql)
        ) {
            statement.setLong(1, id);
            var resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return Optional.of(categoryFromResultSet(resultSet));
            } else {
                // category not found
                return Optional.empty();
            }
        } catch (SQLException ex) {
            throw new DataStorageException("Failed to load category by id", ex);
        }
    }

    @Override
    public CategoryEntity update(CategoryEntity entity) {
        var sql = """
                UPDATE Category
                SET
                    name = ?,
                    defaultDurationValue = ?,
                    defaultDurationOption = ?,
                    defaultColor = ?
               WHERE id = ?
                """;

        try (
                var connection = connections.get();
                var statement = connection.use().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {
            statement.setString(1, entity.name());
            if (entity.defaultDuration().getValue() == null) {
                statement.setNull(2, BLOB);
            } else {
                statement.setInt(2, entity.defaultDuration().getValue());
            }
            if (entity.defaultDuration().getOption() == null) {
                statement.setNull(3, BLOB);
            } else {
                statement.setInt(3, entity.defaultDuration().getOption().ordinal());
            }
            statement.setString(4, String.valueOf(entity.defaultColor().getRGB()));

            statement.setLong(5, entity.Id());

            if (statement.executeUpdate() == 0) {
                throw new DataStorageException("Failed to update non-existing category: " + entity);
            }
        } catch (SQLException ex) {
            throw new DataStorageException("Failed to update category with id: " + entity.Id(), ex);
        }

        return findById(entity.Id()).orElseThrow();
    }

    @Override
    public void deleteById(long entityId) {
        var sql = "DELETE FROM Category WHERE id = ?";

        try (
                var connection = connections.get();
                var statement = connection.use().prepareStatement(sql)
        ) {
            statement.setLong(1, entityId);
            int rowsUpdated = statement.executeUpdate();
            if (rowsUpdated == 0) {
                throw new DataStorageException("Category not found: %d".formatted(entityId));
            }
            if (rowsUpdated > 1) {
                throw new DataStorageException("More then 1 category (rows=%d) has been deleted: %d"
                        .formatted(rowsUpdated, entityId));
            }
        } catch (SQLException ex) {
            throw new DataStorageException("Failed to delete category: %d".formatted(entityId), ex);
        }
    }

    private static CategoryEntity categoryFromResultSet(ResultSet resultSet) throws SQLException {
        return new CategoryEntity(
                resultSet.getLong("Id"),
                resultSet.getString("name"),
                new DurationModel(resultSet.getInt("defaultDurationValue"),
                        (DurationOption.values())[resultSet.getInt("defaultDurationOption")]),
                Color.decode(resultSet.getString("defaultColor"))
        );
    }
}
