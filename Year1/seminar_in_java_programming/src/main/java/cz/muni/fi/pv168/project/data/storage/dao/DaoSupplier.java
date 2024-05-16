package cz.muni.fi.pv168.project.data.storage.dao;

import cz.muni.fi.pv168.project.data.storage.db.ConnectionHandler;

import java.util.function.Supplier;

@FunctionalInterface
public interface DaoSupplier<D> {
    DataAccessObject<D> get(Supplier<ConnectionHandler> connections);
}

