(function() {
    "use strict";

    window.Smoulder = Ember.Application.create({
        //LOG_TRANSITIONS: true,
        //LOG_TRANSITIONS_INTERNAL: true,
        DISABLE_LAZY_ROUTE_CACHING: true
    });

    Smoulder.ApplicationAdapter = DS.RESTAdapter.extend({
        namespace: 'smoulder/v1'
    });

    /*
     * http://stackoverflow.com/questions/105034/create-guid-uuid-in-javascript
     */
    Smoulder.uuid = function() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
            return v.toString(16);
        });
    };

    Smoulder.loadTemplates = (function() {

        var loadedTemplateUrls = [];

        return function(url) {
            var promise = new Promise(function (resolve, reject) {
                if(loadedTemplateUrls[url] != null) {
                    resolve();
                } else {

                    var data = (function() {
                        if (Smoulder.DISABLE_LAZY_ROUTE_CACHING) {
                            return {
                                "_dc": Smoulder.uuid()
                            }
                        } else return undefined
                    }());

                    var jqXHR = $.get(url, data);

                    jqXHR.done(function(data, textStatus, jqXHR) {
                        $(data).filter('script[type="text/x-handlebars"]').each(function () {
                            var templateName = $(this).attr('data-template-name');
                            Ember.TEMPLATES[templateName] = Ember.Handlebars.compile($(this).html());
                        });

                        loadedTemplateUrls[url] = true;
                        resolve();
                    });

                    jqXHR.fail(reject);
                }
            });

            return promise;
        };
    }());

    Smoulder.LazyRoute = Ember.Route.extend({
        templateUrl: null,
        renderTemplate: function() {
            var templateUrl = this.get('templateUrl');
            if (templateUrl != null) {
                var self = this;
                Smoulder.loadTemplates(templateUrl).then(function() {
                    self.render();
                });
            } else {
                this.render();
            }
        }
    });

    Ember.Handlebars.helper('date', function(value, options) {
        var format = options.hash.format || undefined;
        var m = moment(value);
        return new Ember.Handlebars.SafeString(m.format(format));
    });

}());