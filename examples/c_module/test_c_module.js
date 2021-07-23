var factory = require('./c_module.js');

factory().then((calc) => {
    console.log(calc._add(11, 22));
});

