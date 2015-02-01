(function() {
    "use strict";

    Smoulder.Router.map(function () {
        this.resource('persons', function() {
        });

        this.resource('person', function() {
            this.route('edit', { path: ':id' });
            this.route('create');
        });
    });

    Smoulder.IndexRoute = Ember.Route.extend({
        redirect: function() {
            this.transitionTo('persons');
        }
    });

    Smoulder.PersonsRoute = Ember.Route.extend({
        model: function() {
            return this.store.find('person');
        }
    });

    Smoulder.PersonCreateRoute = Ember.Route.extend({
        model: function() {
            return Ember.Object.create({});
        }
    });

    Smoulder.PersonRoute = Ember.Route.extend({
    });

    Smoulder.PersonEditRoute = Ember.Route.extend({
        model: function(params) {
            return this.store.find('person', params.id);
        }
    });

}());