xquery version "1.0-ml";

import module namespace rest = "http://marklogic.com/appservices/rest" at "/MarkLogic/appservices/utils/rest.xqy";
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace requests = "http://marklogic.com/appservices/requests" at "/xquery/requests.xqy";
import module namespace c = "http://marklogic.com/smoulder/lib/common" at "/xquery/lib/common.xqy";

declare namespace sm = "http://marklogic.com/smoulder";
declare namespace jb = "http://marklogic.com/xdmp/json/basic";

let $request := $requests:options/rest:request[@endpoint="/xquery/smoulder/delete.xqy"][1]
let $map := rest:process-request($request)

let $id := map:get($map, "id")
let $type := c:type-from-plural(map:get($map, "type"))

let $uri := fn:concat("/", $type, "/", $id)

return (
    xdmp:document-delete($uri),
    xdmp:set-response-content-type("application/json"),
    "{}"
)
