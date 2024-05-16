package cz.muni.fi.pv168.project.ui.dialog;

import net.miginfocom.swing.MigLayout;

import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import java.util.Optional;

import static javax.swing.JOptionPane.OK_CANCEL_OPTION;
import static javax.swing.JOptionPane.OK_OPTION;
import static javax.swing.JOptionPane.PLAIN_MESSAGE;

/**
 * Describing methods and attributes for all dialogs in this application, parent of dialog classes.
 * @param <E> any model of an action, which is performed by user
 */
abstract class AbstractDialog<E> {

    public final JPanel panel = new JPanel();

    AbstractDialog() {
        panel.setLayout(new MigLayout("wrap 2"));
    }

    AbstractDialog(boolean value) {
        panel.setLayout(new MigLayout());
    }

    void add(String labelText, JComponent component, String param) {
        var label = new JLabel(labelText);
        panel.add(label);
        panel.add(component, param);
    }

    void add(JLabel label, JComponent component, String param) {
        panel.add(label);
        panel.add(component, param);
    }

    abstract E getEntity();

    public Optional<E> show(JComponent parentComponent, String title) {
        int result = JOptionPane.showOptionDialog(parentComponent, panel, title,
                OK_CANCEL_OPTION, PLAIN_MESSAGE, null, null, null);
        if (result == OK_OPTION) {
            return Optional.of(getEntity());
        } else {
            return Optional.empty();
        }
    }
}
