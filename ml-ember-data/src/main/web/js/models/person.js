(function() {
    "use strict";

    Smoulder.Person = DS.Model.extend({
        name: DS.attr('string'),
        age: DS.attr('number')
    });

    Smoulder.Person.FIXTURES = [
        {
            id: 1,
            name: "Chris",
            age: 38
        }
    ];

}());