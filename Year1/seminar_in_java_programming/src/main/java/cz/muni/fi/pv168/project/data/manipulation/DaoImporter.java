package cz.muni.fi.pv168.project.data.manipulation;

import cz.muni.fi.pv168.project.data.storage.dao.DaoSupplier;
import cz.muni.fi.pv168.project.data.storage.dao.DataAccessObject;
import cz.muni.fi.pv168.project.data.storage.db.ConnectionHandler;
import cz.muni.fi.pv168.project.data.storage.entity.CategoryEntity;
import cz.muni.fi.pv168.project.data.storage.entity.EventEntity;
import cz.muni.fi.pv168.project.model.CategoryModel;
import cz.muni.fi.pv168.project.model.DurationModel;
import cz.muni.fi.pv168.project.model.EventModel;
import cz.muni.fi.pv168.project.model.StatusOptions;
import cz.muni.fi.pv168.project.ui.model.CategoryTableModel;
import cz.muni.fi.pv168.project.ui.model.EventTableModel;

import javax.swing.JTable;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Collection;
import java.util.List;
import java.util.Objects;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Supplier;

/**
 * Functionality for importing events and categories from CSV file.
 */
public class DaoImporter implements Importer {
    private final DaoSupplier<CategoryEntity> categoryEntityDaoSupplier;
    private final Supplier<ConnectionHandler> connectionHandlerSupplier;
    private boolean reachedEventsInFile = false;
    private static final String sep = ",";
    private JTable categoryTable;

    public DaoImporter(
            DaoSupplier<EventEntity> eventEntityDaoSupplier,
            DaoSupplier<CategoryEntity> categoryEntityDaoSupplier,
            Supplier<ConnectionHandler> connectionHandlerSupplier) {
        this.categoryEntityDaoSupplier = categoryEntityDaoSupplier;
        this.connectionHandlerSupplier = connectionHandlerSupplier;
    }



    void checkIfEventsReached(String line){
        if(line.strip().equals("EVENTS"))
        {
            this.reachedEventsInFile = true;
        }
    }
    EventModel getEventLine(String line){
        String[] elements = line.split(sep);

        var name = getItem(elements, 0);
        var date = LocalDate.parse(getItem(elements,1));
        var duration = DurationModel.parse(getItem(elements,2));
        var description = getItem(elements, 3);
        var categoryTableModel = (CategoryTableModel) categoryTable.getModel();
        var category = categoryTableModel.getCategory(getItem(elements,4));
        var status = StatusOptions.parse(getItem(elements,5));

        return new EventModel(date, duration, name, description, status, category);
    }

    private boolean filterEvent(String line) {
        checkIfEventsReached(line);
        if (line.isEmpty() || line.equals("SEP=" + sep) || line.strip().equals("EVENTS") || !reachedEventsInFile){
            return false;
        }
        String[] elements = line.split(sep);
        if(elements.length < 1 || elements.length > 6){
            return false;
        }
        String name = getItem(elements, 0);
        if (name == null || name.isEmpty()){
            System.out.println("Name filed for every input is mandatory, skipping one item.");
            return false;
        }
        String date = getItem(elements, 1);
        try {
            assert date != null;
            LocalDate.parse(date);
        }
        catch (DateTimeParseException e){
            System.out.println("Date filed for every input is mandatory, skipping item with name: " + name);
            return false;
        }
        try{
            StatusOptions.parse(getItem(elements,5));
        }catch (IllegalArgumentException e){
            System.out.println("Status filed for every input is mandatory, skipping item with name: " + name);
            return false;
        }
        return true;
    }

    CategoryModel getCategoryLine(String line){
        String[] elements = line.split(sep);

        var name = getItem(elements, 0);
        var duration = DurationModel.parse(getItem(elements, 1));
        var color = CategoryModel.getColorBasedOnIxd(getItem(elements, 2));

        return new CategoryModel(name, duration, color);
    }

    private boolean filterCategory(String line){
        checkIfEventsReached(line);
        if (line.isEmpty() || line.equals("SEP=" + sep) || line.strip().equals("CATEGORIES") || reachedEventsInFile){
            return false;
        }
        String[] elements = line.split(sep);
        if(elements.length < 1 || elements.length > 3){
            return false;
        }
        String name = getItem(elements, 0);
        DataAccessObject<CategoryEntity> categoryDao  = categoryEntityDaoSupplier.get(connectionHandlerSupplier);
        for (CategoryEntity category : categoryDao.findAll()){
            if(Objects.equals(category.name(), name)){
                return false;
            }
        }
        return name != null && !name.isEmpty();
    }

    static String getItem(String[] array, Integer index){
        if(index >= array.length){
            return null;
        }
        return array[index];
    }


    public void importEvents(String filePath, JTable categoryTable, JTable eventTable) {
        this.categoryTable = categoryTable;
        var eventTableModel = (EventTableModel) eventTable.getModel();
        Collection<EventModel> events = getModel(filePath, this::filterEvent, this::getEventLine);
        for(var event : events){
            eventTableModel.addRow(event);
        }
        this.reachedEventsInFile = false;

    }

    public void importCategories(String filePath, JTable categoryTable) {
        Collection<CategoryModel> categories = getModel(filePath, this::filterCategory, this::getCategoryLine);
        var categoryTableModel = (CategoryTableModel) categoryTable.getModel();
        for (var category : categories){
            categoryTableModel.addRow(category);
        }
        this.reachedEventsInFile = false;
    }

    private <T> List<T> getModel(String filePath, Predicate<String> filter, Function<String, T> getLine) {
        try(var reader = new BufferedReader(new FileReader(filePath))){
            return reader.lines().filter(filter).map(getLine).toList();
        }catch (FileNotFoundException exception){
            System.out.println("File can not be created." + exception);
            throw new RuntimeException(exception);
        }catch (IOException exception){
            System.out.println("File can not be opened" + exception);
            throw new RuntimeException(exception);
        }
    }

    @Override
    public void importData(String filePath, JTable categoryTable, JTable eventTable) {
        importCategories(filePath, categoryTable);
        importEvents(filePath, categoryTable, eventTable);
    }
}
