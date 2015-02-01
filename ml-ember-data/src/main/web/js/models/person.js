(function() {
    "use strict";

    Smoulder.Person = DS.Model.extend({
        name: DS.attr('string'),
        age: DS.attr('number')
    });

}());