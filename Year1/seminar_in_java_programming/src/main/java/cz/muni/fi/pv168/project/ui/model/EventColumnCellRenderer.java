package cz.muni.fi.pv168.project.ui.model;

import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import java.awt.*;

/**
 * Class for rendering (displaying) individual cells in event table.
 */
public class EventColumnCellRenderer extends DefaultTableCellRenderer {

    @Override
    public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int col) {

        JLabel l = (JLabel) super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, col);
        int modelRow = table.getRowSorter().convertRowIndexToModel(row); // change cell color in JTable with setAutoCreateRowSorter(true)
        EventTableModel tableModel = (EventTableModel) table.getModel();
        if (tableModel.getEvent(modelRow).getCategoryModel() != null){
            l.setBackground(tableModel.getEvent(modelRow).getCategoryModel().getDefaultColor());
        } else {
            l.setBackground(Color.white);
        }

        return l;
    }
}
