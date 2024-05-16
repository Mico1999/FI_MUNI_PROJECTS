package cz.muni.fi.pv168.project.ui.action;

import cz.muni.fi.pv168.project.data.manipulation.Exporter;
import cz.muni.fi.pv168.project.ui.model.CategoryTableModel;
import cz.muni.fi.pv168.project.ui.model.EventTableModel;
import cz.muni.fi.pv168.project.ui.resources.Icons;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.io.File;
import java.util.Objects;

/**
 * Performing an export of events and categories into csv file by user.
 */
public class ExportAction extends AbstractAction {

    private final JTable eventTable;
    private final JTable categoryTable;
    private final Exporter exporter;
    public ExportAction(JTable eventTable, JTable categoryTable, Exporter exporter){
        super("Export", Icons.EXPORT_ICON);
        putValue(SHORT_DESCRIPTION, "Export To Csv");
        putValue(MNEMONIC_KEY, KeyEvent.VK_X);
        putValue(ACCELERATOR_KEY, KeyStroke.getKeyStroke("ctrl X"));
        this.eventTable = eventTable;
        this.categoryTable = categoryTable;
        this.exporter = Objects.requireNonNull(exporter);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        JFileChooser fileChooser = new JFileChooser();
        fileChooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
        fileChooser.setApproveButtonText("Select");
        int returnVal = fileChooser.showOpenDialog(null);
        if (returnVal == JFileChooser.APPROVE_OPTION)
        {
            File exportDir = fileChooser.getSelectedFile();
            var eventTableModel = (EventTableModel) eventTable.getModel();
            var categoryTableModel = (CategoryTableModel) categoryTable.getModel();
            exporter.exportData(eventTableModel.getEvents(), categoryTableModel.getCategories(), exportDir.getAbsolutePath());
        }
    }
}
