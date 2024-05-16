package cz.muni.fi.pv168.project.ui.action;

import cz.muni.fi.pv168.project.ui.dialog.AboutDialog;
import cz.muni.fi.pv168.project.ui.resources.Icons;

import javax.swing.*;
import java.awt.event.ActionEvent;

/**
 * Creating new AboutDialog, triggered by user.
 */
public class AboutAction extends AbstractAction {

    private static final String ABOUT = "About";
    public AboutAction() {
        super(ABOUT, Icons.INFO_ICON);
        putValue(SHORT_DESCRIPTION, ABOUT);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        var dialog = new AboutDialog();
        dialog.show(ABOUT);
    }
}