document_root = "/9845/";

document.write("<div style='float:left; font-size:x-small; margin: 0 0 10px 10px; padding: 5px 0;' ><a href='#top'><img src='" + document_root + "common/images/up.gif' alt='up' width='11' height='15' border='0' /> Top of page </a></div>");
document.write("<div style='float:right; font-size:x-small; margin: 0 10px 10px 0; padding: 5px 0;' ><a href='#top'> Top of page <img src='" + document_root + "common/images/up.gif' alt='up' width='11' height='15' border='0' /></a></div>");
document.write("    <div id='footer'>");
document.write("      <p>");
document.write("      <a href='" + document_root + "home/about.html'>About</a> &middot;");
document.write("      <a href='/sphider/search.php'>Search</a> &middot;");
document.write("      <a href='" + document_root + "home/guestbook.php'>Guestbook</a> &middot;");
document.write("      <a href='" + document_root + "home/contact.php'>Contact</a> &middot;");
document.write("      <a href='" + document_root + "home/sitemap.html'>Sitemap</a> &middot;");
document.write("      <a href='" + document_root + "home/downloads.html'>Downloads</a> &middot;");
//document.write("      <a href='" + document_root + "home/forum.html'>Forum</a> &middot;");
document.write("      <a href='" + document_root + "home/terms.html'>Terms of Use</a>");
document.write("      </p>");
document.write("    <!-- end #footer -->");
document.write("    </div>");
document.write("    <p style='text-align: right; padding-right: 10px; margin-top:5px; font-size: x-small;'>Copyright &copy; 2010 A. K&uuml;ckes</p>");

var MenuBar1 = new Spry.Widget.MenuBar("MenuBar1", {imgDown: document_root + "SpryAssets/SpryMenuBarDownHover.gif", imgRight: document_root + "SpryAssets/SpryMenuBarRightHover.gif"});
    