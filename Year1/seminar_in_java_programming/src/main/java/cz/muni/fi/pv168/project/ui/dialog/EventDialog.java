package cz.muni.fi.pv168.project.ui.dialog;

import cz.muni.fi.pv168.project.model.*;

import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.ScrollPaneConstants;
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;

import cz.muni.fi.pv168.project.ui.model.LocalDateModel;
import org.jdatepicker.DateModel;
import org.jdatepicker.JDatePicker;

/**
 * Dialog containing fields, where user can select attributes of an event.
 */
public class EventDialog extends AbstractDialog<EventModel>{
    private final DateModel<LocalDate> dateField = new LocalDateModel();
    private final JDatePicker eventDate = new JDatePicker(dateField);
    private final JTextField nameField = new JTextField();
    private final JTextField durationTextField = new JTextField();
    private final JComboBox durationOptionsComboBox = new JComboBox(Arrays.stream(DurationOption.values()).map(DurationOption::getText).toArray());
    private final JPanel durationPanel = new JPanel(new BorderLayout(40,0));
    private JComboBox<String> categoryNamesComboBox;
    private final JComboBox statusComboBox = new JComboBox(Arrays.stream(StatusOptions.values()).map(StatusOptions::getText).toArray());
    private final JTextArea descriptionTextArea = new JTextArea("", 5 , 24);
    private JScrollPane descriptionScrollPane;
    private final JCheckBox repeatableEventCheckBox = new JCheckBox();
    private final DateModel<LocalDate> dateFieldFrom = new LocalDateModel();
    private final DateModel<LocalDate> dateFieldTo = new LocalDateModel();
    private final JLabel fromJLabel = new JLabel("From:");
    private final JLabel toJLabel = new JLabel("To:");
    private final JLabel intervalLabel = new JLabel("Set interval:");
    private final JDatePicker fromDatePicker = new JDatePicker(dateFieldFrom);
    private final JDatePicker toDatePicker = new JDatePicker(dateFieldTo);
    private final JComboBox intervalComboBox = new JComboBox(Arrays.stream(EventIntervalOptions.values()).map(EventIntervalOptions::getText).toArray());
    private final EventModel event;
    private final ArrayList<CategoryModel> categories;

    public RepeatableEventModel repeatableEventModel;

    public EventDialog(EventModel event, ArrayList<CategoryModel> categories) {
        this.event = event;
        this.categories = categories;
        if (event.getName() != null){ // when editing disable repeatability
            repeatableEventCheckBox.setEnabled(false);
        }
        design();
        setValues();
        addFields();
    }

    private void design(){
        Dimension comboBoxSize = new Dimension(100,20);
        Dimension lineSize =  new Dimension(280,20);

        descriptionTextArea.setLineWrap(true);
        descriptionScrollPane = new JScrollPane(descriptionTextArea);
        descriptionScrollPane.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);

        eventDate.setPreferredSize(lineSize);
        nameField.setPreferredSize(lineSize);

        durationOptionsComboBox.setPreferredSize(comboBoxSize);
        durationTextField.setPreferredSize(comboBoxSize);
        durationPanel.add(durationTextField, BorderLayout.WEST);
        durationPanel.add(durationOptionsComboBox, BorderLayout.EAST);

        categoryNamesComboBox = new JComboBox<>(categories.stream()
                .map(object -> object.getName()).toArray(String[]::new));
        categoryNamesComboBox.insertItemAt("",0);
        categoryNamesComboBox.setPreferredSize(comboBoxSize);
        statusComboBox.setPreferredSize(comboBoxSize);

        fromDatePicker.setPreferredSize(lineSize);
        toDatePicker.setPreferredSize(lineSize);
        intervalComboBox.setPreferredSize(comboBoxSize);

