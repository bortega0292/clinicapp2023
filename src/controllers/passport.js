const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const helpers = require('./helpers');
const pool = require('../settings/db');
passport.use('local.signup', new LocalStrategy(
    {
        usernameField: 'username',
        passwordField: 'password',
        passReqToCallback: true,
        
    }, async (req, username, password, done) =>
    {   const {nombre, apellido, Documento, Rol} = req.body;

        let documento = Documento;
        let rol = parseInt(Rol);
        let newUser = 
        {
            username,
            password,
            nombre,
            apellido,
            documento,
            rol
        };
        console.log(password);
        newUser.password = helpers.encryptPass(password);
        console.log(password);
        const result = await pool.query('INSERT INTO usuarios SET ?', newUser);

        newUser.id = result.insertId;
        return done(null, newUser);
    }));
    
    passport.use('local.signin', new LocalStrategy(
        {
            usernameField:'username',
            passwordField: 'password',
            passReqToCallback: true
        }, async (req, username, password, done) =>
        {
            const resp = await pool.query('SELECT * FROM usuarios WHERE username =?', [username]);

            if (resp.length > 0)
            {
                const user = resp[0];
                const validPass = helpers.matchPass(password, user.password);
                if(validPass)
                {
                    done(null, user);
                }
                else
                {
                    done(null, false);
                }
            }
            else
            {
                return done(null, false);
            }
        }
    ))

    passport.serializeUser((user, done) =>
    {
        done(null, user.id);
    });

    passport.deserializeUser(async (id,done) =>
    {
        const resp = await pool.query('SELECT * FROM usuarios WHERE id =?',[id]);
        done(null, resp[0]);
    })