//Libreria para formato de fechas
var helpers = require('handlebars-helpers')();
const pool = require('../settings/db');
const moment = require('moment');

let index = async(req, res) =>
{   
    const fecha = moment().format('YYYY-MM-DD HH:mm:ss');
    let Add_Dte = fecha;
    const mostPacientes = await pool.query(`CALL ListPacientes`);
    const mostGastos = await pool.query(`CALL ListGastos`);
    const countPacientes = await pool.query('CALL CountPacientes');
    const countGastos = await pool.query('CALL CountGastos');
    const countUsuarios = await pool.query('CALL CountUsuarios');
    const mostCitas = await pool.query(`CALL ListCitas ('${Add_Dte}')`);
    const mostDoctores = await pool.query(`CALL ListDoctores`);

    let MostPacientes = mostPacientes[0];
    let MostGastos = mostGastos[0];
    let CountPacientes = countPacientes[0];
    let CountGastos = countGastos[0];
    let CountUsuarios = countUsuarios[0];
    let MostCitas = mostCitas[0];
    let MostDoctores = mostDoctores[0];

    res.render('index', {MostPacientes, MostGastos, CountPacientes, CountGastos, CountUsuarios, MostCitas, MostDoctores});
}

module.exports =
{
    index
}