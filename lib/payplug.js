var config, exports, forge, fs, ipn, path, querystring, uuid;

config = require('../config/payplug.json');

ipn = require('../config/ipn.json');

uuid = require('node-uuid');

querystring = require('querystring');

fs = require('fs');

forge = require('node-forge');

path = require('path');

module.exports = exports = {
  getCurrency: function() {
    return config.currencies[0];
  },
  getAmountMax: function() {
    return config.amount_max;
  },
  getAmountMin: function() {
    return config.amount_min;
  },
  getBaseUrl: function() {
    return config.url;
  },
  getPayplugPublicKey: function() {
    return fs.readFileSync(path.join(__dirname, '../', "payplugPublicKey"), "utf8");
  },
  getYourPrivateKey: function() {
    return fs.readFileSync(path.join(__dirname, '../', "yourPrivateKey"), "utf8");
  },
  getIpnUrl: function() {
    return ipn.ipn_url;
  },
  getReturnUrl: function() {
    return ipn.return_url;
  },
  getCancelUrl: function() {
    return ipn.cancel_url;
  },
  createPayment: function(res, options) {
    var data, payPLUGUrl;
    data = {
      'amount': options.amount,
      'currency': (options.currency != null) || 'EUR',
      'ipn_url': this.getIpnUrl(),
      'return_url': this.getReturnUrl(),
      'cancel_url': this.getCancelUrl(),
      'order': (options.order != null) || uuid.v1(),
      'email': options.email,
      'first_name': options.first_name,
      'last_name': options.last_name,
      'custom_data': (options.custom_data != null) || new Date().toString()
    };
    payPLUGUrl = this.prepareUrl(data);
    console.log("payPLUGUrl : " + payPLUGUrl);
    return this;
  },
  prepareUrl: function(data) {
    var base_url, dataSixtyFour, md, newUrl, param, pem, pki, privateKey, signature, signature64, urldata, urlsign;
    base_url = this.getBaseUrl();
    pem = this.getYourPrivateKey();
    pki = forge.pki;
    privateKey = pki.privateKeyFromPem(pem);
    param = querystring.stringify(data);
    console.log("param : " + param);
    dataSixtyFour = new Buffer(param).toString('base64');
    urldata = encodeURIComponent(dataSixtyFour);
    md = forge.md.sha1.create();
    md.update(param, 'utf8');
    signature = privateKey.sign(md);
    signature64 = forge.util.encode64(signature);
    urlsign = encodeURIComponent(signature64);
    newUrl = base_url + "?data=" + urldata + "&sign=" + urlsign;
    return newUrl;
  },
  verifySignature: function(req) {
    var order;
    order = req.body.order;
    return console.log("The following order exists and can be saved : " + order);
  }
};
