package cz.muni.fi.pv168.project.ui.action.filter;

import cz.muni.fi.pv168.project.model.FilterModel;
import cz.muni.fi.pv168.project.model.StatusOptions;

import javax.swing.*;
import java.time.LocalDate;

/**
 * Methods for event filtering functionality, filter is given as FilterModel object.
 */
public class EventFilter extends RowFilter {

    private final FilterModel filterModel;

    public EventFilter(FilterModel filterModel) {
        this.filterModel = filterModel;
    }

    private boolean isWithinDates(LocalDate eventDate, LocalDate date1, LocalDate date2) {
        return !(eventDate.isBefore(date1) || eventDate.isAfter(date2));
    }

    private boolean checkStatus(String status) {
        if (!this.filterModel.getPlanned() && !this.filterModel.getInProgress() && !this.filterModel.getDone()) {
            return true;
        }

        boolean result = false;

        if (this.filterModel.getPlanned()) {
            result = status.equals(StatusOptions.PLANNED.getText());
        }
        if (this.filterModel.getInProgress()) {
            result = result || status.equals(StatusOptions.DOING.getText());
        }
        if (this.filterModel.getDone()) {
            result = result || status.equals(StatusOptions.DONE.getText());
        }

        return result;
    }

    @Override
    public boolean include(Entry entry) {
        return (filterModel.getFrom() == null || filterModel.getTo() == null ||
                this.isWithinDates((LocalDate) entry.getValue(1), filterModel.getFrom(), filterModel.getTo()))
                && this.checkStatus(entry.getValue(5).toString())
                && (filterModel.getCategory() == null || (entry.getValue(4) != null && entry.getValue(4).toString().equals(filterModel.getCategory())));
    }
}
