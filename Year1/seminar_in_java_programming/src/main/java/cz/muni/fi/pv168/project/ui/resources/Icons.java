package cz.muni.fi.pv168.project.ui.resources;

import javax.swing.Icon;
import javax.swing.ImageIcon;
import java.net.URL;

/**
 * Creating and displaying icons in the application.
 */
public final class Icons {

    public static final Icon DELETE_ICON = createIcon("delete.png");
    public static final Icon EDIT_ICON = createIcon("edit.png");
    public static final Icon ADD_ICON = createIcon("add.png");
    public static final Icon INFO_ICON = createIcon("info.png");
    public static final Icon FILTER_ICON = createIcon("filter.png");
    public static final Icon MANUAL_ICON = createIcon("manual.png");
    public static final Icon EVENT_ICON = createIcon("event.png");
    public static final Icon CATEGORY_ICON = createIcon("categories.png");
    public static final Icon COPY_ICON = createIcon("copy.png");
    public static final Icon PASTE_ICON = createIcon("paste.png");
    public static final Icon STAR_ICON = createIcon("star.png");
    public static final Icon EXPORT_ICON = createIcon("export.png");
    public static final Icon IMPORT_ICON = createIcon("import.png");

    private Icons() {
        throw new AssertionError("This class is not instantiable");
    }

    private static ImageIcon createIcon(String name) {
        URL url = Icons.class.getResource(name);
        if (url == null) {
            throw new IllegalArgumentException("Icon resource not found on classpath: " + name);
        }
        return new ImageIcon(url);
    }
}