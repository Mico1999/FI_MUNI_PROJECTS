package cz.muni.fi.pv168.project.ui.style;

import javax.swing.*;
import java.awt.*;

/**
 * Custom design of combo box used in category dialog.
 */
public class CustomCategoryJComboBox extends JTextField implements ListCellRenderer {

    private boolean canSetBackground = false;

    public CustomCategoryJComboBox() {
        super();
        setOpaque(true);
    }

    @Override
    public void setBackground(Color bg) {
        // TODO Auto-generated method stub
        if(!canSetBackground)
        {
            return;
        }

        super.setBackground(bg);
    }

    public Component getListCellRendererComponent(JList list, Object value, int index,
            boolean isSelected, boolean cellHasFocus) {
        canSetBackground = true;
        setText(" ");
        setBackground((Color)value);
        canSetBackground = false;
        return this;
    }
}