(function() {
    "use strict";

    window.Smoulder = Ember.Application.create({
        LOG_TRANSITIONS: true,
        LOG_TRANSITIONS_INTERNAL: true
    });

    Smoulder.ApplicationAdapter = DS.FixtureAdapter.extend();

}());