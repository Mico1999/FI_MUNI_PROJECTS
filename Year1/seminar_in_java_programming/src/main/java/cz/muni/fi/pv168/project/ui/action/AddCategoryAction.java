package cz.muni.fi.pv168.project.ui.action;

import cz.muni.fi.pv168.project.model.CategoryModel;
import cz.muni.fi.pv168.project.ui.dialog.CategoryDialog;
import cz.muni.fi.pv168.project.ui.model.CategoryTableModel;
import cz.muni.fi.pv168.project.ui.resources.Icons;

import javax.swing.*;
import java.awt.event.ActionEvent;

/**
 * Creating new CategoryDialog, triggered by user, creating new category in category table.
 */
public class AddCategoryAction extends AbstractAction{
    private final JTable categoryTable;

    public AddCategoryAction(JTable categoryTable) {
        super("Add Category", Icons.CATEGORY_ICON);
        this.categoryTable = categoryTable;
        putValue(SHORT_DESCRIPTION, "Adds new category");
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        var categoryTableModel = (CategoryTableModel) categoryTable.getModel();
        var dialog = new CategoryDialog(new CategoryModel());
        dialog.show(categoryTable,"Add Category")
                .ifPresent(categoryTableModel::addRow);
    }
}
