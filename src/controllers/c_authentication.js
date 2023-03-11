const pool = require('../settings/db');

let signup = async (req, res) =>

{   const user = await pool.query('SELECT * FROM usuarios WHERE rol=10;');

    res.render('auth/signup', {user});
};
let signin = (req,res) =>
{
    res.render('auth/signin');
}
module.exports =
{
    signup,
    signin
}