package cz.muni.fi.pv168.project.data.manipulation;
import cz.muni.fi.pv168.project.model.CategoryModel;
import cz.muni.fi.pv168.project.model.EventModel;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Collection;

/**
 * Functionality for exporting events and categories into CSV file.
 */
public class CsvExporter implements Exporter {
    private static final String sep = ",";
    private static final String exportName = "Todo_list_data.csv";

    @Override
    public void exportData(Collection<EventModel> events, Collection<CategoryModel> categories, String filePath) {
        try (var writer = new BufferedWriter(new FileWriter(Paths.get(filePath, exportName).toFile()))) {
            writer.write("SEP=" + sep);
            writer.newLine();
            writer.write("CATEGORIES");
            writer.newLine();

            for (var category : categories) {
                String line = String.join(sep, category.getName(),
                        category.getDefaultDuration().getValue().toString() + " " + category.getDefaultDuration().getOption().toString(),
                        String.valueOf(category.getColorIdx(category.getDefaultColor())));
                writer.write(line);
                writer.newLine();
            }
            writer.newLine();
            writer.write("EVENTS");
            writer.newLine();
            for (var event : events) {
                String line = String.join(sep, event.getName(), event.getDate().toString(),
                        event.getDuration().getValue().toString() + " " + event.getDuration().getOption().toString(),
                        event.getDescription(), event.getCategoryModel() == null ? "" : event.getCategoryModel().getName(), event.getStatus().toString());
                writer.write(line);
                writer.newLine();
            }
        } catch (IOException exception) {
            System.out.println("File can not be created." + exception);
        }
    }
}
