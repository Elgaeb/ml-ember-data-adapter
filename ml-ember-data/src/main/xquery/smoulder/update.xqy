xquery version "1.0-ml";

import module namespace rest = "http://marklogic.com/appservices/rest" at "/MarkLogic/appservices/utils/rest.xqy";
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace requests = "http://marklogic.com/appservices/requests" at "/xquery/requests.xqy";
import module namespace c = "http://marklogic.com/smoulder/lib/common" at "/xquery/lib/common.xqy";

declare namespace sm = "http://marklogic.com/smoulder";
declare namespace jb = "http://marklogic.com/xdmp/json/basic";

declare function local:update($obj, $id) {
    let $obj := c:set-id($obj, $id)
    let $type := fn:local-name($obj)
    let $uri := fn:concat("/", $type, "/", $id)
    let $old := fn:doc($uri)
    let $_ := xdmp:node-replace($old/node(), $obj)

    return element { fn:QName("http://marklogic.com/xdmp/json/basic", "json") } {
        attribute type { "object" },
        $obj
    }
};

let $request := $requests:options/rest:request[@endpoint="/xquery/smoulder/update.xqy"][1]
let $map := rest:process-request($request)
let $id := map:get($map, "id")
let $type := c:type-from-plural(map:get($map, "type"))

let $in-json := xdmp:get-request-body("text")/node()
let $raw := json:transform-from-json($in-json)
let $obj := $raw/*[@type="object"][1]
let $created-obj := local:update($obj, $id)

return (
    xdmp:set-response-content-type("application/json"),
    json:transform-to-json($created-obj)
)
