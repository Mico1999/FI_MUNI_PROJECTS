package cz.muni.fi.pv168.project.ui.action;

import cz.muni.fi.pv168.project.ui.model.CategoryTableModel;
import cz.muni.fi.pv168.project.ui.resources.Icons;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.util.Arrays;
import java.util.Comparator;

/**
 * Deleting of category from category table, triggered by user.
 */
public class DeleteCategoryAction extends AbstractAction{
    private final JTable categoryTable;

    public DeleteCategoryAction(JTable categoryTable) {
        super("Delete Category", Icons.DELETE_ICON);
        this.categoryTable = categoryTable;
        putValue(SHORT_DESCRIPTION, "Deletes selected categories");
        putValue(MNEMONIC_KEY, KeyEvent.VK_D);
        putValue(ACCELERATOR_KEY, KeyStroke.getKeyStroke("ctrl D"));
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        var categoryTableModel = (CategoryTableModel) categoryTable.getModel();
        Arrays.stream(categoryTable.getSelectedRows())
                // view row index must be converted to model row index
                .map(categoryTable::convertRowIndexToModel)
                .boxed()
                // We need to delete rows in descending order to not change index of rows
                // which are not deleted yet
                .sorted(Comparator.reverseOrder())
                .forEach(categoryTableModel::deleteRow);
    }
}
