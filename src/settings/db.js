const mysql = require('mysql2');
const {database} = require('./keys');
const {promisify} = require('util');

const pool = mysql.createPool(database); 
pool.getConnection((err, conn) =>
{
    if(err)
    {
        if(err.code == 'PROTOCOL_CONNECTION_LOST')
        {
            console.error('La conexion de la base d datos fue CERRADA');
        }
        if(err.code == 'ECONNREFUSED')
        {
            console.error('La conexion de la base d datos fue RECHAZADA');
        }
    }
    if(conn) conn.release();
    console.log('Conectado a BD en Clever-Cloud version 2025');
    return;
});

pool.query = promisify(pool.query);
module.exports = pool;

const moment = require('moment');
const fecha = moment().format('YYYY-MM-DD HH:mm:ss');
console.log("Hora de Aplicacion: " + fecha);