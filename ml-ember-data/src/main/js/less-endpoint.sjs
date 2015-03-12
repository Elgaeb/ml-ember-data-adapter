declareUpdate();

var json = require("/MarkLogic/json/json.xqy");
var lessc = require("/js/less-wrapper.sjs");
var rest = require("/MarkLogic/appservices/utils/rest.xqy");
var r = require("/xquery/requests");
var c = require("/xquery/lib/common")

var requests = r.options.getElementsByTagNameNS("http://marklogic.com/appservices/rest", "request");
var r = Array.prototype.filter.call(requests, function(request) {
    var endpoint = request.attributes.getNamedItem("endpoint");
    if(endpoint && (endpoint.value == "/js/less-endpoint.sjs")) return true;
});

var map = rest.processRequest(r[0]);
xdmp.setResponseContentType("text/css");

function getCss() {
    var filepath = "/web" + /[^?]*/.exec(xdmp.getOriginalUrl())[0];
    var uri = "less:" + filepath;

    try {
        var existingDoc = cts.doc(uri);
        if (existingDoc != null) {
            existingDoc = JSON.parse(existingDoc);

            existingDoc.imports.push(filepath);

            var lastModified = new Date(c.moduleLatestModified(existingDoc.imports));
            var stampedTime = new Date(existingDoc.timestamp);

            if (stampedTime >= lastModified) {
                return existingDoc.css;
            }
        }
    } catch(ex) {
        // assume there was a problem with the existing document, so regenerate it.
    }

    var output = null;
    output = lessc(filepath);

    if(output != null) {
        xdmp.documentInsert(
            uri,
            output,
            xdmp.defaultPermissions(),
            [ "less-css" ]
        );
    }

    return output.css;
}


getCss();

