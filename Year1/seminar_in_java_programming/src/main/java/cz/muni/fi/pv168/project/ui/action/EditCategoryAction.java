package cz.muni.fi.pv168.project.ui.action;

import cz.muni.fi.pv168.project.ui.dialog.CategoryDialog;
import cz.muni.fi.pv168.project.ui.model.CategoryTableModel;
import cz.muni.fi.pv168.project.ui.resources.Icons;

import javax.swing.AbstractAction;
import javax.swing.JTable;
import java.awt.event.ActionEvent;

/**
 * Editing a category (changing attributes of a category selected) by user.
 */
public class EditCategoryAction extends AbstractAction{
    private final JTable categoryTable;

    public EditCategoryAction(JTable categoryTable) {
        super("Edit Category", Icons.EDIT_ICON);
        this.categoryTable = categoryTable;
        putValue(SHORT_DESCRIPTION, "Edits new category");
    }

    @Override
    public void actionPerformed(ActionEvent actionEvent) {
        int[] selectedRows = categoryTable.getSelectedRows();
        if (selectedRows.length != 1) {
            throw new IllegalStateException("Invalid selected rows count (must be 1): " + selectedRows.length);
        }
        if (categoryTable.isEditing()) {
            categoryTable.getCellEditor().cancelCellEditing();
        }

        var categoryTableModel = (CategoryTableModel) categoryTable.getModel();
        int modelRow = categoryTable.convertRowIndexToModel(selectedRows[0]);
        var category = categoryTableModel.getCategory(modelRow);
        var dialog = new CategoryDialog(category);
        dialog.show(categoryTable,"Edit Category")
                .ifPresent(e -> categoryTableModel.updateRow(e, modelRow));
    }
}
