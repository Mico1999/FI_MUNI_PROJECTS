package cz.muni.fi.pv168.project.ui;

import cz.muni.fi.pv168.project.data.TableDataGenerator;
import cz.muni.fi.pv168.project.data.storage.dao.CategoryDao;
import cz.muni.fi.pv168.project.data.storage.dao.EventDao;
import cz.muni.fi.pv168.project.data.storage.repository.Repository;
import cz.muni.fi.pv168.project.model.CategoryModel;
import cz.muni.fi.pv168.project.model.EventModel;
import cz.muni.fi.pv168.project.model.RepeatableEventModelManager;
import cz.muni.fi.pv168.project.model.StatusOptions;
import cz.muni.fi.pv168.project.ui.action.AboutAction;
import cz.muni.fi.pv168.project.ui.action.AddCategoryAction;
import cz.muni.fi.pv168.project.ui.action.AddEventAction;
import cz.muni.fi.pv168.project.ui.action.CopyAction;
import cz.muni.fi.pv168.project.ui.action.DeleteCategoryAction;
import cz.muni.fi.pv168.project.ui.action.DeleteEventAction;
import cz.muni.fi.pv168.project.ui.action.EditCategoryAction;
import cz.muni.fi.pv168.project.ui.action.EditEventAction;
import cz.muni.fi.pv168.project.ui.action.ExportAction;
import cz.muni.fi.pv168.project.ui.action.ImportAction;
import cz.muni.fi.pv168.project.ui.action.PasteAction;
import cz.muni.fi.pv168.project.ui.action.filter.FilterAction;
import cz.muni.fi.pv168.project.ui.action.filter.RemoveFilterAction;
import cz.muni.fi.pv168.project.ui.model.CategoryColumnCellRenderer;
import cz.muni.fi.pv168.project.ui.model.CategoryTableModel;
import cz.muni.fi.pv168.project.ui.model.EventColumnCellRenderer;
import cz.muni.fi.pv168.project.ui.model.EventStats;
import cz.muni.fi.pv168.project.ui.model.EventTableModel;
import cz.muni.fi.pv168.project.ui.resources.Icons;
import cz.muni.fi.pv168.project.ui.style.CustomJButton;
import cz.muni.fi.pv168.project.ui.style.CustomJLabel;
import cz.muni.fi.pv168.project.wiring.DependencyProvider;

import javax.swing.Action;
import javax.swing.Box;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JPanel;
import javax.swing.JPopupMenu;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTable;
import javax.swing.ListSelectionModel;
import javax.swing.SwingConstants;
import javax.swing.WindowConstants;
import javax.swing.border.EmptyBorder;
import javax.swing.event.ListSelectionEvent;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.Insets;
import java.awt.Point;
import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

/**
 * Main window class, which is the main window of the application.
 * This class is created when the application is launched.
 */
public class MainWindow {

    private JFrame frame;
    private JMenuBar menuBar;
    private JTable eventTable;
    private JTable categoryTable;
    private JScrollPane eventScrollPane;
    private JScrollPane categoryScrollPane;
    private JLabel eventTableTitle;
    private JLabel categoryTableTitle;
    private JPanel mainPanel;
    private JPanel buttonPanel;
    private JPanel statsPanel;
    CustomJLabel completedEventsValueLabel;
    CustomJLabel inProgressEventsValueLabel;
    private JButton addEventButton;
    private JButton addCategoryButton;
    private JButton setFilterButton;
    private static JButton removeFilterButton;
    private final Action addEventAction;
    private final Action editEventAction;
    private final Action deleteEventAction;
    private final Action addCategoryAction;
    private final Action editCategoryAction;
    private final Action deleteCategoryAction;
    private final Action exportAction;
    private final Action importAction;
    private final FilterAction filterAction;
    private final RemoveFilterAction removeFilterAction;

    private final Repository<EventModel> eventRepository;
    private final Repository<CategoryModel> categoryRepository;

