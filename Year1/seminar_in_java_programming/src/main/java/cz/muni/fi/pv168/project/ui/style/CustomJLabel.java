package cz.muni.fi.pv168.project.ui.style;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;

/**
 * Custom design of label used in the application.
 */
public class CustomJLabel extends JLabel {

    public CustomJLabel(String label) {
        super(label);
        this.setFont(new Font("Serif", Font.PLAIN ,18));
    }
}
