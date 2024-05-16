package cz.muni.fi.pv168.project.ui.action;

import cz.muni.fi.pv168.project.data.manipulation.Importer;
import cz.muni.fi.pv168.project.ui.resources.Icons;
import cz.muni.fi.pv168.project.ui.workers.AsyncImporter;

import javax.swing.AbstractAction;
import javax.swing.JFileChooser;
import javax.swing.JOptionPane;
import javax.swing.JTable;
import javax.swing.KeyStroke;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.io.File;
import java.util.Objects;

/**
 * Performing an import of events and categories from csv file by user.
 */
public class ImportAction extends AbstractAction {

    private final JTable eventTable;
    private final JTable categoryTable;
    private final Importer importer;
    public ImportAction(JTable eventTable, JTable categoryTable, Importer importer, Runnable callback) {
        super("Import", Icons.IMPORT_ICON);
        putValue(SHORT_DESCRIPTION,"Import From Cvs");
        putValue(MNEMONIC_KEY, KeyEvent.VK_I);
        putValue(ACCELERATOR_KEY, KeyStroke.getKeyStroke("ctrl I"));
        this.eventTable = eventTable;
        this.categoryTable = categoryTable;
        this.importer = new AsyncImporter(
                Objects.requireNonNull(importer),
                ()-> {
                    callback.run();
                    JOptionPane.showMessageDialog(eventTable, "Import was done");
                });
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        JFileChooser fileChooser = new JFileChooser();
        int retVal = fileChooser.showOpenDialog(null);
        if (retVal == JFileChooser.APPROVE_OPTION){
            File selectedFile = fileChooser.getSelectedFile();

            importer.importData(selectedFile.getAbsolutePath(), categoryTable, eventTable);
        }
    }
}
