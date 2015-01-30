var R, config, crypto, exports, forge, fs, ipn, path, querystring, uuid;

config = require('../config/payplug.json');

ipn = require('../config/ipn.json');

uuid = require('node-uuid');

querystring = require('querystring');

fs = require('fs');

forge = require('node-forge');

path = require('path');

R = require('ramda');

crypto = require('crypto');

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
    var answer, data, deferred, payPLUGUrl;
    deferred = Q.defer();
    data = {
      'amount': options.amount,
      'currency': options.currency || 'EUR',
      'ipn_url': this.getIpnUrl(),
      'return_url': this.getReturnUrl(),
      'cancel_url': this.getCancelUrl(),
      'order': options.order || uuid.v1(),
      'email': options.email,
      'first_name': options.first_name,
      'last_name': options.last_name,
      'custom_data': options.custom_data || uuid.v1(),
      'custom_datas': options.custom_datas || uuid.v1()
    };
    payPLUGUrl = this.prepareUrl(data);
    answer = {
      'url': this.prepareUrl(data)
    };
    res.json(answer);
    return this;
  },
  prepareUrl: function(data) {
    var base_url, dataSixtyFour, md, newUrl, param, pem, pki, privateKey, signature, signature64, urldata, urlsign;
    base_url = this.getBaseUrl();
    pem = this.getYourPrivateKey();
    pki = forge.pki;
    privateKey = pki.privateKeyFromPem(pem);
    param = querystring.stringify(data);
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
    console.log("The following order exists and can be saved : " + order);
    return this.checkIdentity(req);
  },
  checkSignature: function(message, signature, pubkey) {
    var check;
    check = crypto.createVerify('SHA1');
    check.update(message);
    return check.verify(pubkey, signature, 'base64');
  },
  checkIdentity: function(req) {
    var message, pubkey, _check, _message, _sign;
    pubkey = this.getPayplugPublicKey().toString();
    _sign = forge.util.decode64(req.headers['payplug-signature']);
    message = R.mapObj(this.encodeUri, req.body);
    _message = querystring.stringify(message);
    _message = new Buffer(_message).toString('base64');
    _check = this.checkSignature(_message, _sign, pubkey);
    return console.log(_check);
  },
  encodeUri: function(value) {
    return value;
  }
};
