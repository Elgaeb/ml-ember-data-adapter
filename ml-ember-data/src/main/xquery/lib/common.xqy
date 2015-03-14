xquery version "1.0-ml";

module namespace c = "http://marklogic.com/smoulder/lib/common";

declare namespace dir = "http://marklogic.com/xdmp/directory";
declare namespace sm = "http://marklogic.com/smoulder";
declare namespace var = 'http://marklogic.com/vars';

declare variable $CONFIG := fn:doc("/admin/configuration.xml");
declare variable $MODULES_ROOT := xdmp:modules-root();
declare variable $PATH_SEPARATOR := fn:substring($MODULES_ROOT, fn:string-length($MODULES_ROOT));

declare function c:remove-outer-type($obj) {
    element { fn:QName(fn:namespace-uri($obj), "json") } {
        $obj/@*,
        $obj/*
    }
};

declare function c:type-from-plural($type-plural as xs:string) as xs:string {
    let $type := $CONFIG//sm:plural[@plural=$type-plural]/@singular
    let $type := if (fn:exists($type))
        then $type
        else fn:substring($type-plural, 1, fn:string-length($type-plural) - 1)

    return $type
};

declare function c:set-id($obj as element(), $id as xs:string) {
    element { fn:node-name($obj) } {
        $obj/@*,
        element { fn:QName(fn:namespace-uri($obj), "id") } {
            attribute { "type" } { "string" },
            text { $id }
        },
        $obj/*[fn:local-name(.) != 'id']
    }
};

declare private function c:build-path($remaining as xs:string*, $stack as xs:string*) as xs:string* {
    if (fn:exists($remaining)) then
        if ($remaining[1] = "..") then
            c:build-path($remaining[2 to fn:count($remaining)], $stack[1 to (fn:count($stack) - 1)])
        else
            c:build-path($remaining[2 to fn:count($remaining)], ($stack, $remaining[1]))
    else
        $stack
};

declare private function c:build-path($remaining as xs:string*) as xs:string* {
    c:build-path($remaining[. != "." and . != ""], ())
};

declare function c:normalize-path($uri as xs:string) as xs:string {
    let $path-parts := c:build-path(fn:tokenize($uri, "[/\\]"))
    let $normalized :=  fn:string-join($path-parts, $PATH_SEPARATOR)
    return if (fn:matches($uri, "^[/\\]"))
        then fn:concat($PATH_SEPARATOR, $normalized)
        else $normalized
};

declare function c:normalize-parent-path($uri as xs:string) as xs:string* {
    let $path-parts := c:build-path(fn:tokenize($uri, "[/\\]"))
    let $normalized :=  fn:string-join($path-parts[fn:position() < fn:last()], $PATH_SEPARATOR)
    return if (fn:matches($uri, "^[/\\]"))
        then (fn:concat($PATH_SEPARATOR, $normalized), $path-parts[fn:last()])
        else ($normalized, $path-parts[fn:last()])
};

declare function c:explode($mr as xs:string, $uri as xs:string?) {
    let $mr-len := fn:string-length($mr)
    let $pp := c:normalize-path(fn:concat($mr, $uri))

    let $res := xdmp:filesystem-directory($pp)

    let $files := (
        for $f in $res/dir:entry[dir:type = 'directory']
        let $filename := fn:string($f/dir:pathname)
        let $uri := fn:substring($filename, $mr-len)
        return c:explode($mr, $uri),

        for $f in $res/dir:entry[dir:type = 'file']
        let $filename := fn:string($f/dir:pathname)
        let $uri := fn:substring($filename, $mr-len)
        return
            <file>
                <filename>{$filename}</filename>
                <uri>{$uri}</uri>
            </file>
    )

    return $files
};

declare private function c:module-last-modified($uri as xs:string) as xs:dateTime {
    let $mr := xdmp:modules-root()
    let $pp := c:normalize-parent-path(fn:concat($mr, $uri))
    let $dir := xdmp:filesystem-directory($pp[1])

    return xs:dateTime($dir//dir:entry[dir:filename = $pp[2]]/dir:last-modified)
};

declare function c:module-latest-modified($uri as xs:string*) as xs:dateTime {
    let $md := xdmp:modules-database()
    return if ($md != 0) then
        xdmp:eval("
            xquery version '1.0-ml';
            declare namespace var = 'http://marklogic.com/vars';
            declare namespace prop = 'http://marklogic.com/xdmp/property';
            declare variable $var:uri as xs:string* external;
            fn:max(xdmp:document-properties($var:uri)//prop:last-modified/xs:dateTime(.))
            ",
            map:new((
                map:entry(xdmp:key-from-QName(xs:QName("var:uri")), $uri)
            )),
            <options xmlns="xdmp:eval">
                <database>{$md}</database>
            </options>
        )
    else
        fn:max(c:module-last-modified($uri))
};

declare function c:module-doc($uri as xs:string) {
    let $md := xdmp:modules-database()
    return if ($md != 0) then
        xdmp:invoke-function(
            function() { fn:doc($uri) },
            <options xmlns="xdmp:eval">
                <database>{$md}</database>
            </options>
        )
    else
        let $path-parts := c:build-path(fn:tokenize($uri, "[/\\]"))
        let $file-path := fn:concat($MODULES_ROOT, fn:string-join($path-parts, $PATH_SEPARATOR))
        return if (xdmp:filesystem-file-exists($file-path)) then
            xdmp:filesystem-file($file-path)
        else
            ()
};

declare function c:hex32($v as xs:unsignedLong) {
    fn:substring(xdmp:integer-to-hex(
            xdmp:or64(xdmp:and64($v, 65535), 983040) (: ($v & 0xFFFF) | 0xF0000 :)
    ), 2, 4)
};

declare function c:uuid-string() as xs:string {
    fn:string-join(
            (
                c:hex32(xdmp:random()),
                c:hex32(xdmp:random()),
                "-",
                c:hex32(xdmp:random()),
                "-",
                c:hex32(xdmp:or64(xdmp:and64(xdmp:random(), 4095), 16384)), (: ($v & 0x0FFF) | 0x4000 :)
                "-",
                c:hex32(xdmp:or64(xdmp:and64(xdmp:random(), 16383), 32768)), (: ($v & 00111111) | 10000000 :)
                "-",
                c:hex32(xdmp:random()),
                c:hex32(xdmp:random()),
                c:hex32(xdmp:random())
            )

    )
};

