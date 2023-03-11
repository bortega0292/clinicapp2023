const express = require('express');
const passport = require('passport');
const auth = require('../controllers/c_authentication');
const {isNotLoggedIn} = require('../controllers/auth');
const app = express.Router();
app.get('/signup', isNotLoggedIn, auth.signup);
app.post('/signup',isNotLoggedIn, passport.authenticate('local.signup',
{
    successRedirect: '/req/logout',
    failureRedirect: '/req/signup',
    failureFlash: true
}));

app.get('/signin', isNotLoggedIn, auth.signin);
app.post('/signin',isNotLoggedIn,(req, res, next) =>
{
    passport.authenticate('local.signin',
        {
            successRedirect:'/support/dashboard',
            failureRedirect: '/error',
            failureFlash: true
        })(req, res, next);
});

app.get('/logout', (req, res) =>
{
    req.logout(req.user, err =>
        {
            if(err) return next(err);
            res.redirect('/');
        });
});

module.exports = app;