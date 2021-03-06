var convnetjs = require('./node_modules/convnetjs');
var data = require('./carve_error_report_data3.json')

var layer_defs = [];
// minimal network: a simple binary SVM classifer in 2-dimensional space
layer_defs.push({type:'input', out_sx:1, out_sy:1, out_depth:4});
layer_defs.push({type:'svm', num_classes:2});

// create a net
var net = new convnetjs.Net();
net.makeLayers(layer_defs);

// example that uses adadelta. Reasonable for beginners.
var trainer = new convnetjs.Trainer(net, {
  method: 'adadelta',
  l2_decay: 0.001,
  batch_size: 10
});

// ~750 records indicating failure
data.forEach((collection, index) => {
  var x = new convnetjs.Vol(1,1,4, 0.0)

  collection.forEach((dataPoint, index) => {
    x.w[index] = dataPoint
  })
  console.log("x", x)

  // class 0 for failure
  trainer.train(x, 0)
})

passing_params = [
  .125,
  60,
  .25,
  .4,
]

testData = new convnetjs.Vol(1,1,4)
passing_params.forEach((dataPoint, index) => {
  testData.w[index] = dataPoint
})


console.log("testData", testData)
var scores = net.forward(testData); // pass forward through network
// scores is now a Vol() of output activations
console.log('score for class 0 is assigned:'  + scores.w[0]);
