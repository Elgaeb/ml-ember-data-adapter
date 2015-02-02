# ml-ember-data-adapter

## What is it?

An adapter for Ember-Data that utilizes MarkLogic as a persistent store.
The goal of the project is to create an adapter that can be used as a drop
in replacement for the FixtureAdapter and requires no custom coding as
models are added to the system. I.e. Once you've done the initial set up
for the adapter, you never have to think about it again.

## Who is it for?

Anyone who wants the path of least resistance in getting an Ember/Ember-Data
application up and running.

## What works so far?

- Simple Create
- Simple Update
- Simple Delete
- Find all
- Find single by id

## What's left to do?

- Documentation!
- Testing.
- CRUD operations on linked objects (may just work already, needs verification.)
- More advanced searching than by id.
