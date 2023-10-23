
const mysql = require("mysql");

class Database {
    
    constructor(config) {
        this.connection = mysql.createConnection(config);
    }

    connect() {
        this.connection.connect((err) => {
            if (err) {
                console.log("Error connecting to MySQL:", err);
            } else {
                console.log("Connection established");
            }
        });
    }

    disconnect() {
        this.connection.end((err) => {
            if (err) {
                console.log("Error disconnecting from MySQL:", err);
            } else {
                console.log("Connection terminated");
            }
        });
    }

    query(sql, values, callback) {
        this.connection.query(sql, values, (err, results, fields) => {
            if (err) {
                console.log("Error executing query:", err);
                callback(err, null);
            } else {
                callback(null, results, fields);
            }
        });
    }
}

module.exports = Database;
