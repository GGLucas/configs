// ==UserScript==
// @name           Duck Duck Go Shortcut fix
// @match		   http://*duckduckgo.com/*
// @version        0.1
// ==/UserScript==

unsafeWindow.j_down = false;
unsafeWindow.k_down = false;

document.addEventListener("keypress", function (e)
{
    switch (e.charCode)
    {
        case 111: // 'o'
            unsafeWindow.nkn();
            unsafeWindow.nkda();
            unsafeWindow.nkua();
        break;

        case 102: // 'f'
            unsafeWindow.nke();
        break;

        case 106: // 'j'
            if (unsafeWindow.j_down) unsafeWindow.nkda();
            unsafeWindow.j_down = true;
            return false;
        break;

        case 107: // 'k'
            if (unsafeWindow.k_down) unsafeWindow.nkua();
            unsafeWindow.k_down = true;
            return false;
        break;
    }
}, true);

document.addEventListener("keyup", function (e)
{
    unsafeWindow.j_down = false;
    unsafeWindow.k_down = false;
}, false)

