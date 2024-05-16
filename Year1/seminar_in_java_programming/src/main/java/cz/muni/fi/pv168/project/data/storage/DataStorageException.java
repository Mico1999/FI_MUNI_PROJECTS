package cz.muni.fi.pv168.project.data.storage;

/**
 * Exception indicating an error when working with the database.
 */
public class DataStorageException extends RuntimeException {

    private static final long serialVersionUID = 0L;

    public DataStorageException(String message) {
        this(message, null);
    }

    public DataStorageException(String message, Throwable cause) {
        super("Storage error: " +  message, cause);
    }
}
