package cz.muni.fi.pv168.project.ui.dialog;

import cz.muni.fi.pv168.project.model.CategoryModel;
import cz.muni.fi.pv168.project.model.DurationModel;
import cz.muni.fi.pv168.project.model.DurationOption;
import cz.muni.fi.pv168.project.ui.style.CustomCategoryJComboBox;

import javax.swing.JComboBox;
import javax.swing.JPanel;
import javax.swing.JTextField;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.util.Arrays;

/**
 * Dialog containing fields, where user can select name, duration and color of a category.
 */
public class CategoryDialog extends AbstractDialog<CategoryModel> {
    private final JTextField nameField = new JTextField();
    private final JTextField defaultDurationField = new JTextField();
    private final JComboBox durationOptionsComboBox = new JComboBox(Arrays.stream(DurationOption.values()).map(DurationOption::getText).toArray());
    private final JPanel durationPanel = new JPanel(new BorderLayout(40,0));
    private final JComboBox defaultColorComboBox;
    private final CategoryModel category;

    public CategoryDialog(CategoryModel category) {
        super(false);
        this.category = category;
        defaultColorComboBox = new JComboBox(category.COLORS.toArray());
        defaultColorComboBox.setRenderer(new CustomCategoryJComboBox());
        design();
        setValues();
        addFields();
    }

    private void design() {
        Dimension comboBoxSize = new Dimension(100, 20);
        Dimension lineSize = new Dimension(280, 20);

        nameField.setPreferredSize(lineSize);
        defaultDurationField.setPreferredSize(comboBoxSize);
        durationOptionsComboBox.setPreferredSize(comboBoxSize);
        defaultColorComboBox.setPreferredSize(comboBoxSize);

        durationPanel.add(defaultDurationField, BorderLayout.WEST);
        durationPanel.add(durationOptionsComboBox, BorderLayout.EAST);
    }

    private void setValues() {
        if (category.getName() == null){
            nameField.setText("New category");
            defaultDurationField.setText("");
            defaultColorComboBox.setBackground((Color) defaultColorComboBox.getSelectedItem());
        } else {
            nameField.setText(category.getName());
            if (category.getDefaultDuration() == null || category.getDefaultDuration().getValue() == null){
                defaultDurationField.setText("");
                durationOptionsComboBox.setSelectedIndex(0);
            } else {
                defaultDurationField.setText(String.valueOf(category.getDefaultDuration().getValue()));
                durationOptionsComboBox.setSelectedIndex(Arrays.stream(DurationOption.values()).toList()
                        .indexOf(category.getDefaultDuration().getOption()));
            }
            defaultColorComboBox.setBackground(category.getDefaultColor());
        }
        durationOptionsComboBox.addActionListener(e -> onDurationOptionSelectionChanged());
        defaultColorComboBox.addActionListener(e-> colorChanged());
    }

    private void colorChanged() {
        defaultColorComboBox.setBackground((Color) defaultColorComboBox.getSelectedItem());
    }

    private void onDurationOptionSelectionChanged() {
        if (durationOptionsComboBox.getSelectedIndex() == 0){
            defaultDurationField.setText("");
        }
    }

    private void addFields() {
        add("Name:", nameField, "wrap, align label");
        add("Default duration:", durationPanel, "wrap");
        add("Default color:", defaultColorComboBox, "wrap, align label");
    }

    static Integer _default = 1;
    @Override
    public CategoryModel getEntity() {
        if (nameField.getText().isEmpty()){
            this.category.setName("Category #" + _default++);
        } else {
            this.category.setName(nameField.getText());
        }

        if (durationOptionsComboBox.getSelectedIndex() == 0 || defaultDurationField.getText().isEmpty()){
            this.category.setDefaultDuration(null);
        } else {
            try {
                this.category.setDefaultDuration(new DurationModel(Integer.parseInt(defaultDurationField.getText()),
                        (DurationOption.values())[durationOptionsComboBox.getSelectedIndex()]));
            } catch (NumberFormatException e){
                this.category.setDefaultDuration(null);
            }

        }
        this.category.setDefaultColor((Color) defaultColorComboBox.getSelectedItem());
        return this.category;
    }
}
