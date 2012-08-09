var almostEqual = function( actual, expected, message ) {
  var res = (expected - actual);
  res = res<0 ? -1*res : res;
  QUnit.push( res<0.000001, actual, expected, message );
}