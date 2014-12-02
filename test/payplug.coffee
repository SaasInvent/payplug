chai = require('chai')
should = require('chai').should()

chaiAsPromised = require('chai-as-promised')
chai.use(chaiAsPromised)

sinonChai = require('sinon-chai')
chai.use(sinonChai)

chaiAsPromised = require('chai-as-promised')
chai.use(chaiAsPromised)

expect = require('chai').expect
sinon = require('sinon')

assert = require('chai').assert
payplug = require('../lib/payplug.js')
Q = require 'q'


describe 'promises', ->
  it 'should pass if returning resolved promise', ->
    d = Q.defer()
    d.resolve("PASS")
    return d.promise
    
describe '#getCurrency' , ->
   it 'gets the local currency (EUR)', ->
      payplug.getCurrency().should.equal('EUR')
describe '#getAmountMax' , ->
   it 'gets the maximum Amount', ->
      payplug.getAmountMax().should.equal(5000)
describe '#getAmountMin' , ->
   it 'gets the minimum Amount', ->
      payplug.getAmountMin().should.equal(1)
describe '#getBaseUrl' , ->
   it 'gets the PayPlug base url', ->
      payplug.getBaseUrl().should.equal("https://www.payplug.fr/p/test/wRhc") 
describe '#getPayplugPublicKey' , ->
   it 'gets the PayPlug public key', ->
      expect(payplug.getPayplugPublicKey()).to.be.defined
describe '#getYourPrivateKey' , ->
   it 'gets your private key', ->
      expect(payplug.getYourPrivateKey()).to.be.defined
describe '#getIpnUrl' , ->
   it 'gets the base IPN URL', ->
      payplug.getIpnUrl().should.equal("http://t-www.working-box.com/payplug/payplugipn")         
describe '#getReturnUrl' , ->
   it 'gets the return IPN URL', ->
      payplug.getReturnUrl().should.equal("http://t-www.working-box.com/payplug/payplugreturn")     
describe '#getCancelUrl' , ->
   it 'gets the cancel IPN URL', ->
      payplug.getCancelUrl().should.equal("http://t-www.working-box.com/payplug/payplugcancel")   
describe '#createPayment' , ->
   it 'creates a payment for PayPlug', ->
      res = "res"
      options = 
          'amount' :  999
          'currency' : 'EUR',          
          'email' : 'john.doe@client.com',
          'first_name' : 'John',
          'last_name' : 'Doe'              
      expect(payplug.createPayment(res, options)).to.be.defined
 
describe '#verifySignature' , ->
   it 'verifies the IPN signature', ->
      expect(payplug.verifySignature()).to.be.defined      
      
      
      