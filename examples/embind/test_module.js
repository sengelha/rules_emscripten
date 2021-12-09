factory = require('./module.js');

factory().then((calc) => {
    console.log("abs(-1)=" + calc.abs(-1))
    var m = new calc.libmath;
    console.log("1+2=" + m.add(1, 2));
    console.log("3-1=" + m.sub(3, 1));
});

