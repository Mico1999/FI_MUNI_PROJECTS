package cz.muni.fi.pv168.project.ui.style;

import javax.swing.*;
import java.awt.*;

/**
 * Custom design of button used in the application.
 */
public class CustomJButton extends JButton {

    private JButton button;

    public CustomJButton(String label) {
        super(label);
        this.setFocusPainted(false);
        this.setFont(new Font("Serif", Font.BOLD,20));
        this.setVerticalTextPosition(SwingConstants.CENTER);
        this.setHorizontalTextPosition(SwingConstants.LEFT);
    }

    public CustomJButton(String label, Icon icon) {
        super(label, icon);
        this.setFocusPainted(false);
        this.setFont(new Font("Serif", Font.BOLD,20));
        this.setVerticalTextPosition(SwingConstants.CENTER);
        this.setHorizontalTextPosition(SwingConstants.LEFT);
    }
}
