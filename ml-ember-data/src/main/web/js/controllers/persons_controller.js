(function() {
    "use strict";

    Smoulder.PersonsController = Ember.ArrayController.extend({
        actions: {
            createNewPerson: function() {
                this.transitionTo('person.create');
            }
        }
    });

    Smoulder.PersonCreateController = Ember.ObjectController.extend({
        actions: {
            save: function() {
                var person = this.store.createRecord('person', this.get('model'));
                person.save();
                this.transitionTo('persons')
            }
        }
    });


    Smoulder.PersonEditController = Ember.ObjectController.extend({
        actions: {
            deletePerson: function() {
                var person = this.get('model');
                person.deleteRecord();
                person.save();
            },
            save: function() {
                var person = this.get('model');
                person.save();
                this.transitionTo('persons');
            }

        }
    });

}());