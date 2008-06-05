/**
 * Integrates Vimperator with FaviconizeTab
 * MIT License
 *
 * @author Ovidiu Curcan
 * @version 0.1
 */

(function () {
    liberator.commands.addUserCommand(['fav[toggle]'], 'Toogles the faviconized state of the current tab',
        function (arg, special) {
            if (typeof(faviconize) == 'object') {
                faviconize.toggle();
            } else {
                liberator.echoerr('FaviconizeTab is not installed or disabled');
            }
        }, {
        }
    );
})();
