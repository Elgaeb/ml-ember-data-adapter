(function() {
    "use strict";

    Smoulder.Router.map(function () {
        this.resource('persons', function() {
            this.route('new');
            this.route('edit');
        });

        this.resource(
            'person',
            {
                path: '/person/:id'
            },
            function() {

            }
        );
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

    Smoulder.PersonRoute = Ember.Route.extend({
        model: function(params) {
            return this.store.find('person', params.id);
        }
    });

}());