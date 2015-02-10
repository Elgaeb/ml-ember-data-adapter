var lessc = require("/js/lessc");

uri = "/web" + uri;
var output;

lessc(uri, function(out) {
    output = out;
});

xdmp.setResponseContentType("text/css");
output.css;