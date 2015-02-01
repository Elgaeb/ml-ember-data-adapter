(function() {
    "use strict";

    Smoulder.PersonsController = Ember.ArrayController.extend({
        actions: {
            createNewPerson: function() {
                var name = this.get("newName");
                if (!name.trim()) return;

                var age = parseInt(this.get("newAge"));
                if(age < 1) return;

                var person = this.store.createRecord('person', {
                    name: name,
                    age: age
                });

                this.set("newName", "");
                this.set("newAge", "");

                person.save();
            }
        }
    });

    Smoulder.PersonController = Ember.ObjectController.extend({
        actions: {
            deletePerson: function() {
                var person = this.get('model')
                person.deleteRecord();
                person.save();
            },
            save: function() {
                console.log('save', this.get('model.name'), this.get('model.age'));
                var person = this.get('model');
                person.save();
            }

        }
    });

}());