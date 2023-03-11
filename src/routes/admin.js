const express = require('express');
const admin = require('../controllers/c_admin');
const app = express.Router();
const {isLoggedIn} = require('../controllers/auth');

// Todas las Vistas
app.get('/dashboard',isLoggedIn, admin.allVistas);

// Agregar Usuario
app.post('/addUsuario', isLoggedIn, admin.addUsuario);

// Agregar Paciente
app.post('/addPaciente', isLoggedIn, admin.addPaciente);

// Agregar Gasto 
app.post('/addGasto', isLoggedIn, admin.addGasto);

// Agregar Factura 
app.post('/addFactura', isLoggedIn, admin.addFactura);

// Agregar Expediente
app.post('/addExpediente', isLoggedIn, admin.addExpediente);

// Editar Paciente
app.get('/editPaciente/:id', isLoggedIn, admin.editViewPaciente);
app.post('/editPaciente/:id', isLoggedIn, admin.editPacienteUpdt);

// Editar Gasto
app.get('/editGasto/:id', isLoggedIn, admin.vieweditGasto);
app.post('/editGasto/:id', isLoggedIn, admin.editGasto);

// Eliminar Paciente
app.get('/deletePaciente/:id', isLoggedIn, admin.deletePaciente);

// Eliminar Gasto
app.get('/deleteGasto/:id', isLoggedIn, admin.deleteGasto);

// Cancelar Gasto
app.get('/canceledGasto/:id', isLoggedIn, admin.canceledGasto);

// Listar Expedientes de Paciente
app.get('/listExpedientesPaciente/:id', isLoggedIn, admin.listExpedientesPaciente);

// Ver Expediente
app.get('/viewExpediente/:id', isLoggedIn, admin.viewExpediente);

// Ver Factura
app.get('/viewFactura/:id', isLoggedIn, admin.viewFactura);
// Vincular Factura
app.post('/viewFactura/:id', isLoggedIn, admin.linkFactura);

// Ver Pago
app.get('/viewPayment/:id', isLoggedIn, admin.viewPayment);

// Pagar Factura
app.post('/viewPayment/:id', isLoggedIn, admin.PaymentFactura);

// Agendar Cita
app.post('/addCita', isLoggedIn, admin.addCita);

module.exports = app;