// Extraer Fecha de sistema con moment
const moment = require('moment');
const pool = require('../settings/db');

// Envia Procedimientos a HandleBars Admin
let allVistas = async (req, res) =>
{  
    const user_id = req.user.id;
    let Add_User = user_id;
    const fecha = moment().format('YYYY-MM-DD HH:mm:ss');
    let Add_Dte = fecha;
    const datasession = await pool.query(`CALL ViewDataSession (${Add_User})`);
    const listUsuarios = await pool.query('CALL ListUsuarios');
    const listPacientes = await pool.query('CALL ListPacientes');
    const listGastos  = await pool.query('CALL ListGastos');
    const listFacturas  = await pool.query('CALL ListFacturas');
    const lastPacientes  = await pool.query('CALL LastPacientes');
    const countUsuarios = await pool.query('CALL CountUsuarios');
    const countPacientes = await pool.query('CALL CountPacientes');
    const countGastos  = await pool.query('CALL CountGastos');
    const sumaGastos = await pool.query('CALL SumaGastos(@suma_gastos)');
    const sumaFacturas = await pool.query('CALL SumaFacturas(@suma_facturas)');
    const listCitas = await pool.query(`CALL ListCitas ('${Add_Dte}')`);
    const listDoctores = await pool.query('CALL ListDoctores');

    let DataSession = datasession[0];
    let ListUsuarios = listUsuarios[0];
    let ListPacientes = listPacientes[0];
    let ListGastos = listGastos[0];
    let ListFacturas = listFacturas[0];
    let LastPacientes = lastPacientes[0];
    let CountUsuarios = countUsuarios[0];
    let CountPacientes = countPacientes[0];
    let CountGastos = countGastos[0];
    let SumaGastos = sumaGastos[0];
    let SumaFacturas = sumaFacturas[0];
    let ListCitas = listCitas[0];
    let ListDoctores = listDoctores[0];

    res.render('admin/admin', {DataSession, ListUsuarios, ListPacientes, ListGastos, ListFacturas, LastPacientes, CountUsuarios, CountPacientes, CountGastos, SumaGastos, SumaFacturas, ListCitas, ListDoctores});
}

// Funcion para Agregar Usuario
let addUsuario = async (req, res)=>
{
    const {username,password,nombre,apellido,documento,rol} = req.body;
    await pool.query(`CALL AddUsuario('${username}','${password}','${nombre}','${apellido}','${documento}',${rol})`);
    res.redirect('/support/dashboard');
}

// Funcion para Agregar Paciente
let addPaciente = async (req, res)=>
{
    const {id_doc, first_name, last_name, brth_dte, address_dir, phone, email, workplace, ocupation, ss_doc, treatment, allergy, asthma, diabts, hypert, pregncy} = req.body;
    let add_user = req.user.id;
    const fecha = moment().format('YYYY-MM-DD HH:mm:ss');
    let add_dte = fecha;
    
    await pool.query(`CALL AddPaciente('${id_doc}','${first_name}','${last_name}','${brth_dte}','${address_dir}','${phone}','${email}','${workplace}','${ocupation}','${ss_doc}',${add_user},'${add_dte}',${treatment},${allergy},${asthma},${diabts},${hypert},${pregncy})`);
    res.redirect('/support/dashboard');
}

