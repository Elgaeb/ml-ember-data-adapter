xquery version "1.0-ml";

import module namespace rest = "http://marklogic.com/appservices/rest" at "/MarkLogic/appservices/utils/rest.xqy";
import module namespace requests = "http://marklogic.com/appservices/requests" at "requests.xqy";

let $_ := xdmp:log(<rw>{xdmp:get-original-url()}</rw>)

let $rewrite := rest:rewrite($requests:options)

let $_ := xdmp:log(<rw>{$rewrite}</rw>)

return if (fn:exists($rewrite))
    then $rewrite
    else fn:concat("/web", xdmp:get-request-url())