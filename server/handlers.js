const db = require('./database').initialize();
const { spawn } = require('child_process');

const runMatlab = (script, args) => {
    return new Promise((resolve, reject) => {
        const matlab = spawn('matlab', [
            '-batch',
            `try, ${script}(${args}), catch e, disp(e.message), end`
        ]);
        
        let result = '';
        matlab.stdout.on('data', (data) => result += data.toString());
        matlab.stderr.on('data', (data) => reject(data.toString()));
        matlab.on('close', () => resolve(parseFloat(result)));
    });
};

module.exports = {
    login: async (req, res) => {
        const { email, password } = req.body;
        db.get('SELECT * FROM users WHERE email = ? AND password = ?', 
            [email, password], (err, user) => {
                if (err || !user) return res.status(401).json({ error: 'Invalid credentials' });
                res.json({ tokens: user.tokens });
            });
    },

    signup: async (req, res) => {
        const { name, email, password } = req.body;
        db.run('INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
            [name, email, password], function(err) {
                if (err) return res.status(400).json({ error: 'User exists' });
                res.json({ success: true });
            });
    },

    calculate: async (req, res) => {
        const { distance, vehicle, email } = req.body;
        try {
            const emissions = await runMatlab('calculateFootprint', `${distance}, '${vehicle}'`);
            const tokens = await runMatlab('manageTokens', emissions);
            
            db.run('UPDATE users SET tokens = tokens + ? WHERE email = ?',
                [tokens, email], (err) => {
                    if (err) return res.status(500).json({ error: 'Database error' });
                    res.json({ emissions, tokens });
                });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },

    redeem: async (req, res) => {
        const { cost, email } = req.body;
        try {
            db.get('SELECT tokens FROM users WHERE email = ?', [email], async (err, user) => {
                if (err || !user) return res.status(404).json({ error: 'User not found' });
                
                if (user.tokens < cost) {
                    return res.status(400).json({ error: 'Insufficient tokens' });
                }
                
                await runMatlab('manageTokens', `-${cost}`);
                db.run('UPDATE users SET tokens = tokens - ? WHERE email = ?',
                    [cost, email], (err) => {
                        if (err) return res.status(500).json({ error: 'Database error' });
                        res.json({ success: true });
                    });
            });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }
};