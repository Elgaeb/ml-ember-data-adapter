xquery version "1.0-ml";

module namespace extend = "http://marklogic.com/smoulder/lib/extend";

import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";

declare namespace jb = "http://marklogic.com/xdmp/json/basic";


declare function extend:extend($d1 as node(), $d2 as node()) as node()? {
    if ($d1/@type = "array")
    then element { fn:node-name($d1) } {
        for $att in $d1/attribute()
        where fn:not(fn:exists($d2/attribute()[fn:node-name(.) = fn:node-name($att)]))
        return $att,
        $d2/@*,
        $d2/element()
    }
    else element { fn:node-name($d1) } {
        for $att in $d1/attribute()
        where fn:not(fn:exists($d2/attribute()[fn:node-name(.) = fn:node-name($att)]))
        return $att,
        $d2/@*,
        for $n1 in $d1/node()
        return typeswitch($n1)
            case element() return
                let $n2 := $d2/node()[fn:node-name(.) = fn:node-name($n1)]
                return if (fn:not(fn:exists($n2)))
                    then $n1
                    else extend:extend($n1, $n2)
            default return (),

        for $n2 in $d2/node()
        where fn:not(fn:exists($d1/node()[fn:node-name(.) = fn:node-name($n2)]))
        return $n2
    }
};

declare function extend:prune($d as node()) as node()? {
    if ($d/@type = "null" or ($d/@type = "array" and fn:count($d/node()) = 0))
        then ()
        else element { fn:node-name($d) } {
            $d/@*,
            for $n in $d/node() return typeswitch($n)
                case text() return $n
                case element() return extend:prune($n)
                default return ()
        }
};

