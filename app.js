const express = require('express');
const app = express();
const mysql = require('./mysql');

app.get('/ver-dados', async (req, res) => {
    try {
        const result = await mysql.execute('SELECT * FROM dados');
        return res.status(200).json(result);
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
});

app.post('/enviar-dados', async (req, res) => {
    try {
        const result = await mysql.execute(`
            INSERT INTO dados 
            (nome_corrida, nome_equipe, total_voltas, tempo_ultima_volta, velocidade_media, posicao) 
            VALUES 
            ("Silverstone", "Ferrari", 50, "00:01:32.450", 180.5, 1), 
            ("Silverstone", "McLaren", 50, "00:01:33.210", 178.2, 2);
        `);

        return res.status(200).json(result);
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
});


app.use((req, res) => {
    return res.status(404).json({
        error: "Rota não encontrada"
    });
});

module.exports = app;