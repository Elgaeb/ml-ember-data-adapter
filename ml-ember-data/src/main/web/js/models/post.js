(function() {
    "use strict";

    Smoulder.Post = DS.Model.extend({
        author: DS.attr('string'),
        subject: DS.attr('string'),
        body: DS.attr('string'),
        date: DS.attr('date')
    });

    Smoulder.Comment = DS.Model.extend({
        author: DS.attr('string'),
        body: DS.attr('string'),
        date: DS.attr('date')
    });

}());