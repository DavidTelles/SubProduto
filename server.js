require('dotenv').config();

const http = require('http');
const app = require('./app');

console.log("Servidor iniciando...");

const PORT = process.API_PORT || 3000;

const server = http.createServer(app);

server.listen(PORT, () => {
    console.log("Express rodando na porta", PORT);
});