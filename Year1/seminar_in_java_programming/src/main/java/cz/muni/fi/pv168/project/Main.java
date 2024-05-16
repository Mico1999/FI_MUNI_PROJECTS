package cz.muni.fi.pv168.project;

import com.formdev.flatlaf.FlatIntelliJLaf;
import com.formdev.flatlaf.FlatLightLaf;
import cz.muni.fi.pv168.project.ui.MainWindow;
import cz.muni.fi.pv168.project.wiring.DependencyProvider;
import cz.muni.fi.pv168.project.wiring.ProductionDependencyProvider;

import javax.swing.UIManager;
import java.awt.EventQueue;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Main {

    public static void main(String[] args) {
        initLookAndFeel();
        final DependencyProvider dependencyProvider = new ProductionDependencyProvider();
        EventQueue.invokeLater(() -> new MainWindow(dependencyProvider));
    }

    private static void initLookAndFeel() {
        FlatLightLaf.setup();
        try {
            UIManager.setLookAndFeel( new FlatIntelliJLaf() );
        } catch (Exception ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, "Layout initialization failed", ex);
        }
    }
}

