package cz.muni.fi.pv168.project.ui.model;

import cz.muni.fi.pv168.project.data.storage.DataStorageException;
import cz.muni.fi.pv168.project.data.storage.repository.Repository;
import cz.muni.fi.pv168.project.model.CategoryModel;
import cz.muni.fi.pv168.project.model.EventModel;

import javax.swing.JOptionPane;
import javax.swing.table.AbstractTableModel;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * Table model for category table including methods for working with category table,
 * adding, updating and removing category selected by user.
 */
public class CategoryTableModel extends AbstractTableModel {

    private final Repository<CategoryModel> categories;
    private final Repository<EventModel> events;

    private final List<Column<CategoryModel, ?>> columns = List.of(
            Column.editable("Name", String.class, CategoryModel::getName, CategoryModel::setName),
            Column.readonly("Default Duration", String.class, CategoryModel::getDefaultDurationText),
            Column.readonly("Color", String.class, CategoryModel::getDefaultColorText)
    );

    public CategoryTableModel(Repository<CategoryModel> categories, Repository<EventModel> events) {
        this.categories = categories;
        this.events = events;
    }

    public ArrayList<CategoryModel> getCategories(){ return new ArrayList<CategoryModel>(categories.findAll()); }

    @Override
    public int getRowCount() {
        return this.categories.getSize();
    }

    @Override
    public int getColumnCount() {
        return columns.size();
    }

    @Override
    public Object getValueAt(int rowIndex, int columnIndex) {

        var category = getCategory(rowIndex);
        return columns.get(columnIndex).getValue(category);
    }
    @Override
    public void setValueAt(Object value, int rowIndex, int columnIndex) {
        var category = getCategory(rowIndex);
        columns.get(columnIndex).setValue(value, category);
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

    public CategoryModel getCategory(int index){
        if (index < categories.getSize()){
            return categories.findByIndex(index).orElseThrow();
        }
        return new CategoryModel();
    }

    public CategoryModel getCategory(String name){
        for(CategoryModel category : categories.findAll()){
            if (category.getName().equals(name)){
                return category;
            }
        }
        return new CategoryModel();
    }

    public void addRow(CategoryModel category) {
        int newRowIndex = categories.getSize();
        try {
            categories.create(category);
            fireTableRowsInserted(newRowIndex, newRowIndex);
        } catch (DataStorageException ignored) {
            // to avoid fire table
        }
    }

    public void updateRow(CategoryModel category, int rowIndex) {
        try {
            categories.update(category);
            fireTableRowsUpdated(rowIndex, rowIndex);
        } catch (DataStorageException ignored){
            // to avoid fire table
        }
        categories.refresh();
        events.refresh();
    }

    public void deleteRow(int rowIndex) {
        try {
            categories.deleteByIndex(rowIndex);
            fireTableRowsDeleted(rowIndex, rowIndex);
        }
        catch (DataStorageException e){
            JOptionPane.showMessageDialog(null, "Cannot delete Category, events are dependent on it!");
        }
    }
}