// Funcion para Agregar Expediente
let addExpediente = async (req, res)=>
{
    const {patient, tooth_11, tooth_12, tooth_13, tooth_14, tooth_15, tooth_16, tooth_17, tooth_18, tooth_21, tooth_22, tooth_23, tooth_24, tooth_25, tooth_26, tooth_27, tooth_28, tooth_31, tooth_32, tooth_33, tooth_34, tooth_35, tooth_36, tooth_37, tooth_38, tooth_41, tooth_42, tooth_43, tooth_44, tooth_45, tooth_46, tooth_47, tooth_48, treatment} = req.body;
    let add_user = req.user.id;
    const tooths = [tooth_11, tooth_12, tooth_13, tooth_14, tooth_15, tooth_16, tooth_17, tooth_18, tooth_21, tooth_22, tooth_23, tooth_24, tooth_25, tooth_26, tooth_27, tooth_28, tooth_31, tooth_32, tooth_33, tooth_34, tooth_35, tooth_36, tooth_37, tooth_38, tooth_41, tooth_42, tooth_43, tooth_44, tooth_45, tooth_46, tooth_47, tooth_48];   
    for (i = 0; i < tooths.length; i++) 
    {
        tooths[i] = tooths[i] === undefined ? 0 : tooths[i];
    }
    const fecha = moment().format('YYYY-MM-DD HH:mm:ss');
    let add_dte = fecha;
    await pool.query(`CALL AddExpediente(${patient},${tooths[0]},${tooths[1]},${tooths[2]},${tooths[3]},${tooths[4]},${tooths[5]},${tooths[6]},${tooths[7]},${tooths[8]},${tooths[9]},${tooths[10]},${tooths[11]},${tooths[12]},${tooths[13]},${tooths[14]},${tooths[15]},${tooths[16]},${tooths[17]},${tooths[18]},${tooths[19]},${tooths[20]},${tooths[21]},${tooths[22]},${tooths[23]},${tooths[24]},${tooths[25]},${tooths[26]},${tooths[27]},${tooths[28]},${tooths[29]},${tooths[30]},${tooths[31]},'${treatment}',${add_user},'${add_dte}')`);
    res.redirect('/support/dashboard');
}

// Funcion Agregar Gasto
let addGasto = async (req, res) =>
{
    const {amount,tittle, description} = req.body;
    let add_user = req.user.id;
    const fecha = moment().format('YYYY-MM-DD HH:mm:ss');
    let add_dte = fecha;
    await pool.query(`CALL AddGasto('${tittle}','${description}',${add_user},'${add_dte}',${amount})`);
    res.redirect('/support/dashboard');
}

// Funcion Agregar Factura
let addFactura = async (req, res) =>
{
    const {amount, patient} = req.body;
    let add_user = req.user.id;
    const fecha = moment().format('YYYY-MM-DD HH:mm:ss');
    let add_dte = fecha;
    await pool.query(`CALL AddFactura(${amount},${patient},${add_user},'${add_dte}')`);
    res.redirect('/support/dashboard');
}

// Funcion para Editar Paciente
let editViewPaciente = async(req, res) =>
{
    const {id} = req.params;
    let Id = parseInt(id);
    const viewpaciente = await pool.query(`CALL ViewPaciente(${Id})`);
    let ViewPaciente = viewpaciente[0];
    res.render('admin/editPaciente', {ViewPaciente});
}
let editPacienteUpdt = async (req, res) =>
{
    const {id} = req.params;
    const {first_name, last_name, id_doc, ss_doc, brth_dte, address_dir, workplace, ocupation, phone, email, treatment, allergy, asthma, diabts, hypert, pregncy} = req.body;
    const newPaciente = {first_name, last_name, id_doc, ss_doc, brth_dte, address_dir, workplace, ocupation, phone, email, treatment, allergy, asthma, diabts, hypert, pregncy} 
    await pool.query('UPDATE pacientes set ? WHERE id = ?', [newPaciente, id]);
    res.redirect('/support/dashboard');
}

// Funcion para Editar Gasto
let vieweditGasto = async(req, res) =>
{
    const {id} = req.params;
    let Id = parseInt(id);
    const viewgasto = await pool.query(`CALL ViewGasto(${Id})`);
    let ViewGasto = viewgasto[0];
    res.render('admin/editGasto', {ViewGasto});
}
let editGasto = async(req, res) =>
{
    const {id} = req.params;
    const newdescription = req.body;
    const NewDescription = newdescription
    await pool.query('UPDATE gastos set ? WHERE id = ?',[NewDescription, id]);
    res.redirect('/support/dashboard');
}

// Funcion para Eliminar Paciente
let deletePaciente = async(req, res) =>
{
    const {id} = req.params;
    let Id = parseInt(id);
    await pool.query(`CALL DeletePaciente('${Id}')`);
    res.redirect('/support/dashboard');
}

