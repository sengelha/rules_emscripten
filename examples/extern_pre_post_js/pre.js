// Begin UMD prefix
(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        console.log("registering as anonymous");
        // AMD.  Register as an anonymous module.
        define([], factory);
    } else if (typeof module === 'object' && module.exports) {
        console.log("setting module.exports");
        module.exports = factory();
    } else {
        console.log("setting root.libmath");
        root.libmath = factory();
    }
}(typeof self !== 'undefined' ? self : this, function () {
// End UMD prefix

