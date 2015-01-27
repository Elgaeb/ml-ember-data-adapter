xquery version "1.0-ml";

import module namespace rest = "http://marklogic.com/appservices/rest" at "/MarkLogic/appservices/utils/rest.xqy";
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";
import module namespace requests = "http://marklogic.com/appservices/requests" at "/xquery/requests.xqy";
import module namespace c = "http://marklogic.com/smoulder/lib/common" at "/xquery/lib/common.xqy";

declare namespace jb = "http://marklogic.com/xdmp/json/basic";

declare function local:create($obj) {
    let $new-id := c:uuid-string()
    let $obj := c:set-id($obj, $new-id)
    let $type := fn:local-name($obj)
    let $_ := xdmp:document-insert(
        fn:concat("/", $type, "/", $new-id),
        $obj,
        xdmp:default-permissions(),
        ($type)
    )

    return element { fn:QName("http://marklogic.com/xdmp/json/basic", "json") } {
        attribute type { "object" },
        $obj
    }
};

let $in-json := xdmp:get-request-body("text")/node()
let $raw := json:transform-from-json($in-json)
let $obj := $raw/*[@type="object"][1]
let $created-obj := local:create($obj)



return (
    xdmp:set-response-content-type("application/json"),
    json:transform-to-json($created-obj)
)
