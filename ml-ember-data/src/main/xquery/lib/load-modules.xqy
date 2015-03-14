xquery version "1.0-ml";

declare namespace dir = "http://marklogic.com/xdmp/directory";
declare namespace var = 'http://marklogic.com/vars';

import module namespace c = "http://marklogic.com/smoulder/lib/common" at "/xquery/lib/common.xqy";

declare function local:module-last-modified($uri as xs:string) as xs:dateTime {
    let $md := xdmp:modules-database()
    return if ($md != 0) then
        let $mr := xdmp:modules-root()
        let $pp := c:normalize-parent-path(fn:concat($mr, $uri))
        let $dir := xdmp:filesystem-directory($pp[1])
        return xs:dateTime($dir//dir:entry[dir:filename = $pp[2]]/dir:last-modified)
    else
        ()
};

let $xqy :=
    "
    xquery version '1.0-ml';

    import module namespace c = 'http://marklogic.com/smoulder/lib/common' at '/xquery/lib/common.xqy';

    declare namespace var = 'http://marklogic.com/vars';
    declare variable $var:root-path as xs:string external;

    for $file in c:explode($var:root-path, ())

    return xdmp:document-load(
      $file/*:filename/string(),
      <options xmlns='xdmp:document-load'>
        <uri>{$file/*:uri/string()}</uri>
        <repair>none</repair>
        <permissions>{xdmp:default-permissions()}</permissions>
      </options>
    )

    "

return xdmp:eval(
        $xqy,
        (xs:QName("var:root-path"), xdmp:modules-root()),
        <options xmlns="xdmp:eval">
            <database>{xdmp:database("smoulder-modules")}</database>
        </options>
)
