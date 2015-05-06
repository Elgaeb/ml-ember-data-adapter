(function(){
    "use strict";

    function valueMatches(value, patternOrValue) {
        if(patternOrValue instanceof RegExp) {
            return patternOrValue.test(value);
        } else {
            return value == patternOrValue;
        }
    };

    function RouterFactory(endpoint) {
        var route = Object.create(Router);
        route.endpoint = endpoint;
        route.rule = Router.and.apply(route, Array.prototype.slice.call(arguments, 1));
        route.subroutes = [];
        route.subrouteBuilders = [];
        return route;
    }

    function buildRequest() {
        return {};
    }

    var Router = {

        evaluate: function(request) {
            if(request == null) {
                request = buildRequest();
            }

            if(this.rule(request)) {
                var i = 0;
                var router = this;
                var evalSubroutes = function() {
                    while(i < router.subroutes.length) {
                        var r = router.subroutes[i].evaluate(request);
                        if(r != null) {
                            evalSubroutes.result = r;
                            return true;
                        }
                        i++;
                    }
                    return false;
                };

                if(evalSubroutes()) {
                    return evalSubroutes.result;
                }

                var current;
                while((current = this.subrouteBuilders.pop()) != null) {
                    current.apply(this);
                    if(evalSubroutes()) {
                        return evalSubroutes.result;
                    }
                }
                return this.endpoint;
            }

            return null;
        },

        configure: function(fn) {
            this.subrouteBuilders.push(fn);
            return this;
        },
        route: function(endpoint) {
            var router = RouterFactory.apply(RouterFactory, arguments);
            this.subroutes.push(router);
            return router;
        },
        path: function(path) {
            return function(request) {
                return true;
            };
        },
        post: function() {
            return function(request) {
                return request.method.toUpperCase() == 'POST';
            };
        },
        put: function() {
            return function(request) {
                return request.method.toUpperCase() == 'PUT';
            };
        },
        'delete': function() {
            return function(request) {
                return request.method.toUpperCase() == 'DELETE';
            };
        },
        get: function() {
            return function(request) {
                return request.method.toUpperCase() == 'GET';
            };
        },
        query: function(param, patternOrValue) {
            return function(request) {
                var value = request.query[param];

                if(value == null) {
                    return false;
                }
                if(patternOrValue != null) {
                    return valueMatches(value, patternOrValue);
                }

                return true;
            };
        },
        and: function() {
            var list = Array.prototype.slice.apply(arguments);
            return function(request) {
                var self = this;
                return list.every(function(fn) {
                    return fn.call(self, request);
                });
            };
        },
        or: function() {
            var list = Array.prototype.slice.apply(arguments);
            return function(request) {
                var self = this;
                return list.some(function(fn) {
                    return fn.call(self, request);
                });
            };
        },
        none: function() {
            return this.not(this.or.apply(this, arguments));
        },
        not: function() {
            return function(request) {
                return !fn.call(this, request);
            };
        }

    };


    module.exports = RouterFactory;
}());