    public MainWindow(DependencyProvider dependencyProvider){
        createFrame();
        createMainPanel();

        JTabbedPane tabbedPane = new JTabbedPane();
        mainPanel.add(tabbedPane);

        eventRepository = dependencyProvider.getEventRepository();
        categoryRepository = dependencyProvider.getCategoryRepository();
        var importer = dependencyProvider.getImporter();
        var exporter = dependencyProvider.getExporter();

        new TableDataGenerator(dependencyProvider.getDatabaseManager()::getConnectionHandler,
                EventDao::new, CategoryDao::new);

        categoryRepository.refresh();
        eventRepository.refresh();

        createCategoryTable(categoryRepository, eventRepository);
        createEventTable(eventRepository);

        tabbedPane.add(eventScrollPane);
        tabbedPane.setTabComponentAt(0,eventTableTitle);
        tabbedPane.add(categoryScrollPane);
        tabbedPane.setTabComponentAt(1,categoryTableTitle);

        RepeatableEventModelManager repeatableEventModelManager = new RepeatableEventModelManager();

        addEventAction = new AddEventAction(eventTable, categoryTable,repeatableEventModelManager);
        filterAction = new FilterAction(eventTable, categoryTable);
        removeFilterAction = new RemoveFilterAction(eventTable, categoryTable);
        editEventAction = new EditEventAction(eventTable, categoryTable);
        deleteEventAction = new DeleteEventAction(eventTable);
        exportAction = new ExportAction(eventTable, categoryTable, exporter);
        importAction = new ImportAction(eventTable, categoryTable, importer, this::refresh);
        eventTable.setComponentPopupMenu(createEventTablePopUpMenu());
        eventTable.setSelectionForeground(Color.GRAY);

        addCategoryAction = new AddCategoryAction(categoryTable);
        editCategoryAction = new EditCategoryAction(categoryTable);
        deleteCategoryAction = new DeleteCategoryAction(categoryTable);
        categoryTable.setComponentPopupMenu(createCategoryTablePopUpMenu());
        categoryTable.setSelectionForeground(Color.decode("#3297FD"));
        categoryTable.setSelectionBackground(Color.WHITE);

        createMenuBar();
        frame.setJMenuBar(menuBar);
        addMenuButtons();
        createStatsPanel();
        changeActionsState(0);
        frame.pack();
    }

    private void createFrame() {
        frame = new JFrame("TODO list");
        Dimension dimension = new Dimension(800,800);
        frame.setMinimumSize(dimension);
        frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);

