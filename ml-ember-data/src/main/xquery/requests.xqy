xquery version "1.0-ml";

module namespace requests = "http://marklogic.com/appservices/requests";

import module namespace rest = "http://marklogic.com/appservices/rest" at "/MarkLogic/appservices/utils/rest.xqy";

declare variable $regex-no-id := "^/smoulder/v1/(\w+)/?$";
declare variable $regex-with-id := "^/smoulder/v1/(\w+)/([a-fA-F0-9\-]+)/?$";

declare variable $requests:options as element(rest:options) :=
    <options xmlns="http://marklogic.com/appservices/rest">

        <request uri="[.]less$" endpoint="/js/lc.sjs">
            <http method="GET"/>
        </request>

        <request uri="{$regex-with-id}" endpoint="/xquery/smoulder/get.xqy">
            <uri-param name="type">$1</uri-param>
            <uri-param name="id">$2</uri-param>
            <http method="GET"/>
        </request>

        <request uri="{$regex-no-id}" endpoint="/xquery/smoulder/get-all.xqy">
            <uri-param name="type">$1</uri-param>
            <http method="GET"/>
        </request>

        <request uri="{$regex-no-id}" endpoint="/xquery/smoulder/create.xqy">
            <uri-param name="type">$1</uri-param>
            <http method="POST"/>
        </request>

        <request uri="{$regex-with-id}" endpoint="/xquery/smoulder/update.xqy">
            <uri-param name="type">$1</uri-param>
            <uri-param name="id">$2</uri-param>
            <http method="PUT"/>
        </request>

        <request uri="{$regex-with-id}" endpoint="/xquery/smoulder/delete.xqy">
            <uri-param name="type">$1</uri-param>
            <uri-param name="id">$2</uri-param>
            <http method="DELETE"/>
        </request>

        <request uri="{$regex-with-id}" endpoint="/qconsole.xqy">
            <param name="action"/>
            <param name="sid"/>
            <param name="qid"/>
            <param name="crid"/>
            <param name="querytype"/>
            <param name="cache"/>
            <http method="POST"/>
        </request>

    </options>;
