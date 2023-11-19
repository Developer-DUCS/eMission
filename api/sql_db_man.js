
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
        if (values != null) {
            this.connection.query(sql, values, (err, results, fields) => {
                if (err) {
                    console.error("Error executing query:", err);
                    callback(err, null);
                } else {
                    console.log("Query results:", results);
                    callback(null, results, fields);
                }
            });
        } else {
            this.connection.query(sql, (err, results, fields) => {
                if (err) {
                    console.error("Error executing query:", err);
                    callback(err, null);
                } else {
                    console.log("Query results:", results);
                    callback(null, results, fields);
                }
            });
        }
    }
    
    }



module.exports = {Database};
