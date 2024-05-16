package cz.muni.fi.pv168.project.ui.action;

import cz.muni.fi.pv168.project.model.DurationOption;
import cz.muni.fi.pv168.project.model.EventModel;
import cz.muni.fi.pv168.project.ui.model.EventTableModel;
import cz.muni.fi.pv168.project.ui.resources.Icons;

import javax.swing.*;
import java.awt.datatransfer.*;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.io.IOException;
import java.time.LocalDate;
import java.util.StringTokenizer;

/**
 * Performing a paste of the last copied events or categories,
 * triggered by user.
 */
public class PasteAction extends AbstractAction {

    private JTable eventTable;
    private EventTableModel eventTableModel;
    private Clipboard clipboard;
    private int startCol;
    private int startRow;

    public PasteAction(JTable eventTable, Clipboard clipboard) {
        super("Paste", Icons.PASTE_ICON);
        putValue(SHORT_DESCRIPTION, "Paste");
        putValue(MNEMONIC_KEY, KeyEvent.VK_V);
        putValue(ACCELERATOR_KEY, KeyStroke.getKeyStroke("ctrl V"));

        this.clipboard = clipboard;
        this.eventTable = eventTable;
        this.eventTableModel = (EventTableModel) this.eventTable.getModel();
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        startRow = (eventTable.getSelectedRows())[0];
        startCol = (eventTable.getSelectedColumns())[0];

        try {
            final String clipboardContent = (String) (clipboard.getContents(this)
                    .getTransferData(DataFlavor.stringFlavor));
            final StringTokenizer newLineTokenizer = new StringTokenizer(clipboardContent, "\n");

            for (int i = 0; newLineTokenizer.hasMoreTokens(); i++) {
                String rowString = newLineTokenizer.nextToken();
                StringTokenizer tabTokenizer = new StringTokenizer(rowString, "\t");
                for (int j = 0; tabTokenizer.hasMoreTokens(); j++) {
                    String value = (String) tabTokenizer.nextToken();
                    if (startRow + i < eventTable.getRowCount() &&
                            startCol + j < eventTable.getColumnCount()) {
                        pasteToTableModel(value, startRow + i, startCol + j);
                    }
                }
            }
        } catch (IOException | UnsupportedFlavorException ex) {
            throw new RuntimeException(ex);
        }
    }

    public void pasteToTableModel(String value, int row, int col) {
        EventModel event = eventTableModel.getEvent(row);
        int modelRow = eventTable.convertRowIndexToModel(row);

        switch (col) {
            case 0:
                event.setName(value);
                break;
            case 1:
                event.setDate(LocalDate.parse(value));
                break;
            case 2:
                event.setDurationOption(DurationOption.values()[Integer.valueOf(value)]);
                break;
            case 3:
                event.setDescription(value);
                break;
            default:
                break;
        }

        if (eventTable.isEditing()) {
            eventTable.getCellEditor().cancelCellEditing();
        }

        eventTableModel.updateRow(event, modelRow);
    }
}