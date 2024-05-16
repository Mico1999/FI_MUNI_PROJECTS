package cz.muni.fi.pv168.project.wiring;

import cz.muni.fi.pv168.project.data.manipulation.Exporter;
import cz.muni.fi.pv168.project.data.manipulation.Importer;
import cz.muni.fi.pv168.project.data.storage.db.DatabaseManager;
import cz.muni.fi.pv168.project.data.storage.repository.Repository;
import cz.muni.fi.pv168.project.model.CategoryModel;
import cz.muni.fi.pv168.project.model.EventModel;

/**
 * Interface for dependency provider.
 */
public interface DependencyProvider {

    DatabaseManager getDatabaseManager();

    Repository<CategoryModel> getCategoryRepository();

    Repository<EventModel> getEventRepository();

    Importer getImporter();

    Exporter getExporter();

}
