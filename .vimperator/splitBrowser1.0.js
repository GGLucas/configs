(function () {

function openSubBrowser(url, aPosition){ // {{{
	var subBrowser = SplitBrowser.addSubBrowser(url, null, aPosition ? aPosition : SplitBrowser.POSITION_RIGHT);
	subBrowser.addEventListener('load',function(){
		subBrowser.removeEventListener('load',arguments.callee,true);
		subBrowser.browser.contentWindow.focus();
	},true);
	return subBrowser;
}

liberator.commands.addUserCommand(["sp[lit]"], "Splits the browser",
        function(args, special) {
            if (typeof(SplitBrowser) == 'object') {
                
                var position = null;
                if (args != '') {
                    args = args.split(/ -/);
                    switch (args[args.length-1].toLowerCase()) {
                        case 'l':
                        case 'left': position = SplitBrowser.POSITION_LEFT; break;
                        case 'r':
                        case 'right': position = SplitBrowser.POSITION_RIGHT; break;
                        case 't':
                        case 'top': position = SplitBrowser.POSITION_TOP; break;
                        case 'bottom':
                        case 'b': position = SplitBrowser.POSITION_BOTTOM; break;
                    }
                    if (position) {
                        args.pop();
                    }
                    var urls = args.join(' -');
                    if (urls){
                        urls = liberator.util.stringToURLArray(urls);
                        var url = typeof urls[0] == 'string' ? urls[0] : urls[0][0];
                        openSubBrowser(url, position);
                        return;
                    }
                }
                openSubBrowser(liberator.buffer.URL, position);

            } else {
                liberator.echoerr('SplitBrowser is not installed or is disabled.');
            }
        }, {});


liberator.commands.addUserCommand(["on[ly]"], "Close all split browsers",
        function (args, special) {
        if (SplitBrowser.browsers.length > 0) {
              SplitBrowser.removeAllSubBrowsers();
              }
        }, {});

liberator.mappings.addUserMap([liberator.modes.NORMAL], ['<C-w><C-w>'], "Switch split browser focus",
        function() {
            var browsers = SplitBrowser.browsers;
            if (SplitBrowser.activeBrowser === gBrowser) {
                SplitBrowser.getSubBrowserById(browsers[0].id).browser.contentWindow.focus();
            } else {
                var id = SplitBrowser.activeSubBrowser.id;
                for (var i=0; i<browsers.length; i++){
                    if (browsers[i].id == id) {
                        if (browsers[i+1]){
                            SplitBrowser.getSubBrowserById(browsers[i+1].id).browser.contentWindow.focus();
                            return true;
                        } else {
                            gBrowser.contentWindow.focus();
                            return true;
                        }
                    }
                }
            }
        })

})();
