package cz.muni.fi.pv168.project.data.manipulation;

import cz.muni.fi.pv168.project.model.CategoryModel;
import cz.muni.fi.pv168.project.model.EventModel;

import java.util.Collection;

/**
 * Exporter interface with functions implemented by CsvExporter class.
 */
public interface Exporter {

    void exportData(Collection<EventModel> events, Collection<CategoryModel> categories, String filePath);
}
