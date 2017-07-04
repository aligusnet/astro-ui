AWS.config.update({region: 'us-east-1'});
AWS.config.credentials = new AWS.CognitoIdentityCredentials({IdentityPoolId: 'us-east-1:cd7e337b-aab5-4fd2-9817-c4eb0b3ab4cc'});

const lambda = new AWS.Lambda({region: 'us-east-1', apiVersion: '2015-03-31'});

var node = document.getElementById('astro');
var app = Elm.Main.embed(node);

app.ports.fetchAstroData.subscribe(function(request) {
  console.log(JSON.stringify(request));
  const pullParams = {
    FunctionName : 'astro',
    InvocationType : 'RequestResponse',
    LogType : 'None',
    Payload : JSON.stringify(request)
  };

  lambda.invoke(pullParams, function(error, data) {
    if (error) {
      app.ports.fetchAstroDataError.send(error.message);
    } else {
      app.ports.fetchAstroDataSuccess.send(data.Payload);
    }
  });
});

app.ports.getPosition.subscribe(function() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      console.log("geolocation", position.coords);
      app.ports.getPositionSuccess.send(position.coords);
    });
  } else {
    app.ports.getPositionError.send("Geolocation is not supported");
  }
});
