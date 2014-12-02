var Q, assert, chai, chaiAsPromised, expect, payplug, should, sinon, sinonChai;

chai = require('chai');

should = require('chai').should();

chaiAsPromised = require('chai-as-promised');

chai.use(chaiAsPromised);

sinonChai = require('sinon-chai');

chai.use(sinonChai);

chaiAsPromised = require('chai-as-promised');

chai.use(chaiAsPromised);

expect = require('chai').expect;

sinon = require('sinon');

assert = require('chai').assert;

payplug = require('../lib/payplug.js');

Q = require('q');

describe('promises', function() {
  return it('should pass if returning resolved promise', function() {
    var d;
    d = Q.defer();
    d.resolve("PASS");
    return d.promise;
  });
});

describe('#getCurrency', function() {
  return it('gets the local currency (EUR)', function() {
    return payplug.getCurrency().should.equal('EUR');
  });
});

describe('#getAmountMax', function() {
  return it('gets the maximum Amount', function() {
    return payplug.getAmountMax().should.equal(5000);
  });
});

describe('#getAmountMin', function() {
  return it('gets the minimum Amount', function() {
    return payplug.getAmountMin().should.equal(1);
  });
});

describe('#getBaseUrl', function() {
  return it('gets the PayPlug base url', function() {
    return payplug.getBaseUrl().should.equal("https://www.payplug.fr/p/test/wRhc");
  });
});

describe('#getPayplugPublicKey', function() {
  return it('gets the PayPlug public key', function() {
    return expect(payplug.getPayplugPublicKey()).to.be.defined;
  });
});

describe('#getYourPrivateKey', function() {
  return it('gets your private key', function() {
    return expect(payplug.getYourPrivateKey()).to.be.defined;
  });
});

describe('#getIpnUrl', function() {
  return it('gets the base IPN URL', function() {
    return payplug.getIpnUrl().should.equal("http://t-www.working-box.com/payplug/payplugipn");
  });
});

describe('#getReturnUrl', function() {
  return it('gets the return IPN URL', function() {
    return payplug.getReturnUrl().should.equal("http://t-www.working-box.com/payplug/payplugreturn");
  });
});

describe('#getCancelUrl', function() {
  return it('gets the cancel IPN URL', function() {
    return payplug.getCancelUrl().should.equal("http://t-www.working-box.com/payplug/payplugcancel");
  });
});

describe('#createPayment', function() {
  return it('creates a payment for PayPlug', function() {
    var options, res;
    res = "res";
    options = {
      'amount': 999,
      'currency': 'EUR',
      'email': 'john.doe@client.com',
      'first_name': 'John',
      'last_name': 'Doe'
    };
    return expect(payplug.createPayment(res, options)).to.be.defined;
  });
});

describe('#verifySignature', function() {
  return it('verifies the IPN signature', function() {
    return expect(payplug.verifySignature()).to.be.defined;
  });
});
