xquery version "1.0-ml";

module namespace c = "http://marklogic.com/smoulder/lib/common";

declare namespace sm = "http://marklogic.com/smoulder";

declare variable $config := fn:doc("/admin/configuration.xml");

declare function c:remove-outer-type($obj) {
    element { fn:QName(fn:namespace-uri($obj), "json") } {
        $obj/@*,
        $obj/*
    }
};

declare function c:type-from-plural($type-plural as xs:string) as xs:string {
    let $type := $config//sm:plural[@plural=$type-plural]/@singular
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
        let $mr := xdmp:modules-root()
        let $path-parts := c:build-path(fn:tokenize($uri, "[/\\]"))
        let $filesep := fn:substring($mr, fn:string-length($mr))
        let $file-path := fn:concat($mr, fn:string-join($path-parts, $filesep))
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

