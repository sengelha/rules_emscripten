"use strict";

const runfiles = require(process.env['BAZEL_NODE_RUNFILES_HELPER']);
const args = process.argv.slice(2);
const module_js = runfiles.resolveWorkspaceRelative(args[0]);

var tape = require('tape');
var factory = require(module_js);

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