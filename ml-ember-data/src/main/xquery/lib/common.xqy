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