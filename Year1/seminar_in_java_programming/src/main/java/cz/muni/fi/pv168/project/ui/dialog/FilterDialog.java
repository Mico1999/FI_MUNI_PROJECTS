package cz.muni.fi.pv168.project.ui.dialog;

import cz.muni.fi.pv168.project.model.CategoryModel;
import cz.muni.fi.pv168.project.model.FilterModel;
import cz.muni.fi.pv168.project.ui.model.CategoryTableModel;
import cz.muni.fi.pv168.project.ui.model.EventTableModel;
import cz.muni.fi.pv168.project.ui.model.LocalDateModel;
import org.jdatepicker.DateModel;
import org.jdatepicker.JDatePicker;

import javax.swing.*;
import java.lang.reflect.Array;
import java.time.LocalDate;

/**
 * Dialog containing fields, where user can set filtering of events by progress, date and category.
 */
public class FilterDialog extends AbstractDialog<FilterModel> {
    private final EventTableModel eventTableModel;
    private final CategoryTableModel categoryTableModel;
    private static final JCheckBox doneField = new JCheckBox();
    private static final JCheckBox plannedField = new JCheckBox();
    private static final JCheckBox inProgressField = new JCheckBox();
    private static final DateModel<LocalDate> dateFieldFrom = new LocalDateModel();
    private static final DateModel<LocalDate> dateFieldTo = new LocalDateModel();
    private static JComboBox<String> categoryField;
    private static final FilterModel filterModel = new FilterModel();
    private static int selectedIndex = -1;

    public FilterDialog(EventTableModel eventTableModel, CategoryTableModel categoryTableModel) {
        super(false);
        this.eventTableModel = eventTableModel;
        this.categoryTableModel = categoryTableModel;
        setValues();
        addFields();
    }

    private String[] getCategoryOptions() {
        String[] nullVal = {null};
        String[] options = categoryTableModel.getCategories()
                .stream()
                .map(CategoryModel::getName)
                .toArray(String[]::new);

        String[] result = new String[Array.getLength(nullVal) + Array.getLength(options)];
        System.arraycopy(nullVal,0, result, 0, nullVal.length);
        System.arraycopy(options, 0, result, nullVal.length, options.length);

        return result;
    }

    private void setValues() {
        dateFieldFrom.setValue(filterModel.getFrom());
        dateFieldTo.setValue(filterModel.getTo());

        categoryField = new JComboBox<>(this.getCategoryOptions());
        categoryField.setSelectedIndex(selectedIndex);
    }

    private void addFields() {
        add("Planned", plannedField, "gap related, align label");
        add("Doing", inProgressField, "gap related, align label");
        add("Done", doneField, "gap related, align label, wrap");
        add("From:", new JDatePicker(dateFieldFrom), "gap related, align label");
        add("To:", new JDatePicker(dateFieldTo), "gap related, wrap");
        add("Category:", categoryField, "gap related, wrap");
    }

    public static void resetFields() {
        doneField.setSelected(false);
        plannedField.setSelected(false);
        inProgressField.setSelected(false);
        dateFieldTo.setValue(null);
        dateFieldFrom.setValue(null);

        if (categoryField != null) {
            categoryField.setSelectedItem(0);
            selectedIndex = 0;
        }

        filterModel.setDone(false);
        filterModel.setPlanned(false);
        filterModel.setInProgress(false);
        filterModel.setTo(null);
        filterModel.setFrom(null);
        filterModel.setCategory(null);

    }

    @Override
    public FilterModel getEntity() {
        filterModel.setPlanned(plannedField.isSelected());
        filterModel.setDone(doneField.isSelected());
        filterModel.setInProgress(inProgressField.isSelected());
        filterModel.setFrom(dateFieldFrom.getValue());
        filterModel.setTo(dateFieldTo.getValue());

        selectedIndex = categoryField.getSelectedIndex();
        filterModel.setCategory(categoryField.getItemAt(selectedIndex));

        return filterModel;
    }
}
