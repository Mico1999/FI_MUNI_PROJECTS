package cz.muni.fi.pv168.project.ui.action;

import cz.muni.fi.pv168.project.ui.model.EventTableModel;
import cz.muni.fi.pv168.project.ui.resources.Icons;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.util.Arrays;
import java.util.Comparator;

/**
 * Deleting of event from event table, triggered by user.
 */
public class DeleteEventAction extends AbstractAction{
    private final JTable eventTable;

    public DeleteEventAction(JTable eventTable) {
        super("Delete Event", Icons.DELETE_ICON);
        this.eventTable = eventTable;
        putValue(SHORT_DESCRIPTION, "Deletes selected events");
        putValue(MNEMONIC_KEY, KeyEvent.VK_D);
        putValue(ACCELERATOR_KEY, KeyStroke.getKeyStroke("ctrl D"));
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        var eventTableModel = (EventTableModel) eventTable.getModel();
        Arrays.stream(eventTable.getSelectedRows())
                // view row index must be converted to model row index
                .map(eventTable::convertRowIndexToModel)
                .boxed()
                // We need to delete rows in descending order to not change index of rows
                // which are not deleted yet
                .sorted(Comparator.reverseOrder())
                .forEach(eventTableModel::deleteRow);
    }
}
