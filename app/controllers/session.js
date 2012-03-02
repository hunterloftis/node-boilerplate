var passport = require('passport');

module.exports = function(app) {
  return {

    // Login form
    'new': [
      app.middleware.user.is_user,
      function(req, res) {
        res.render('sessions/new');
      }
    ],

    // Login POST
    // TODO: Check referrer to prevent login attacks
    create: [
      passport.authenticate('local', { failureRedirect: '/sessions/fail' }),
      function (req, res) { res.redirect('/'); }
    ],

    fail: [
      function(req, res, next) {
        req.flash('error', '<strong>Login failed:</strong> Double-check and try again?');
        res.redirect('/sessions/login');
      }
    ],

    // Logout
    destroy: function(req, res) {
      req.logout();
      res.redirect('/');
    }
  };

};