package cz.muni.fi.pv168.project.ui.action.filter;

import javax.swing.RowFilter;

/**
 * Remove filter functionality.
 */
public class RemoveEventFilter extends RowFilter {

    public RemoveEventFilter() {
    }

    @Override
    public boolean include(Entry entry) {
        return true;
    }
}
