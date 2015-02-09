(function() {
    "use strict";

    Smoulder.PostsController = Ember.ArrayController.extend({
        actions: {
            createNewPost: function() {
                this.transitionTo('post.create');
            }
        }
    });

    Smoulder.PostCreateController = Ember.ObjectController.extend({
        actions: {
            save: function() {
                var post = this.store.createRecord('post', this.get('model'));
                post.save();
                this.transitionTo('posts')
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