// Funcion para Eliminar Gasto
let deleteGasto = async(req, res) =>
{
    const {id} = req.params;
    let Id = parseInt(id);
    await pool.query(`CALL DeleteGasto('${Id}')`);
    res.redirect('/support/dashboard');
}

// Funcion para Cancelar Gasto
let canceledGasto = async(req, res) =>
{
    const {id} = req.params;
    let Id = parseInt(id);
    await pool.query(`CALL CanceledGasto('${Id}')`);
    res.redirect('/support/dashboard');
}

// Funcion Lista Expedientes de Paciente
let listExpedientesPaciente = async(req, res) =>
{
    const {id} = req.params;
    let Id = parseInt(id);
    const listExpedientesPaciente = await pool.query(`CALL ListExpedientesPaciente(${Id})`);
    const viewpaciente = await pool.query(`CALL ViewPaciente(${Id})`);
    let ListExpedientesPaciente = listExpedientesPaciente[0];
    let ViewPaciente = viewpaciente[0];
    res.render('admin/listExpedientesPaciente', {ListExpedientesPaciente, ViewPaciente});
}

// Funcion Ver Expediente
let viewExpediente = async(req, res) =>
{
    const {id} = req.params;
    let Id = parseInt(id);
    const viewpaciente = await pool.query(`CALL ViewPaciente(${Id})`);
    const viewexpediente = await pool.query(`CALL ViewExpediente(${Id})`);
    const viewpago = await pool.query(`CALL ViewPago(${Id})`);
    let ViewExpediente = viewexpediente[0];
    let ViewPaciente = viewpaciente[0];
    let ViewPago = viewpago[0];
    res.render('admin/viewExpediente', {ViewExpediente, ViewPaciente, ViewPago});
}

// Funcion Vincular Factura
let viewFactura = async(req, res) =>
{
    const {id} = req.params;
    let Id = parseInt(id);
    const viewfactura = await pool.query(`CALL ViewFactura(${Id})`);
    const listexpedientes = await pool.query(`CALL ListExpedientes(${Id})`);
    let ViewFactura = viewfactura[0];
    let ListExpedientes = listexpedientes[0];
    res.render('admin/viewFactura', {ViewFactura, ListExpedientes});
}
let linkFactura = async(req, res) =>
{
    const {id} = req.params;
    const record = req.body;
    const Record = record
    await pool.query('UPDATE facturas set ? WHERE id = ?',[Record, id]);
    res.redirect('/support/dashboard');
}

// Funcion Realizar Pago
let viewPayment = async(req, res) =>
{
    const {id} = req.params;
    let Id = parseInt(id);
    const viewfactura = await pool.query(`CALL ViewFactura(${Id})`);
    let ViewFactura = viewfactura[0];
    res.render('admin/viewPayment', {ViewFactura});
}
let PaymentFactura = async(req, res) =>
{
    const {id}= req.params;
    const {paymtype, payment} = req.body;
    let add_user = req.user.id;
    const fecha = moment().format('YYYY-MM-DD HH:mm:ss');
    let add_dte = fecha;
    await pool.query(`CALL AddPago(${paymtype},${payment},${id},${add_user},'${add_dte}')`);
    res.redirect('/support/dashboard');
}
// Funcion para Agendar Cita
let addCita = async (req, res)=>
{
    const {doctor, patient, date, time, observations} = req.body;
    let add_user = req.user.id;
    const fecha = moment().format('YYYY-MM-DD HH:mm:ss');
    let add_dte = fecha;
    
    await pool.query(`CALL AddCita(${doctor},${patient},'${date}+${time}','${observations}',${add_user},'${add_dte}')`);
    res.redirect('/support/dashboard');
}

module.exports = 
{
    allVistas,
    addUsuario,
    addPaciente,
    addGasto,
    addFactura,
    addExpediente,
    editViewPaciente,
    editPacienteUpdt,
    vieweditGasto,
    editGasto,
    deletePaciente,
    deleteGasto,
    canceledGasto,
    listExpedientesPaciente,
    viewExpediente,
    viewFactura,
    linkFactura,
    viewPayment,
    PaymentFactura,
    addCita
}