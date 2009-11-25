// ==UserScript==
// @name           Dinosaur Comics extra text
// @namespace      http://miff.furopolis.org/
// @description    Displays extra text on dinosaur comics pages.
// @include        http://qwantz.com/index.php
// @include        http://qwantz.com/index.php?comic=*
// @include        http://www.qwantz.com/index.php
// @include        http://www.qwantz.com/index.php?comic=*
// ==/UserScript==

/*
            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2004 Sam Hocevar
  14 rue de Plaisance, 75014 Paris, France
 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO. 
*/

function mk_p(text, style){
	var rv = document.createElement("p");
	rv.setAttribute("style", style + "text-align:center;font-style:italic;");
	rv.appendChild(document.createTextNode(text));
	return rv;
}

function got_copy(e){
	var rx = /<span class="rss-title">([^<>]+)<\/span>/i;
	var result = rx.exec(e.responseText);
	if (result){
		var myp = mk_p(result[1], "font-weight:bold;color:white;");
		var comic = document.getElementById("container").getElementsByTagName("div")[1];
		comic.insertBefore(myp, comic.firstChild);
	}
}

try {

var container = document.getElementById("container");

var comic = container.getElementsByTagName("div")[1];
var comic_img = comic.getElementsByTagName("img")[0];

var a_contact = container.getElementsByTagName("a")[1];
var contact_url = a_contact.href;
var contact_subj = contact_url.substring(contact_url.indexOf('=') + 1);

comic.appendChild(mk_p(comic_img.title, "font-size: 0.9em; margin: 1em;"));
comic.appendChild(mk_p(unescape(contact_subj), "font-size: 0.8em; margin: 1em 2em;"));

// I hate the redundancy, but it's the easiest way to get the title.
GM_xmlhttpRequest({ method : "GET", url : window.location.toString(), onload : got_copy });

} catch (ex) {
	alert("Cannot find comic information:\n" + ex.toString());
}
