xquery version "1.0-ml";

import module namespace rest = "http://marklogic.com/appservices/rest" at "/MarkLogic/appservices/utils/rest.xqy";
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace requests = "http://marklogic.com/appservices/requests" at "/xquery/requests.xqy";
import module namespace c = "http://marklogic.com/smoulder/lib/common" at "/xquery/lib/common.xqy";


let $request := $requests:options/rest:request[@endpoint="/js/lesscm.xqy"][1]
let $map := rest:process-request($request)

let $id := map:get($map, "id")
let $type := c:type-from-plural(map:get($map, "type"))

let $uri := xdmp:get-original-url()
let $uri := if (fn:contains($uri, "?", "http://marklogic.com/collation/"))
    then fn:substring-before($uri, "?", "http://marklogic.com/collation/")
    else $uri


return (
    xdmp:set-response-content-type("text/plain"),
    xdmp:invoke(
            "/js/less-invoke.sjs",
            (xs:QName("uri"), $uri)
    )
)
