using ValidatedNumerics
using FactCheck

facts("Trig tests") do
    @fact sin(@interval(0.5)) => Interval(0.47942553860420295, 0.47942553860420301)
    @fact sin(@interval(0.5, 1.67)) => Interval(4.7942553860420295e-01, 1.0)
    @fact sin(@interval(1.67, 3.2)) => Interval(-5.8374143427580086e-02, 9.9508334981018021e-01)
    @fact sin(@interval(2.1, 5.6)) => Interval(-1.0, 8.632093666488739e-01)
    @fact sin(@interval(0.5, 8.5)) => Interval(-1.0, 1.0)
    @fact sin(@floatinterval(-4.5, 0.1)) => Interval(-1.0, 0.9775301176650971)
    @fact sin(@floatinterval(1.3, 6.3)) => Interval(-1.0, 1.0)

    @fact cos(@interval(0.5)) => Interval(0.87758256189037265, 0.87758256189037276)
    @fact cos(@interval(0.5, 1.67)) => Interval(-0.09904103659872823, 0.87758256189037276)
    @fact cos(@interval(2.1, 5.6)) => Interval(-1.0, 0.77556587851025016)
    @fact cos(@interval(0.5, 8.5)) => Interval(-1.0, 1.0)
    @fact cos(@interval(1.67, 3.2)) => Interval(-1, -9.90410365987278e-02)

    @fact tan(@interval(0.5)) => Interval(0.54630248984379048, 0.5463024898437906)
    @fact tan(@interval(0.5, 1.67)) => Interval(-Inf, Inf)
    @fact tan(@interval(1.67, 3.2)) => Interval(-1.0047182299210329e+01, 5.8473854459578652e-02)

end