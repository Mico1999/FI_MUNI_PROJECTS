package cz.muni.fi.pv168.project.ui.action.filter;

import cz.muni.fi.pv168.project.model.FilterModel;
import cz.muni.fi.pv168.project.ui.MainWindow;
import cz.muni.fi.pv168.project.ui.dialog.FilterDialog;
import cz.muni.fi.pv168.project.ui.model.CategoryTableModel;
import cz.muni.fi.pv168.project.ui.model.EventTableModel;

import javax.swing.*;
import javax.swing.table.TableRowSorter;
import java.awt.event.ActionEvent;

/**
 * Performing filter of events when FilterDialog is submitted by user.
 */
public class FilterAction extends AbstractAction {
    private final JTable eventTable;
    private final JTable categoryTable;

    public FilterAction(JTable eventTable, JTable categoryTable) {
        this.eventTable = eventTable;
        this.categoryTable = categoryTable;
    }

    private void filterEvents(FilterModel filterModel) {
        // if all dialog fields are empty, do not filter events
        if (!filterModel.getDone() && !filterModel.getInProgress()
                && !filterModel.getPlanned() && filterModel.getFrom() == null
                && filterModel.getTo() == null && filterModel.getCategory() == null) {
            return;
        }

        TableRowSorter sorter = new TableRowSorter(eventTable.getModel());
        sorter.setRowFilter(new EventFilter(filterModel));
        eventTable.setRowSorter(sorter);
        MainWindow.getRemoveFilterButton().setEnabled(true);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        FilterDialog dialog = new FilterDialog((EventTableModel) eventTable.getModel(),
                (CategoryTableModel) categoryTable.getModel());

        dialog.show(categoryTable, "Filter events").ifPresent(this::filterEvents);
    }
}
