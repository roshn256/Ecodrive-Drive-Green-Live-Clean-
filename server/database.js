const sqlite3 = require('sqlite3').verbose();

const initialize = () => {
    const db = new sqlite3.Database('tokens.db');
    
    db.serialize(() => {
        db.run(`CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT,
            tokens INTEGER DEFAULT 0
        )`);
    });
    
    return db;
};

module.exports = { initialize };