(function() {
    "use strict";

    Smoulder.Router.map(function () {
        this.resource('posts', function() {
        });

        this.resource('post', function() {
            this.route('edit', { path: ':id' });
            this.route('create');
        });
    });

    Smoulder.IndexRoute = Ember.Route.extend({
        redirect: function() {
            this.transitionTo('posts');
        }
    });

    Smoulder.PostsRoute = Smoulder.LazyRoute.extend({
        model: function() {
            return this.store.find('post');
        },
        templateUrl: '/templates/blog-template.html'
    });

    Smoulder.PostRoute = Ember.Route.extend({
    });

    Smoulder.PostCreateRoute = Smoulder.LazyRoute.extend({
        model: function() {
            return Ember.Object.create({});
        },
        templateUrl: '/templates/blog-template.html'
    });

    Smoulder.PostEditRoute = Smoulder.LazyRoute.extend({
        model: function(params) {
            return this.store.find('post', params.id);
        },
        templateUrl: '/templates/blog-template.html'
    });

}());