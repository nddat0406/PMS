package dal;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class BaseDAO {

    private Connection connection;

    public BaseDAO()  {
        try {
            Properties props = new Properties();
            ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
            InputStream inputStream = classLoader.getResourceAsStream("app.properties");
            props.load(inputStream);
            String driver = props.getProperty("jdbc.driver");
            String url = props.getProperty("jdbc.url");
            String username = props.getProperty("jdbc.username");
            String password = props.getProperty("jdbc.password");
            Class.forName(driver);
            this.connection = DriverManager.getConnection(url, username, password);
        } catch (SQLException | IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    protected Connection getConnection() {
        return this.connection;
    }

    public void closeConnection() {
        if (this.connection != null) {
            try {
                this.connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

}
