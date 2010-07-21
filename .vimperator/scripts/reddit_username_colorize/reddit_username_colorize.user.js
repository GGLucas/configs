// ==UserScript==
// @name           Reddit Username Colorizer
// @description    Colorizes usernames on reddit comments for easy recognition.
// @include        http://www.reddit.com/*
// ==/UserScript==

/* Settings */

/* Add any colors you wish to be used here. */
var colors = [
    "#c4a000",
    "#fcaf3e",
    "#f57900",
    "#ce5c00",
    "#e9b96e",
    "#c17d11",
    "#8f5902",
    "#4e9a06",
    "#729fcf",
    "#3465a4",
    "#204a87",
    "#ad7fa8",
    "#75507b",
    "#5c3566",
    "#ef2929",
    "#cc0000",
    "#a40000",
];

/* If you want to give yourself a specific color */
var mycolor = null;

(function () {
    if (mycolor != null)
        var myself = unsafeWindow.reddit.logged;

    var authors = document.evaluate(
        "//a[contains(@class, 'author')]",
        document, null,
        XPathResult.UNORDERED_NODE_SNAPSHOT_TYPE,
        null);

    for (var i = 0; i < authors.snapshotLength; i++)
    {
        var elem = authors.snapshotItem(i);
        var author = elem.textContent;
        elem.textContent = "";

        // Get character sum
        var sum = 0;
        for (var j = 0; j < author.length; j++)
            sum += author.charCodeAt(j);

        // Get color
        if (mycolor != null && author == myself)
            var color = mycolor;
        else
            var color = colors[sum % colors.length];

        // Set color
        var span = document.createElement("span");
        span.textContent = author;
        span.style.color = color;
        elem.appendChild(span);
    }
})()
