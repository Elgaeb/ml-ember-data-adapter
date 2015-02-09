(function() {
    "use strict";

    Smoulder.Post = DS.Model.extend({
        author: DS.attr('string'),
        subject: DS.attr('string'),
        body: DS.attr('string'),
        date: DS.attr('date', {
            defaultValue: function() { return new Date(); }
        }),
        comments: DS.hasMany('comment', { async: true })
    });

    Smoulder.PostSerializer = DS.ActiveModelSerializer
        .extend(DS.EmbeddedRecordsMixin)
        .extend({
            attrs: {
                // thanks EmbeddedRecordsMixin!
                comments: {serialize: 'ids', deserialize: 'ids'}
            }
        });

    Smoulder.Comment = DS.Model.extend({
        author: DS.attr('string'),
        body: DS.attr('string'),
        date: DS.attr('date', {
            defaultValue: function() { return new Date(); }
        }),
        post: DS.belongsTo('post')
    });

    Smoulder.Tag = DS.Model.extend({
        name: DS.attr('string')
    });

}());