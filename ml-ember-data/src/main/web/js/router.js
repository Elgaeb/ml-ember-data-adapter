(function() {
    "use strict";

    Smoulder.Router.map(function () {
        this.resource('persons', {path: '/'});
    });

    Smoulder.PersonsRoute = Ember.Route.extend({
        model: function () {
            return this.store.find('person');
        }
    });

}());