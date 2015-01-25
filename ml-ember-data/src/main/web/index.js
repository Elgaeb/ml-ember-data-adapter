function deletePerson(id) {
    "use strict";
    $.ajax("/smoulder/v1/people/" + id, { type: "DELETE" }).then(function(data, response, xhr) {
        reload();
    });
}

function createRow(person) {
    "use strict";

    return $("<div class='person-row'></div>")
        .append($("<div class='person-id'></div>")).append(person.id)
        .append($("<div class='person-name'></div>")).append(person.name)
        .append($("<div class='person-age'></div>")).append(person.age)
        .append(
            $("<div class='person-edit'></div>")
                .append($("<a href='#'>edit</a>")
                    .on('click', function() {
                        $("input#edit-id").val(person.id);
                        $("input#edit-name").val(person.name);
                        $("input#edit-age").val(person.age);
                        return false;
                    })
                )
        )
        .append(
            $("<div class='person-delete'></div>")
                .append($("<a href='#'>delete</a>")
                    .on('click', function() {
                        deletePerson(person.id);
                        return false;
                    })
            )
        );
}

function reload() {
    "use strict";
    $.ajax("/smoulder/v1/people").then(function(data, response, xhr) {
        var pl = $("#people-list");
        pl.empty();
        for(var f in data.people) {
            pl.append(createRow(data.people[f]));
        }
    });
}

function createPerson() {
    "use strict";

    var age = parseInt($("input#create-age").val());
    var name = $("input#create-name").val();

    var postDoc = {
        person: {
            name: name,
            age: age
        }
    };

    $.ajax(
        "/smoulder/v1/people",
        {
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(postDoc)
        }
    ).then(function(data, response, xhr) {
        reload();
    });
}

function updatePerson() {
    "use strict";

    var age = parseInt($("input#edit-age").val());
    var name = $("input#edit-name").val();
    var id = $("input#edit-id").val();

    var postDoc = {
        person: {
            id: id,
            name: name,
            age: age
        }
    };

    $.ajax(
        "/smoulder/v1/people/" + id,
        {
            type: "PUT",
            contentType: "application/json",
            data: JSON.stringify(postDoc)
        }
    ).then(function(data, response, xhr) {
            reload();
        });
}

$(document).ready(function() {
    "use strict";
    reload();
    $("#create-person-button").on('click', createPerson);
    $("#edit-person-button").on('click', updatePerson);
});

