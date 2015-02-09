module.exports = (function() {
    "use strict";

    var c = require("/xquery/lib/common");
    var lessFactory = require("/js/less-marklogic");
    var abstractFileManager = new (lessFactory(environment)).AbstractFileManager();

    var environment = {
        encodeBase64: xdmp.base64Encode
    };

    var MarkLogicFileManager = function(currentDirectory) {
        this.currentDirectory = currentDirectory;
    };
    MarkLogicFileManager.prototype = abstractFileManager;
    MarkLogicFileManager.prototype.supportsSync = function(filename, currentDirectory, options, environment) {
        return true;
    };
    MarkLogicFileManager.prototype.supports = function(filename, currentDirectory, options, environment) {
        return true;
    };
    MarkLogicFileManager.prototype.loadFile = function(filename, currentDirectory, options, environment, syncFn) {
        var uri = c.normalizePath(this.join(this.currentDirectory, filename));
        var res = {
            filename: uri,
            contents: "" + c.moduleDoc(uri)
        };
        syncFn(null, res);
    };

    MarkLogicFileManager.prototype.loadFileSync = function(filename, currentDirectory, options, environment) {
    };


    return function(uri, success, failure) {

        var path = abstractFileManager.getPath(uri);
        var fm = new MarkLogicFileManager(path);
        var less = lessFactory(environment, [fm]);

        var lf = "" + c.moduleDoc(uri);
        less.render(lf, {}, function(error, out) {

            if(error) {
                if(failure) {
                    failure(error);
                }
            } else {
                success(out);
            }
        });

    };
}());

