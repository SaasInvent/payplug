config = require '../config/payplug.json'
ipn = require '../config/ipn.json'
uuid = require 'node-uuid'
querystring = require 'querystring'
fs = require 'fs'
forge = require('node-forge')
path = require('path')
R = require('ramda')
crypto = require('crypto')
#Q = require('q')

module.exports = exports  = 

  getCurrency:  ->
    config.currencies[0]

  getAmountMax:  ->
    config.amount_max

  getAmountMin:  ->
    config.amount_min

  getBaseUrl:  ->
    config.url
  
  getPayplugPublicKey: ->
    fs.readFileSync(path.join(__dirname, '../', "payplugPublicKey"), "utf8")
     
  getYourPrivateKey: ->
    fs.readFileSync(path.join(__dirname, '../', "yourPrivateKey"), "utf8")    
#    fs.readFileSync("yourPrivateKey", "utf8")  

  getIpnUrl: ->
    ipn.ipn_url
    
  getReturnUrl: ->
    ipn.return_url
    
  getCancelUrl: ->
    ipn.cancel_url
 
  createPayment: (res, options) ->
#  createPayment: (options) ->        
#    console.log "In createPayment : options.order"
#    console.log options.order
#    console.log options.custom_data
#    console.log options.custom_datas
#    testid = uuid.v1()
#    console.log "testid : " + testid
    deferred = Q.defer()
    data = 
      'amount' : options.amount
      'currency' : options.currency ||'EUR'
      'ipn_url' : @getIpnUrl()
      'return_url' : @getReturnUrl()
      'cancel_url' : @getCancelUrl()
      'order' : options.order || uuid.v1()
      'email' : options.email
      'first_name' : options.first_name
      'last_name' : options.last_name 
      'custom_data' : options.custom_data || uuid.v1()
      'custom_datas' : options.custom_datas || uuid.v1()
    
    payPLUGUrl = @prepareUrl(data)
    
    answer =
       'url' : @prepareUrl(data)
#    console.log  "payPLUGUrl : " +  payPLUGUrl 
#    console.log answer
    res.json answer
#    deferred.resolve(answer)        
#    deferred.promise 
    @
     
    
  prepareUrl: (data) ->
     base_url = @getBaseUrl()  
     pem = @getYourPrivateKey()
      
     # convert a PEM-formatted private key to a Forge private key
     pki = forge.pki
     privateKey = pki.privateKeyFromPem(pem)         
      
      
     # data needs to be transormed to http query string
     param = querystring.stringify data
     
     # data has to be base64 encoded
     dataSixtyFour=  new Buffer(param).toString('base64') 
     
     # next dataSixtyFour needs to be urlencoded : use encodeURIComponent!
     urldata = encodeURIComponent dataSixtyFour

      
     # sign param with our private key
     md = forge.md.sha1.create()
     md.update(param, 'utf8')
     signature = privateKey.sign(md) 
      
     # base64 encode the signature
     signature64 = forge.util.encode64(signature) 
      
     # url encode the signature      
     urlsign = encodeURIComponent signature64       
      
     # create a new URL
     newUrl = base_url + "?data=" + urldata + "&sign=" + urlsign
     newUrl

      
  verifySignature : (req)->
    # We need to verify if there is an order for the payment in our database!
    # Your have to implement this for yourself!
    order = req.body.order
    console.log "The following order exists and can be saved : " + order
    @checkIdentity(req)
    



#  /**
#    * Checks if a message and its signature match with the given public key
#    * @param  {String} message   The message with format "field1=val1&field2=val2..."
#    * @param  {String} signature The RSA SHA1 signature of the message
#    * @param  {String} pubkey    The public key in UTF8
#    * @return {Boolean}          If the message is signed by the owner of the public key
#    */
  checkSignature : (message, signature, pubkey) ->
    
    check = crypto.createVerify('SHA1')
    check.update(message);
    return check.verify(pubkey, signature, 'base64')      
    
  checkIdentity : (req) ->
        pubkey = @getPayplugPublicKey().toString()
        _sign  = forge.util.decode64(req.headers['payplug-signature'])
        message = R.mapObj(@encodeUri, req.body)
        _message =  querystring.stringify message
        _message =  new Buffer(_message).toString('base64') 
        _check = @checkSignature(_message, _sign, pubkey)
        console.log _check
        
  encodeUri : (value) ->
    #encodeURIComponent value
    value
      
