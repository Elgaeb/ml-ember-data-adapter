(function() {
    "use strict";

    Smoulder.ApplicationController = Ember.ObjectController.extend({
        init: function() {
            window.store = this.store;
        }
    });

    Smoulder.PostsController = Ember.ArrayController.extend({
        actions: {
            createNewPost: function() {
                this.transitionToRoute('post.create');
            },
            searchPosts: function() {
                console.log("search", this.get('searchQuery'))
            }
        }
    });

    Smoulder.PostCreateController = Ember.ObjectController.extend({
        actions: {
            save: function() {
                var post = this.store.createRecord('post', {
                    author: this.get('model.author'),
                    subject: this.get('model.subject'),
                    body: this.get('model.body')
                });
                post.save();
                this.transitionToRoute('posts')
            }
        }
    });


    Smoulder.PostEditController = Ember.ObjectController.extend({
        actions: {
            deletePost: function() {
                var post = this.get('model');
                post.deleteRecord();
                post.save();
            },
            save: function() {
                var post = this.get('model');
                post.save();
                this.transitionTo('posts');
            },
            saveComment: function() {
                var post = this.get('model');
                var comment = this.store.createRecord('comment', {
                    body: this.get('newComment'),
                    post: this.get('model')
                });
                comment.save().then(function() {
                    post.save();
                });
            }

        }
    });

}());