package cz.muni.fi.pv168.project.ui.action;

import cz.muni.fi.pv168.project.ui.resources.Icons;

import javax.swing.*;
import java.awt.datatransfer.*;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;

/**
 * Performing a copy of events or categories, triggered by user.
 */
public class CopyAction extends AbstractAction {

    private JTable eventTable;
    private Clipboard clipboard;
    private StringSelection clipString;
    private int columnsCount;
    private int rowCount;
    private int[] selectedRows;
    private int[] selectedColumns;

    public CopyAction(JTable eventTable, Clipboard clipboard) {
        super("Copy", Icons.COPY_ICON);
        putValue(SHORT_DESCRIPTION, "Copy");
        putValue(MNEMONIC_KEY, KeyEvent.VK_C);
        putValue(ACCELERATOR_KEY, KeyStroke.getKeyStroke("ctrl C"));

        this.eventTable = eventTable;
        this.clipboard = clipboard;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if (!checkCopySelection()) return;

        // set clipboard with copy selection of event table model
        StringBuilder copyStringBuilder = new StringBuilder();
        for (int i = 0; i < rowCount; i++) {
            for (int j = 0; j < columnsCount; j++) {
                copyStringBuilder.append(eventTable.getValueAt(selectedRows[i], selectedColumns[j]));
                if (j < columnsCount - 1) {
                    copyStringBuilder.append('\t');
                }
            }
            copyStringBuilder.append('\n');
        }
        clipString = new StringSelection(copyStringBuilder.toString());
        clipboard.setContents(clipString, clipString);
    }

    public boolean checkCopySelection() {
        columnsCount = eventTable.getSelectedColumnCount();
        rowCount = eventTable.getSelectedRowCount();
        selectedRows = eventTable.getSelectedRows();
        selectedColumns = eventTable.getSelectedColumns();

        // Check to ensure we have selected only a contiguous block of cells.
        if (!((rowCount - 1 == selectedRows[selectedRows.length - 1] - selectedRows[0] &&
                rowCount == selectedRows.length) &&
                (columnsCount - 1 == selectedColumns[selectedColumns.length - 1] - selectedColumns[0] &&
                        columnsCount == selectedColumns.length))) {
            JOptionPane.showMessageDialog(null, "Invalid Copy Selection",
                    "Invalid Copy Selection",
                    JOptionPane.ERROR_MESSAGE);
            return false;
        }

        return true;
    }
}