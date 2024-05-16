package cz.muni.fi.pv168.project.wiring;


import cz.muni.fi.pv168.project.data.manipulation.*;
import cz.muni.fi.pv168.project.data.storage.dao.CategoryDao;
import cz.muni.fi.pv168.project.data.storage.dao.EventDao;
import cz.muni.fi.pv168.project.data.storage.db.DatabaseManager;
import cz.muni.fi.pv168.project.data.storage.mapper.CategoryMapper;
import cz.muni.fi.pv168.project.data.storage.mapper.EventMapper;
import cz.muni.fi.pv168.project.data.storage.repository.CategoryRepository;
import cz.muni.fi.pv168.project.data.storage.repository.EventRepository;
import cz.muni.fi.pv168.project.data.storage.repository.Repository;
import cz.muni.fi.pv168.project.model.CategoryModel;
import cz.muni.fi.pv168.project.model.EventModel;

import java.util.List;

/**
 * Dependency provider common for all environments
 */
public abstract class CommonDependencyProvider implements DependencyProvider {

    private final DatabaseManager databaseManager;
    private final Repository<CategoryModel> categories;
    private final Repository<EventModel> events;
    private Importer importer;
    private Exporter exporter;


    protected CommonDependencyProvider(DatabaseManager databaseManager) {
        this.databaseManager = databaseManager;
        this.categories = new CategoryRepository(
                new CategoryDao(databaseManager::getConnectionHandler),
                new CategoryMapper()
        );

        this.events = new EventRepository(
                new EventDao(databaseManager::getConnectionHandler),
                new EventMapper(categories)
        );
    }

    @Override
    public DatabaseManager getDatabaseManager() {
        return databaseManager;
    }

    @Override
    public Repository<CategoryModel> getCategoryRepository() { return categories; }

    @Override
    public Repository<EventModel> getEventRepository() {
        return events;
    }

//
//    @Override
//    public Importer getImporter(){
//        if (importer == null) {
//            var database = getDatabaseManager();
//            importer = new CsvImporter(
//                    database::getConnectionHandler,
//                    EventDao::new,
//                    CategoryDao::new
//            );
//        }
//        return importer;
//    }

    @Override
    public Importer getImporter() {
        if (importer == null) {
            var database = getDatabaseManager();

            importer = new DaoImporter(
                    EventDao::new,
                    CategoryDao::new,
                    database::getConnectionHandler
            );
        }
        return importer;
    }

    @Override
    public Exporter getExporter(){
        if (exporter == null) {
            exporter = new CsvExporter();
        }
        return exporter;
    }
}
