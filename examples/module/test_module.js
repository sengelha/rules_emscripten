"use strict";

var tape = require('tape');
var factory = require('./module.js');

tape("test module.js", function (test) {
    factory().then((calc) => {
        test.ok(calc._add(11, 22) == 33);
        test.end();
    });
});