        fromJLabel.setVisible(false); toJLabel.setVisible(false); intervalLabel.setVisible(false);
        fromDatePicker.setVisible(false); toDatePicker.setVisible(false); intervalComboBox.setVisible(false);
    }

    private void setValues() {
        repeatableEventCheckBox.addActionListener(e -> repeatableChecked());
        categoryNamesComboBox.addActionListener(e -> onCategorySelectionChanged());
        durationOptionsComboBox.addActionListener(e -> onDurationOptionSelectionChanged());

        if (event.getName() == null){
            dateField.setValue(LocalDate.now());
            nameField.setText("New event");
            durationTextField.setText("");
            durationOptionsComboBox.setSelectedIndex(0);
            categoryNamesComboBox.setSelectedIndex(0);
            statusComboBox.setSelectedIndex(Arrays.stream(StatusOptions.values()).toList().indexOf(StatusOptions.PLANNED));
        } else {
            dateField.setValue(event.getDate());
            nameField.setText(event.getName());
            durationOptionsComboBox.setSelectedIndex(Arrays.stream(DurationOption.values()).toList().indexOf(event.getDuration().getOption()));
            if (event.getDuration() == null || event.getDuration().getValue() == null){
                durationTextField.setText("");
            } else {
                durationTextField.setText(String.valueOf(event.getDuration().getValue()));
            }
            descriptionTextArea.setText(event.getDescription());
            if (event.getCategoryModel() == null){
                categoryNamesComboBox.setSelectedIndex(0);
            } else {
                categoryNamesComboBox.setSelectedIndex(categories.indexOf(event.getCategoryModel()) + 1);
            }
            statusComboBox.setSelectedIndex(Arrays.stream(StatusOptions.values()).toList().indexOf(event.getStatus()));
        }
    }

    private void onDurationOptionSelectionChanged() {
        if (durationOptionsComboBox.getSelectedIndex() == 0){
            durationTextField.setText("");
        }
    }

    private void onCategorySelectionChanged() {
        if (categoryNamesComboBox.getSelectedIndex() == 0 ||
                categoryNamesComboBox.getSelectedIndex() == -1){
            return;
        }
        CategoryModel categoryModel = categories.get(categoryNamesComboBox.getSelectedIndex() - 1); // empty category [0]
        if (event.getDuration() == null || event.getDurationText().isEmpty()){
            if (categoryModel.getName() == ""){
                durationTextField.setText("");
                durationOptionsComboBox.setSelectedItem(0);
            } else {
                if (categoryModel.getDefaultDuration().getValue() == null){
                    durationTextField.setText("");
                    durationOptionsComboBox.setSelectedIndex(0);
                } else {
                    durationTextField.setText(String.valueOf(categoryModel.getDefaultDuration().getValue()));
                    durationOptionsComboBox.setSelectedItem(categoryModel.getDefaultDuration().getOption().getText());
                }
            }
        }
        else {
            durationTextField.setText(String.valueOf(event.getDuration().getValue()));
            durationOptionsComboBox.setSelectedItem(event.getDuration().getOption());
        }
    }

    private void repeatableChecked() {
        if (repeatableEventCheckBox.isSelected()) {
            eventDate.setVisible(false);
            fromJLabel.setVisible(true);
            toJLabel.setVisible(true);
            intervalLabel.setVisible(true);
            fromDatePicker.setVisible(true);
            toDatePicker.setVisible(true);
            intervalComboBox.setVisible(true);
            dateFieldFrom.setValue(LocalDate.now());
            dateFieldTo.setValue(LocalDate.now().plusDays(1));

        } else {
            eventDate.setVisible(true);
            fromJLabel.setVisible(false);
            toJLabel.setVisible(false);
            intervalLabel.setVisible(false);
            fromDatePicker.setVisible(false);
            toDatePicker.setVisible(false);
            intervalComboBox.setVisible(false);
        }
    }

    private void addFields() {
        add("Name:", nameField, "wrap, align label");
        add("Date:", eventDate, "wrap");
        add("Duration:",durationPanel, "wrap");
        add("Category:", categoryNamesComboBox, "wrap");
        add("Status:", statusComboBox, "wrap");
        add("Description:", descriptionScrollPane, "align label, wrap");
        add("Repeatable:", repeatableEventCheckBox,"align label, wrap");
        add(fromJLabel, fromDatePicker, "align label, wrap");
        add(toJLabel, toDatePicker, "align label, wrap");
        add(intervalLabel, intervalComboBox, "align label, wrap");
    }

    static Integer _default = 1;
    @Override
    EventModel getEntity() {

        // check whether user want to repeatable event
        if (repeatableEventCheckBox.isSelected()) {
            repeatableEventModel = new RepeatableEventModel();
            repeatableEventModel.setFrom(dateFieldFrom.getValue());
            repeatableEventModel.setTo(dateFieldTo.getValue());
            repeatableEventModel.setInterval(EventIntervalOptions.values()[intervalComboBox.getSelectedIndex()]);
            event.setDate(dateFieldFrom.getValue()); // first repeatable
            repeatableEventModel.getEventModelList().add(event);
        }
        else{
            event.setDate(dateField.getValue());
        }

        if (nameField.getText().isEmpty()){
            event.setName("Event #" + _default++);
        } else {
            event.setName(nameField.getText());
        }

        event.setDescription(descriptionTextArea.getText());
        if (durationTextField.getText().isEmpty() || durationOptionsComboBox.getSelectedIndex() == 0){
            event.setDuration(null);
        } else {
            try {
                event.setDuration(new DurationModel(Integer.parseInt(durationTextField.getText()),
                        (DurationOption.values())[durationOptionsComboBox.getSelectedIndex()]));
            } catch (NumberFormatException e ){
                event.setDuration(null);
            }
        }
        if (categoryNamesComboBox.getSelectedIndex() != -1 && categoryNamesComboBox.getSelectedIndex() != 0){
            event.setCategoryModel(categories.get(categoryNamesComboBox.getSelectedIndex() - 1)); // empty category [0]
        } else {
            event.setCategoryModel(null);
        }
        event.setStatus(StatusOptions.values()[statusComboBox.getSelectedIndex()]);

        return event;
    }
}
