var factory = require('./module.js');

factory().then((calc) => {
    console.log(calc._add(11, 22));
});

