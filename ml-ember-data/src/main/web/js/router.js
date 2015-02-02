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

    Smoulder.PersonsRoute = Smoulder.LazyRoute.extend({
        model: function() {
            return this.store.find('person');
        },
        templateUrl: '/templates/person.html'
    });

    Smoulder.PersonRoute = Ember.Route.extend({
    });

    Smoulder.PersonCreateRoute = Smoulder.LazyRoute.extend({
        model: function() {
            return Ember.Object.create({});
        },
        templateUrl: '/templates/person.html'
    });

    Smoulder.PersonEditRoute = Smoulder.LazyRoute.extend({
        model: function(params) {
            return this.store.find('person', params.id);
        },
        templateUrl: '/templates/person.html'
    });

}());