package cz.muni.fi.pv168.project.data.manipulation;

import javax.swing.JTable;

/**
 * Importer interface with functions implemented by CsvImporter class.
 */
public interface Importer {
    void importData(String filePath, JTable categoryTable, JTable eventTable);
}
