const bcrypt = require('bcryptjs');
const saltRounds = 10;
const helpers = {};

helpers.encryptPass = (password) =>
{
    const salt = bcrypt.genSaltSync(saltRounds);
    const hash = bcrypt.hashSync(password, salt);
    return hash;
};

helpers.matchPass = async (password, savedPassword) =>
{
    try 
    {
        return bcrypt.compare(password, savedPassword);
    }
    catch(error)
    {
        console.log(error);
    }  
};

module.exports = helpers;