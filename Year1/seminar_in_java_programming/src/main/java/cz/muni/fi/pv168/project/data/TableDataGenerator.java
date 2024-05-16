package cz.muni.fi.pv168.project.data;

import cz.muni.fi.pv168.project.data.storage.dao.DaoSupplier;
import cz.muni.fi.pv168.project.data.storage.dao.DataAccessObject;
import cz.muni.fi.pv168.project.data.storage.db.ConnectionHandler;
import cz.muni.fi.pv168.project.data.storage.entity.CategoryEntity;
import cz.muni.fi.pv168.project.data.storage.entity.EventEntity;
import cz.muni.fi.pv168.project.data.storage.mapper.CategoryMapper;
import cz.muni.fi.pv168.project.data.storage.mapper.EventMapper;
import cz.muni.fi.pv168.project.model.CategoryModel;
import cz.muni.fi.pv168.project.model.DurationModel;
import cz.muni.fi.pv168.project.model.DurationOption;
import cz.muni.fi.pv168.project.model.EventModel;
import cz.muni.fi.pv168.project.model.StatusOptions;

import java.awt.Color;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.function.Supplier;

/**
 * Generating events and categories into tables for presentation purposes.
 */
public class TableDataGenerator {

    private static final List<LocalDate> DATES = List.of(
            LocalDate.of(2020,8,23),
            LocalDate.of(2019,4,27),
            LocalDate.of(2021,7,13),
            LocalDate.of(2022,8,8),
            LocalDate.of(2022,7,23),
            LocalDate.of(2018, 8, 10)
    );
    private static final List<Integer> DURATIONS = List.of(
            2, 5, 8, 15, 67, 2
    );

    private static final List<String> NAMES = List.of(
            "povysavat", "spanielcina", "cvicit", "naucit sa ...", "PV168", "Test"
    );
    private static final List<String> DESCRIPTIONS = List.of(
            "poriadne", "1. lekcia", "brucho", "vsetko mozne", "GUI implementation",
            "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzxyzabcdefghijklmnopqrstuvwxyz"
    );

    private static final List<String> CATEGORIES = List.of(
            "Upratovanie", "Meeting", "Ucenie"
    );

    private static final List<Integer> DEFAULT_DURATIONS = List.of(
            30, 60, 45
    );

    private static final List<Color> COLORS = List.of(
            Color.decode("#EE82EE"), Color.decode("#FA8072"),
            Color.decode("#FFA500"), Color.decode("#EEE8AA"),
            Color.decode("#98FB98"), Color.decode("#AFEEEE"),
            Color.decode("#6495ED"), Color.decode("#F5DEB3")
    );

    private final DataAccessObject<CategoryEntity> categoryDao;
    private final DataAccessObject<EventEntity> eventDao;
    private static final Random random = new Random();

    public TableDataGenerator(Supplier<ConnectionHandler> connections, DaoSupplier<EventEntity> eventDaoSupplier,
                              DaoSupplier<CategoryEntity> categoryDaoSupplier){
        categoryDao = categoryDaoSupplier.get(connections);
        eventDao = eventDaoSupplier.get(connections);

        if (categoryDao.findAll().size() < 2) {
            generateCategories();
        }

        if (eventDao.findAll().size() < 2) {
            generateEvents();
        }
    }

    private void generateCategories(){
        CategoryMapper categoryMapper = new CategoryMapper();
        for (int i = 0; i < CATEGORIES.size(); i++){
            CategoryModel category = new CategoryModel(CATEGORIES.get(i), new DurationModel(DEFAULT_DURATIONS.get(i),
                    DurationOption.MINUTES), COLORS.get(i));
            var entity = categoryDao.create(categoryMapper.mapToEntity(category));
            category.setId(entity.Id());

        }
    }

    private void generateEvents(){
        EventMapper eventMapper = new EventMapper(id -> Optional.empty());
        CategoryMapper categoryMapper = new CategoryMapper();
        for (int i = 0; i < NAMES.size(); i++){
            Random Dice = new Random();
            var categories = categoryDao.findAll().stream().map(categoryMapper::mapToModel).toList();
            int randomIndex = Dice.nextInt(categories.size());
            EventModel event = new EventModel(DATES.get(i), new DurationModel(DURATIONS.get(i), randomDurationOption()), NAMES.get(i),
                    DESCRIPTIONS.get(i), randomStatus(), categories.get(randomIndex));
            var entity = eventDao.create(eventMapper.mapToEntity(event));
            event.setId(entity.Id());
        }
    }

    public static DurationOption randomDurationOption()  {
        DurationOption[] durationOptions = DurationOption.values();
        return durationOptions[random.nextInt(1,durationOptions.length)];
    }

    public static StatusOptions randomStatus()  {
        StatusOptions[] statusOptions = StatusOptions.values();
        return statusOptions[random.nextInt(statusOptions.length)];
    }
}
