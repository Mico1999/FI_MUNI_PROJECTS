package cz.muni.fi.pv168.project.ui.workers;

import cz.muni.fi.pv168.project.data.manipulation.Importer;

import javax.swing.JTable;
import javax.swing.SwingWorker;

/**
 * Asynchronous functionality for importing events and categories from CSV file.
 */
public class AsyncImporter implements Importer {

    private final Importer importer;
    private final Runnable onFinish;

    public AsyncImporter(Importer importer, Runnable onFinish) {
        this.importer = importer;
        this.onFinish = onFinish;
    }

    @Override
    public void importData(String filePath, JTable categoryTable, JTable eventTable) {
        var asyncWorker = new SwingWorker<Void, Void>() {
            @Override
            protected Void doInBackground() throws Exception {
                importer.importData(filePath, categoryTable, eventTable);
                return null;
            }

            @Override
            protected void done() {
                super.done();
                onFinish.run();
            }
        };
        asyncWorker.execute();
    }
}
