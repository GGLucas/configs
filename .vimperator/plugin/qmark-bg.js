/*
 * Add a simple mapping to open a quickmark in the background
 *
 */

mappings.add(config.browserModes,
    ["gN"], "Jump to a QuickMark in a new tab, inverting the 'activate' option",
    function (arg) {
        quickmarks.jumpTo(arg,
            /\bquickmark\b/.test(options["activate"]) ?
            liberator.NEW_BACKGROUND_TAB : liberator.NEW_TAB);
    },
    { arg: true });