        frame.addComponentListener(new ComponentAdapter() {
            public void componentResized(ComponentEvent componentEvent) {
                resizeElements();
            }
        });
    }

    private void createMainPanel() {
        mainPanel = new JPanel();
        mainPanel.setLayout(new BorderLayout());
        frame.add(mainPanel, BorderLayout.CENTER);
    }

    private void createMenuBar() {
        menuBar = new JMenuBar();

        menuBar.add(createFileMenu());
        menuBar.add(createEditMenu());
        menuBar.add(createHelpMenu());
    }

    private JMenu createHelpMenu() {
        JMenu helpMenu = new JMenu("Help");

        helpMenu.add(new AboutAction());
        helpMenu.addSeparator();

        return helpMenu;
    }

    private JMenu createFileMenu(){
        JMenu fileMenu = new JMenu("File");

        JMenuItem addFilterMenuItem = new JMenuItem("Set Filter", Icons.FILTER_ICON);
        addFilterMenuItem.addActionListener(filterAction);
        addFilterMenuItem.setToolTipText("Sets filter");

        fileMenu.add(addEventAction);
        fileMenu.add(editEventAction);
        fileMenu.add(deleteEventAction);

        fileMenu.add(addCategoryAction);
        fileMenu.add(addFilterMenuItem);
        fileMenu.addSeparator();

        return fileMenu;
    }

    private JMenu createEditMenu(){
        JMenu editMenu = new JMenu("Edit");
        Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();

        editMenu.add(new CopyAction(eventTable, clipboard));
        editMenu.add(new PasteAction(eventTable, clipboard));
        editMenu.add(exportAction);
        editMenu.add(importAction);

        return editMenu;
    }

    private void addMenuButtons() {

        buttonPanel = new JPanel();
        buttonPanel.setLayout(new FlowLayout(FlowLayout.CENTER, frame.getWidth()/10,frame.getHeight()/5));

        addEventButton = new CustomJButton("Event", Icons.ADD_ICON);
        addEventButton.addActionListener(addEventAction);

        addCategoryButton = new CustomJButton("Category", Icons.ADD_ICON);
        addCategoryButton.addActionListener(addCategoryAction);

        setFilterButton = new CustomJButton("Set filter", Icons.FILTER_ICON);
        setFilterButton.addActionListener(filterAction);

        buttonPanel.add(addEventButton);
        buttonPanel.add(addCategoryButton);
        buttonPanel.add(setFilterButton);

        buttonPanel.setLocation(new Point(400, 100));

        removeFilterButton = new JButton("Remove filter");
        removeFilterButton.addActionListener(removeFilterAction);
        removeFilterButton.setFont(new Font("Serif", Font.BOLD,12));
        removeFilterButton.setEnabled(false);

        buttonPanel.add(removeFilterButton);
        mainPanel.add(buttonPanel, BorderLayout.NORTH);

    }

    public void resizeElements() {
        var border = new EmptyBorder(frame.getHeight()/20, frame.getWidth()/25, frame.getHeight()/10, frame.getWidth()/25);
        buttonPanel.setBorder(border);
        buttonPanel.setLayout(new FlowLayout(FlowLayout.CENTER, frame.getWidth()/10,frame.getHeight()/40));
        resizeButton(addEventButton);
        resizeButton(addCategoryButton);
        resizeButton(setFilterButton);
        statsPanel.setBorder(new EmptyBorder(frame.getHeight()/20, frame.getWidth()/5, frame.getHeight()/10, frame.getWidth()/5));
    }

    public void resizeButton(JButton button) {
        var insets = new Insets(frame.getHeight()/50, frame.getWidth()/25, frame.getHeight()/50, frame.getWidth()/25);
        button.setFont(new Font("Serif",Font.BOLD,frame.getHeight()/50));
        button.setMargin(insets);
    }

    private void createEventTable(Repository<EventModel> eventRepository) {
        var eventTableModel = new EventTableModel(eventRepository);

        eventTable = new JTable(eventTableModel);
        eventTable.setAutoCreateRowSorter(true);
        eventTable.setRowHeight(25);
        eventTable.setFont(new Font("Serif",Font.PLAIN,18));
        eventTable.getTableHeader().setFont(new Font("Serif",Font.BOLD,20));
        eventTable.getSelectionModel().addListSelectionListener(this::rowSelectionChanged);

        eventScrollPane = new JScrollPane(eventTable);

        eventTableTitle = new JLabel("My Events", Icons.STAR_ICON, SwingConstants.RIGHT);
        eventTableTitle.setFont(new Font("Serif",Font.BOLD,30));
        eventTableTitle.setAlignmentX(Component.CENTER_ALIGNMENT);
        eventTableTitle.setBorder(new EmptyBorder(0,0,frame.getHeight()/50,0));
        eventTable.getColumnModel().getColumn(0).setPreferredWidth(150);
        eventTable.getColumnModel().getColumn(0).setCellRenderer(new EventColumnCellRenderer());
        eventTable.getColumnModel().getColumn(1).setPreferredWidth(150);
        eventTable.getColumnModel().getColumn(1).setCellRenderer(new EventColumnCellRenderer());
        eventTable.getColumnModel().getColumn(2).setPreferredWidth(100);
        eventTable.getColumnModel().getColumn(2).setCellRenderer(new EventColumnCellRenderer());
        eventTable.getColumnModel().getColumn(3).setPreferredWidth(200);
        eventTable.getColumnModel().getColumn(3).setCellRenderer(new EventColumnCellRenderer());
        eventTable.getColumnModel().getColumn(4).setPreferredWidth(200);
        eventTable.getColumnModel().getColumn(4).setCellRenderer(new EventColumnCellRenderer());
        eventTable.getColumnModel().getColumn(5).setPreferredWidth(100);
        eventTable.getColumnModel().getColumn(5).setCellRenderer(new EventColumnCellRenderer());
    }

    private void createCategoryTable(Repository<CategoryModel> categoryRepository, Repository<EventModel> eventRepository){
        var categoryTableModel = new CategoryTableModel(categoryRepository,eventRepository);

        categoryTable = new JTable(categoryTableModel);
        categoryTable.setAutoCreateRowSorter(true);
        categoryTable.setRowHeight(25);
        categoryTable.setFont(new Font("Serif",Font.PLAIN,18));
        categoryTable.getTableHeader().setFont(new Font("Serif",Font.BOLD,20));
        categoryTable.getSelectionModel().addListSelectionListener(this::rowSelectionChanged);

        categoryScrollPane = new JScrollPane(categoryTable);
        categoryTableTitle = new JLabel("My Category", Icons.CATEGORY_ICON, SwingConstants.RIGHT);
        categoryTableTitle.setFont(new Font("Serif",Font.BOLD,30));
        categoryTableTitle.setAlignmentX(Component.CENTER_ALIGNMENT);
        categoryTableTitle.setBorder(new EmptyBorder(0,0,frame.getHeight()/50,0));

        categoryTable.getColumnModel().getColumn(2).setCellRenderer(new CategoryColumnCellRenderer());
    }

    private JPopupMenu createEventTablePopUpMenu() {

        var popUpMenu = new JPopupMenu();
        popUpMenu.add(addEventAction);
        popUpMenu.add(editEventAction);
        popUpMenu.add(deleteEventAction);

        return popUpMenu;
    }

    private JPopupMenu createCategoryTablePopUpMenu() {

        var popUpMenu = new JPopupMenu();
        popUpMenu.add(addCategoryAction);
        popUpMenu.add(editCategoryAction);
        popUpMenu.add(deleteCategoryAction);

        return popUpMenu;
    }

    private void createStatsPanel() {

        statsPanel = new JPanel(new GridLayout(1, 2, frame.getWidth()/50, frame.getHeight()/5));
        statsPanel.setBorder(new EmptyBorder(frame.getHeight()/20, frame.getWidth()/5, frame.getHeight()/10, frame.getWidth()/5));
        Box completedEventsBox = Box.createHorizontalBox();
        Box inProgressEventsBox = Box.createHorizontalBox();
        eventTable.getModel().addTableModelListener(e -> onTableChanged());

        CustomJLabel completedEventsLabel = new CustomJLabel("Done events/Total events: ");
        completedEventsValueLabel = new CustomJLabel(
                EventStats.getEventsCount(eventTable, StatusOptions.DONE).toString() + " / " + EventStats.getAllEventsCount(eventTable).toString()
        );
        CustomJLabel inProgressEventsLabel = new CustomJLabel("Events in progress: ");
        inProgressEventsValueLabel = new CustomJLabel(
                EventStats.getEventsCount(eventTable, StatusOptions.DOING).toString()
        );

        completedEventsValueLabel.setPreferredSize(new Dimension(100, 20));
        inProgressEventsValueLabel.setPreferredSize(new Dimension(100, 20));

        completedEventsBox.add(completedEventsLabel);
        completedEventsBox.add(completedEventsValueLabel);
        completedEventsBox.add(Box.createHorizontalGlue());

        inProgressEventsBox.add(Box.createHorizontalGlue());
        inProgressEventsBox.add(inProgressEventsLabel);
        inProgressEventsBox.add(inProgressEventsValueLabel);

        statsPanel.add(completedEventsBox);
        statsPanel.add(inProgressEventsBox);

        mainPanel.add(statsPanel, BorderLayout.PAGE_END);
    }

    private void onTableChanged() {
        completedEventsValueLabel.setText(
                EventStats.getEventsCount(eventTable, StatusOptions.DONE).toString() + " / " + EventStats.getAllEventsCount(eventTable).toString()
        );
        inProgressEventsValueLabel.setText(
                EventStats.getEventsCount(eventTable, StatusOptions.DOING).toString()
        );
    }

    private void rowSelectionChanged(ListSelectionEvent listSelectionEvent) {
        var selectionModel = (ListSelectionModel) listSelectionEvent.getSource();
        var count = selectionModel.getSelectedItemsCount();
        changeActionsState(count);
    }

    private void changeActionsState(int selectedItemsCount) {
        editEventAction.setEnabled(selectedItemsCount == 1);
        deleteEventAction.setEnabled(selectedItemsCount >= 1);
        editCategoryAction.setEnabled(selectedItemsCount == 1);
        deleteCategoryAction.setEnabled(selectedItemsCount >= 1);
    }

    public static JButton getRemoveFilterButton() {
        return removeFilterButton;
    }

    private void refresh() {
        eventRepository.refresh();
        categoryRepository.refresh();
    }
}
