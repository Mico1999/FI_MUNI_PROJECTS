package cz.muni.fi.pv168.project.ui.model;

import cz.muni.fi.pv168.project.data.storage.repository.Repository;
import cz.muni.fi.pv168.project.model.CategoryModel;
import cz.muni.fi.pv168.project.model.EventModel;
import cz.muni.fi.pv168.project.model.StatusOptions;

import javax.swing.table.AbstractTableModel;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Table model for table of events including methods for working with table,
 * adding, updating and removing event selected by user.
 */
public class EventTableModel extends AbstractTableModel {

    private final Repository<EventModel> events;

    private final List<Column<EventModel, ?>> columns = List.of(
            Column.editable("Name", String.class, EventModel::getName, EventModel::setName),
            Column.readonly("Date", LocalDate.class, EventModel::getDate),
            Column.readonly("Duration", String.class, EventModel::getDurationText),
            Column.editable("Description", String.class, EventModel::getDescription, EventModel::setDescription),
            Column.readonly("Category", CategoryModel.class, EventModel::getCategoryModel),
            Column.readonly("Status", String.class, EventModel::getStatusText)
    );
    public EventTableModel(Repository<EventModel> events) {
        this.events = events;
    }

    @Override
    public int getRowCount() {
        return this.events.getSize();
    }

    @Override
    public int getColumnCount() {
        return columns.size();
    }

    @Override
    public Object getValueAt(int rowIndex, int columnIndex) {

        var event = getEvent(rowIndex);
        return columns.get(columnIndex).getValue(event);
    }

    @Override
    public void setValueAt(Object value, int rowIndex, int columnIndex) {
        var event = getEvent(rowIndex);
        columns.get(columnIndex).setValue(value, event);
    }

    @Override
    public String getColumnName(int columnIndex) {
        return columns.get(columnIndex).getName();
    }

    @Override
    public Class<?> getColumnClass(int columnIndex) {

        return columns.get(columnIndex).getColumnType();
    }

    @Override
    public boolean isCellEditable(int rowIndex, int columnIndex) {

        return columns.get(columnIndex).isEditable();
    }

    public EventModel getEvent(int index){
        if (index < events.getSize()){
            return events.findByIndex(index).orElseThrow();
        }
        return new EventModel();
    }

    public void addRow(EventModel event) {
        int newRowIndex = events.getSize();
        events.create(event);
        fireTableRowsInserted(newRowIndex, newRowIndex);
    }

    public void updateRow(EventModel event, int rowIndex) {
        events.update(event);
        fireTableRowsUpdated(rowIndex, rowIndex);
    }

    public void deleteRow(int rowIndex) {
        events.deleteByIndex(rowIndex);
        fireTableRowsDeleted(rowIndex, rowIndex);

    }

    public List<EventModel> getEvents() { return events.findAll(); }

}
