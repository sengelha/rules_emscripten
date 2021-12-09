"use strict";

var tape = require('tape');
var factory = require('./module.js');

tape("test module.js", function (test) {
    factory().then((calc) => {
        test.ok(calc.abs(8) == 8);
        test.ok(calc.abs(-5) == 5);
        var m = new calc.libmath();
        test.ok(m.add(11, 22) == 33);
        test.ok(m.sub(44, 11) == 33);
        test.end();
    });
});


factory = require('./module.js');

factory().then((calc) => {
    console.log("abs(-1)=" + calc.abs(-1))
    var m = new calc.libmath;
    console.log("1+2=" + m.add(1, 2));
    console.log("3-1=" + m.sub(3, 1));
});

