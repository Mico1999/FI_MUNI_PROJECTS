package cz.muni.fi.pv168.project.ui.dialog;

import net.miginfocom.swing.MigLayout;

import javax.swing.*;

import static javax.swing.JOptionPane.*;

/**
 * Functionality of About dialog, which contains information about this application.
 */
public class AboutDialog {
    private final JPanel panel = new JPanel();

    public AboutDialog() {
        panel.setLayout(new MigLayout("wrap 2"));
        var title = new JLabel("TODO list desktop application build in JAVA for PV168\n");
        var names = new JLabel("Authors:");
        var name1 = new JLabel("  Team Leader: Marek Miček, 540461");
        var name2 = new JLabel("  Eliška Šteffelová, 514125");
        var name3 = new JLabel("  Marek Fiala, 541700");
        var name4 = new JLabel("  Peter Rúček, 54045");
        panel.add(title,"wrap");
        panel.add(names, "wrap");
        panel.add(name1, "wrap");
        panel.add(name2, "wrap");
        panel.add(name3, "wrap");
        panel.add(name4, "wrap");
    }

    public void show(String title) {
        JOptionPane.showOptionDialog(null, panel, title,
                CLOSED_OPTION, PLAIN_MESSAGE, null, null, null);
    }
}
