config = require '../config/payplug.json'
ipn = require '../config/ipn.json'
uuid = require 'node-uuid'
querystring = require 'querystring'
fs = require 'fs'
forge = require('node-forge')


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
    fs.readFileSync("payplugPublicKey", "utf8") 
     
  getYourPrivateKey: ->
    fs.readFileSync("yourPrivateKey", "utf8")  

  getIpnUrl: ->
    ipn.ipn_url
    
  getReturnUrl: ->
    ipn.return_url
    
  getCancelUrl: ->
    ipn.cancel_url
 
  createPayment: (res, options) ->
    data = 
      'amount' : options.amount
      'currency' : options.currency? ||'EUR'
      'ipn_url' : @getIpnUrl()
      'return_url' : @getReturnUrl()
      'cancel_url' : @getCancelUrl()
      'order' : options.order? || uuid.v1()
      'email' : options.email
      'first_name' : options.first_name
      'last_name' : options.last_name 
      'custom_data' : options.custom_data? || new Date().toString()
    
    payPLUGUrl = @prepareUrl(data)
    console.log  "payPLUGUrl : " +  payPLUGUrl     
  # res.redirect(payPLUGUrl)
    @
     
    
  prepareUrl: (data) ->
     base_url = @getBaseUrl()  
     pem = @getYourPrivateKey()
      
     # convert a PEM-formatted private key to a Forge private key
     pki = forge.pki
     privateKey = pki.privateKeyFromPem(pem)         
      
      
     # data needs to be transormed to http query string
     param = querystring.stringify data
     console.log "param : " + param
     
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

  verifySignature : (data)->
    console.log "verifySignature"
  
  
  