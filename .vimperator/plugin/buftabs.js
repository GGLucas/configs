// PLUGIN_INFO {{{
let PLUGIN_INFO =
<VimperatorPlugin>
  <name>Buftabs</name>
  <description>Add buffer tabs to the statusline to save space.</description>
  <version>1.0</version>
  <author mail="lucas@tuple-typed.org" homepage="http://tuple-typed.org/">GGLucas</author>
  <license>WTFPL version 2 (http://sam.zoy.org/wtfpl/)</license>
  <minVersion>2.0</minVersion>
  <maxVersion>2.2</maxVersion>
  <detail><![CDATA[

  == Usage ==
  When the script is loaded it hijacks the statusline to display a list of tabs,
  you can use the "buftabs" option to toggle it on or off.

  == Styling ==
  You can style the buftabs with:

  :style * .buftab { <CSS> }

  and 

  :style * .buftab_selected { <CSS> }

  == Length ==
  You can set the max length of a title before it is cut off with the buftabs_maxlength
  option. It is set to 25 by default.

  ]]></detail>
</VimperatorPlugin>;
// }}}

buftabs = {
    // Update the tabs
    updateUrl: function (url)
    {
        // Get buftabbar
        var buftabs = document.getElementById("liberator-statusline-buftabs");
        var urlWidget = document.getElementById("liberator-statusline-field-url");
        var maxlength = options.get("buftabs_maxlength").get();
        var tabvalue, position=0, selpos;

        //// Empty the tabbar
        while (buftabs.lastChild != null)
            buftabs.removeChild(buftabs.lastChild);
        
        // Create the new tabs
        for (let [i, browser] in tabs.browsers)
        {
            // Title
            if (browser.webProgress.isLoadingDocument)
                tabvalue = "Loading...";
            else
                tabvalue = browser.contentTitle || "Untitled";

            // Check length
            if (tabvalue.length > maxlength)
                tabvalue = tabvalue.substr(0, maxlength-3)+"...";

            // Bookmark icon
            if (liberator.has("bookmarks"))
                if (bookmarks.isBookmarked(browser.contentDocument.location.href))
                    tabvalue += "\u2764";

            // Brackets and index
            tabvalue = "["+(i+1)+"-"+tabvalue+"]";

            // Create label
            var label = document.createElement("label");
            label.tabpos = i;
            label.setAttribute("value", tabvalue);
            buftabs.appendChild(label);

            label.onclick = function ()
            {
                tabs.select(this.tabpos);
            }

            if (tabs.index() == i)
            {
                selpos = [position, label.clientWidth+position];
                label.className = "buftab_selected";
            } else {
                label.className = "buftab";
            }

            position += label.clientWidth;
        }

        // Scroll
        if (selpos[0] < buftabs.scrollLeft || selpos[1] > buftabs.scrollLeft+buftabs.clientWidth)
            buftabs.scrollLeft = selpos[0];

        // Empty url label
        urlWidget.value = "";
    },

    // Create the horizontal box for adding the tabs to
    createBar: function()
    {
        var statusline = document.getElementById("liberator-statusline");
        var buftabs = document.getElementById("liberator-statusline-buftabs");
        var urlWidget = document.getElementById("liberator-statusline-field-url");

        // Only create if it doesn't exist yet
        if (!buftabs)
        {
            buftabs = document.createElement("hbox");
            buftabs.setAttribute("id", "liberator-statusline-buftabs");
            buftabs.setAttribute("flex", "1");
            buftabs.style.overflow = "hidden"

            statusline.insertBefore(buftabs, urlWidget);
        }
    },

    destroyBar: function()
    {
        var statusline = document.getElementById("liberator-statusline");
        var buftabs = document.getElementById("liberator-statusline-buftabs");

        if (buftabs)
            statusline.removeChild(buftabs);
    }
}

var tabContainer = tabs.getBrowser().mTabContainer;

tabContainer.addEventListener("TabMove", function (event) {
    if (options.get("buftabs").get())
        statusline.updateUrl();
}, false);
tabContainer.addEventListener("TabOpen", function (event) {
    if (options.get("buftabs").get())
        statusline.updateUrl();
}, false);
tabContainer.addEventListener("TabClose", function (event) {
    if (options.get("buftabs").get())
        setTimeout(statusline.updateUrl, 0);
}, false);
tabContainer.addEventListener("TabSelect", function (event) {
    if (options.get("buftabs").get())
        statusline.updateUrl();
}, false);

/// Options
options.add(["buftabs", "buftabs"],
        "Control whether to use buftabs in the statusline",
        "number", "1", 
        {
            setter: function (value)
            {
                if (value)
                {
                    buftabs.createBar();
                    buftabs.updateUrl(null);

                    if (!buftabs._statusline_updateUrl)
                        buftabs._statusline_updateUrl = statusline.updateUrl;
                    statusline.updateUrl = buftabs.updateUrl;
                } else {
                    buftabs.destroyBar();

                    if (buftabs._statusline_updateUrl)
                        statusline.updateUrl = buftabs._statusline_updateUrl;
                }

                return value;
            },

            completer: function (context)
            [
                ["0", "Don't show buftabs, show the url"],
                ["1", "Show buftabs"]
            ],

            validator: Option.validateCompleter
        });

options.add(["buftabs_maxlength", "buftabs_maxlength"],
        "Max length of an entry in the buftabs list",
        "number", "25", 
        {
            setter: function (value)
            {
                buftabs.updateUrl();
                return value;
            }
        });
