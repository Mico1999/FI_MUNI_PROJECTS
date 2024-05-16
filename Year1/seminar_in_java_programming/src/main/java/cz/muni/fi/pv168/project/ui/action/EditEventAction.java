package cz.muni.fi.pv168.project.ui.action;

import cz.muni.fi.pv168.project.ui.dialog.EventDialog;
import cz.muni.fi.pv168.project.ui.model.CategoryTableModel;
import cz.muni.fi.pv168.project.ui.model.EventTableModel;
import cz.muni.fi.pv168.project.ui.resources.Icons;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;

/**
 * Editing an event (changing attributes of an event selected) by user.
 */
public class EditEventAction extends AbstractAction{

    private final JTable eventTable;
    private final JTable categoryTable;

    public EditEventAction(JTable eventTable, JTable categoryTable) {
        super("Edit Event", Icons.EDIT_ICON);
        this.eventTable = eventTable;
        this.categoryTable = categoryTable;
        putValue(SHORT_DESCRIPTION, "Edits new event");
        putValue(MNEMONIC_KEY, KeyEvent.VK_E);
        putValue(ACCELERATOR_KEY, KeyStroke.getKeyStroke("ctrl E"));
    }

    @Override
    public void actionPerformed(ActionEvent actionEvent) {
        int[] selectedRows = eventTable.getSelectedRows();
        if (selectedRows.length != 1) {
            throw new IllegalStateException("Invalid selected rows count (must be 1): " + selectedRows.length);
        }
        if (eventTable.isEditing()) {
            eventTable.getCellEditor().cancelCellEditing();
        }

        var eventTableModel = (EventTableModel) eventTable.getModel();
        int modelRow = eventTable.convertRowIndexToModel(selectedRows[0]);
        var event = eventTableModel.getEvent(modelRow);
        var categoryTableModel = (CategoryTableModel) categoryTable.getModel();
        var dialog = new EventDialog(event, categoryTableModel.getCategories());
        dialog.show(eventTable, "Edit Event")
                .ifPresent(e -> eventTableModel.updateRow(e, modelRow));
    }
}
