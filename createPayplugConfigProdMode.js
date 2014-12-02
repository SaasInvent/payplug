var rest = require('restler');
fs = require('fs');

rest.get('https://www.payplug.fr/portal/ecommerce/autoconfig', {
  
// adapt username and password
  
  username: 'your email',
  password: 'your password',
  
  
// don't touch below this!
 
}).on('complete', function(data) {
     // console.log(typeof data); // we get back an object!
     fs.writeFile("yourPrivateKey", data.yourPrivateKey, function(err) {
        if(err) {
          console.log(err);
        } else {
          console.log("yourPrivateKey");
        }
     }); 
  
      fs.writeFile("payplugPublicKey", data.payplugPublicKey, function(err) {
        if(err) {
          console.log(err);
        } else {
          console.log("payplugPublicKey");
        }
      }); 
  
      fs.writeFile("./config/payplug.json", JSON.stringify(data, null, 4), function(err) {
        if(err) {
          console.log(err);
        } else {
          console.log("config payplug.json");
        }
      });    
  
});
