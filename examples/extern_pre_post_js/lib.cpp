#include <emscripten/bind.h>

using namespace emscripten;

double myabs(double x) {
    return (x < 0 ? -x : x);
}

template <typename T>
class math
{
public:
    T add(T x, T y) { return x + y; }
    T sub(T x, T y) { return x - y; }
};

EMSCRIPTEN_BINDINGS(libmath) {
    function("abs", &myabs);
    class_<math<double>>("dblmath")
        .constructor()
        .function("add", &math<double>::add)
        .function("sub", &math<double>::sub);
}