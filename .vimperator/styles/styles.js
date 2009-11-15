/**
 * Adds all the userstyles to vimperator
 *
 */

/// Add styles
liberator.userstyles = [
    [
        "wikipedia:minimal",
        "en.wikipedia.org",
        "wikipedia.css",
    ],

    [
        "scroogle:minimal",
        "https://ssl.scroogle.org/cgi-bin/nbbwssl.cgi",
        "scroogle.css",
    ],

    [
        "reddit:minimal",
        "reddit.com",
        "reddit.css",
    ],

    [
        "archlinux-forums:minimal",
        "bbs.archlinux.org",
        "archlinux.forum.css",
    ],

    [
        "tvtorrents:minimal",
        "tvtorrents.com",
        "tvtorrents.css",
    ]
];

/// Command to load all styles
var loaduserstyles = function()
{
    // Get style directory
    var styledir = io.getRuntimeDirectories("styles")[0].path;

    for ([i, [name, filter, file]] in Iterator(liberator.userstyles))
    {
      // Remove all sheets with this filter
      styles.removeSheet(false, name)

      // Add the sheet
      styles.addSheet(false, name, filter, 
      io.readFile(styledir+"/"+file))
    }
}

// Initial load
loaduserstyles()

// Add it as a command
commands.add(
    ["loaduserstyles"],
    "Load all user styles",
    loaduserstyles
);
