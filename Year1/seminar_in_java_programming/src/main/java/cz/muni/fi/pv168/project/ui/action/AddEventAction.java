package cz.muni.fi.pv168.project.ui.action;

import cz.muni.fi.pv168.project.model.*;
import cz.muni.fi.pv168.project.ui.dialog.EventDialog;
import cz.muni.fi.pv168.project.ui.model.CategoryTableModel;
import cz.muni.fi.pv168.project.ui.model.EventTableModel;
import cz.muni.fi.pv168.project.ui.resources.Icons;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;

/**
 * Creating new EventDialog triggered by user, creating new event in event table.
 */
public final class AddEventAction extends AbstractAction {

    private final  JTable eventTable;
    private final  JTable categoryTable;
    private final RepeatableEventModelManager repeatableEventModelManager;

    public AddEventAction(JTable eventTable, JTable categoryTable, RepeatableEventModelManager repeatableEventModelManager) {
        super("Add Event", Icons.EVENT_ICON);
        this.eventTable = eventTable;
        this.categoryTable = categoryTable;
        this.repeatableEventModelManager = repeatableEventModelManager;
        putValue(SHORT_DESCRIPTION, "Adds new event");
        putValue(MNEMONIC_KEY, KeyEvent.VK_A);
        putValue(ACCELERATOR_KEY, KeyStroke.getKeyStroke("ctrl N"));
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        var eventTableModel = (EventTableModel) eventTable.getModel();
        var categoryTableModel = (CategoryTableModel) categoryTable.getModel();
        var dialog = new EventDialog(new EventModel(), categoryTableModel.getCategories());
        dialog.show(eventTable,"Add Event")
                .ifPresent(eventTableModel::addRow);

        if (dialog.repeatableEventModel != null) {
            RepeatableEventsGenerator.generate(dialog.repeatableEventModel, (EventTableModel) eventTable.getModel());
            repeatableEventModelManager.add(dialog.repeatableEventModel);
        }
    }
}
