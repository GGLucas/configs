//
// Adds all the userstyles to vimperator
//
//

/// Get style directory
var styledir = io.getRuntimeDirectories("styles")[0].path;

/// Add styles
// Wikipedia style
styles.addSheet(false,
    // Name
    "Wikipedia:Minimal",
    // Filter
    "en.wikipedia.org",
    // File
    io.readFile(styledir+"/wikipedia.css")
)

// Scroogle style
styles.addSheet(false,
    // Name
    "Scroogle:Minimal",
    // Filter
    "https://ssl.scroogle.org/cgi-bin/nbbwssl.cgi",
    // File
    io.readFile(styledir+"/scroogle.css")
)

// Reddit style
styles.addSheet(false,
    // Name
    "Reddit:Minimal",
    // Filter
    "reddit.com",
    // File
    io.readFile(styledir+"/reddit.css")
)
