xquery version "1.0-ml";

import module namespace rest = "http://marklogic.com/appservices/rest" at "/MarkLogic/appservices/utils/rest.xqy";
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace requests = "http://marklogic.com/appservices/requests" at "/xquery/requests.xqy";
import module namespace c = "http://marklogic.com/smoulder/lib/common" at "/xquery/lib/common.xqy";

declare namespace sm = "http://marklogic.com/smoulder";
declare namespace jb = "http://marklogic.com/xdmp/json/basic";

declare function local:get-all($type-plural as xs:string) {
    let $type := c:type-from-plural($type-plural)

    let $docs := cts:search(/,
            cts:collection-query($type),
            (
                "unfiltered",
                cts:document-order()
            )

    )

    return element { fn:QName("http://marklogic.com/xdmp/json/basic", "json") } {
        attribute type { "object" },
        element { fn:QName("http://marklogic.com/xdmp/json/basic", $type-plural) } {
            attribute type { "array" },
            $docs/element()/c:remove-outer-type(.)
        }
    }
};

let $request := $requests:options/rest:request[@endpoint="/xquery/smoulder/find.xqy"][1]
let $map := rest:process-request($request)
let $type-plural := map:get($map, "type")

return (
    xdmp:set-response-content-type("application/json"),
    json:transform-to-json(local:get-all($type-plural))
)
