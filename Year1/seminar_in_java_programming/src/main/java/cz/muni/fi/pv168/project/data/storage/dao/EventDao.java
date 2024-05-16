package cz.muni.fi.pv168.project.data.storage.dao;

import cz.muni.fi.pv168.project.data.storage.DataStorageException;
import cz.muni.fi.pv168.project.data.storage.db.ConnectionHandler;
import cz.muni.fi.pv168.project.data.storage.entity.EventEntity;
import cz.muni.fi.pv168.project.model.DurationModel;
import cz.muni.fi.pv168.project.model.DurationOption;
import cz.muni.fi.pv168.project.model.StatusOptions;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import java.util.function.Supplier;

import static java.sql.Types.BLOB;
import static java.sql.Types.NVARCHAR;

/**
 * Functionality for working with event table in the
 * database, executing SQL statements.
 */
public final class EventDao implements DataAccessObject<EventEntity> {

    private final Supplier<ConnectionHandler> connections;

    public EventDao(Supplier<ConnectionHandler> connections) {
        this.connections = connections;
    }

    @Override
    public EventEntity create(EventEntity entity) {
        var sql = """
                INSERT INTO Event(
                    date,
                    durationValue,
                    durationOption,
                    name,
                    description,
                    categoryId,
                    status
                )
                VALUES (?, ?, ?, ?, ?, ?, ?);
                """;

        try (
                var connection = connections.get();
                var statement = connection.use().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {
            statement.setDate(1, Date.valueOf(entity.date()));
            if (entity.duration().getValue() == null) {
                statement.setNull(2, BLOB);
            } else {
                statement.setInt(2, entity.duration().getValue());
            }
            if (entity.duration().getOption() == null) {
                statement.setNull(3, BLOB);
            } else {
                statement.setInt(3, entity.duration().getOption().ordinal());
            }

            statement.setString(4, entity.name());
            statement.setString(5, entity.description());
            if (entity.categoryId() == null){
                statement.setNull(6, BLOB);
            } else {
                statement.setLong(6, entity.categoryId());
            }

            statement.setInt(7, entity.status().ordinal());

            statement.executeUpdate();

            try (var keyResultSet = statement.getGeneratedKeys()) {
                long eventId;

                if (keyResultSet.next()) {
                    eventId = keyResultSet.getLong(1);
                } else {
                    throw new DataStorageException("Failed to fetch generated key for: " + entity);
                }
                if (keyResultSet.next()) {
                    throw new DataStorageException("Multiple keys returned for: " + entity);
                }

                return findById(eventId).orElseThrow();
            }
        } catch (SQLException ex) {
            throw new DataStorageException("Failed to store: " + entity, ex);
        }
    }

    @Override
    public Collection<EventEntity> findAll() {
        var sql = """
                SELECT id,
                    date,
                    durationValue,
                    durationOption,
                    name,
                    description,
                    categoryId,
                    status
                    FROM Event
                """;

        try (
                var connection = connections.get();
                var statement = connection.use().prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE,
                        ResultSet.CONCUR_UPDATABLE)) {

            List<EventEntity> events = new ArrayList<>();
            try (var resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    var event = eventFromResultSet(resultSet);
                    events.add(event);
                }
            }

            return events;
        } catch (SQLException ex) {
            throw new DataStorageException("Failed to load all events", ex);
        }
    }

    @Override
    public Optional<EventEntity> findById(long id) {
        var sql = """
                SELECT id,
                    date,
                    durationValue,
                    durationOption,
                    name,
                    description,
                    categoryId,
                    status
                    FROM Event
                    WHERE id = ?
                """;

        try (
                var connection = connections.get();
                var statement = connection.use().prepareStatement(sql,ResultSet.TYPE_SCROLL_INSENSITIVE,
                        ResultSet.CONCUR_UPDATABLE)
        ) {
            statement.setLong(1, id);
            var resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return Optional.of(eventFromResultSet(resultSet));
            } else {
                // event not found
                return Optional.empty();
            }
        } catch (SQLException ex) {
            throw new DataStorageException("Failed to load event by id", ex);
        }
    }

    @Override
    public EventEntity update(EventEntity entity) {
        Objects.requireNonNull(entity.Id(), "Entity id cannot be null");

        final var sql = """
                UPDATE Event
                SET
                    date = ?,
                    durationValue = ? ,
                    durationOption = ?,
                    name = ?,
                    description = ?,
                    categoryId = ?,
                    status = ?
                WHERE id = ?
                """;

        try (
                var connection = connections.get();
                var statement = connection.use().prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE,
                        ResultSet.CONCUR_UPDATABLE)
        ) {
            statement.setDate(1, Date.valueOf(entity.date()));
            if (entity.duration().getValue() == null) {
                statement.setNull(2, BLOB);
            } else {
                statement.setInt(2, entity.duration().getValue());
            }
            if (entity.duration().getOption() == null) {
                statement.setNull(3, BLOB);
            } else {
                statement.setInt(3, entity.duration().getOption().ordinal());
            }

            statement.setString(4, entity.name());
            statement.setString(5, entity.description());
            if (entity.categoryId() == null){
                statement.setNull(6, BLOB);
            } else {
                statement.setLong(6, entity.categoryId());
            }

            statement.setInt(7, entity.status().ordinal());

            statement.setLong(8, entity.Id());

            if (statement.executeUpdate() == 0) {
                throw new DataStorageException("Failed to update non-existing employee: " + entity);
            }
        } catch (SQLException ex) {
            throw new DataStorageException("Failed to update employee with id: " + entity.Id(), ex);
        }

        return findById(entity.Id()).orElseThrow();
    }

    @Override
    public void deleteById(long entityId) {
        var sql = "DELETE FROM Event WHERE id = ?";

        try (
                var connection = connections.get();
                var statement = connection.use().prepareStatement(sql,ResultSet.TYPE_SCROLL_INSENSITIVE,
                        ResultSet.CONCUR_UPDATABLE)
        ) {
            statement.setLong(1, entityId);
            int rowsUpdated = statement.executeUpdate();
            if (rowsUpdated == 0) {
                throw new DataStorageException("Event not found: %d".formatted(entityId));
            }
            if (rowsUpdated > 1) {
                throw new DataStorageException("More then 1 event (rows=%d) has been deleted: %d"
                        .formatted(rowsUpdated, entityId));
            }
        } catch (SQLException ex) {
            throw new DataStorageException("Failed to delete event: %d".formatted(entityId), ex);
        }
    }

    private static EventEntity eventFromResultSet(ResultSet resultSet) throws SQLException {
        Long categoryId = resultSet.getLong("categoryId");
        if (resultSet.wasNull()){
            resultSet.updateNull("categoryId");
            categoryId = null;
        }
        return new EventEntity(
                resultSet.getLong("id"),
                resultSet.getDate("date").toLocalDate(),
                new DurationModel(resultSet.getInt("durationValue"),
                        (DurationOption.values())[resultSet.getInt("durationOption")]),
                resultSet.getString("name"),
                resultSet.getString("description"),
                categoryId,
                (StatusOptions.values())[resultSet.getInt("status")]
        );
    }
}
