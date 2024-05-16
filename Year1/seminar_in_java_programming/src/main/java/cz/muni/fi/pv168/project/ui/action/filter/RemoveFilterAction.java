package cz.muni.fi.pv168.project.ui.action.filter;

import cz.muni.fi.pv168.project.ui.MainWindow;
import cz.muni.fi.pv168.project.ui.dialog.FilterDialog;

import javax.swing.*;
import javax.swing.table.TableRowSorter;
import java.awt.event.ActionEvent;

/**
 * Performing removal of active filter, triggered by user.
 */
public class RemoveFilterAction extends AbstractAction {
    private final JTable eventTable;
    private final JTable categoryTable;

    public RemoveFilterAction(JTable eventTable, JTable categoryTable) {
        this.eventTable = eventTable;
        this.categoryTable = categoryTable;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        TableRowSorter sorter = new TableRowSorter(eventTable.getModel());
        sorter.setRowFilter(new RemoveEventFilter());
        eventTable.setRowSorter(sorter);

        FilterDialog.resetFields();
        MainWindow.getRemoveFilterButton().setEnabled(false);
    }
}
