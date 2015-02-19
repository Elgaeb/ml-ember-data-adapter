var json = require("/MarkLogic/json/json.xqy");
var lessc = require("/js/lessc");
var rest = require("/MarkLogic/appservices/utils/rest.xqy");
var r = require("/xquery/requests");

var requests = r.options.getElementsByTagNameNS("http://marklogic.com/appservices/rest", "request");
var r = Array.prototype.filter.call(requests, function(request) {
    var endpoint = request.attributes.getNamedItem("endpoint");
    if(endpoint && (endpoint.value == "/js/lc.sjs")) return true;
});

var map = rest.processRequest(r[0]);

var uri = "/web" + /[^?]*/.exec(xdmp.getOriginalUrl())[0];
var output;

lessc(uri, function(out) {
    output = out;
});

xdmp.setResponseContentType("text/css");
output.css;
