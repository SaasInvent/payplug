config = require '../config/payplug.json'
ipn = require '../config/ipn.json'
uuid = require 'node-uuid'
querystring = require 'querystring'
fs = require 'fs'
forge = require('node-forge')
path = require('path')
#crypto = require('crypto')


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



      
#### ARCHIVES : !
      
      
      
#     console.log typeof req.body
#     console.log "Payplug Signature : "
#     console.log req.headers['payplug-signature']  
#     pemPublic = @getPayplugPublicKey()
#     console.log "Public key : "
#     console.log pemPublic
#     pemPrivate = @getYourPrivateKey()
#     privateKey = pki.privateKeyFromPem(pemPrivate) 
#     publicKey = pki.publicKeyFromPem(pemPublic)       
    
    

#     md = forge.md.sha1.create()
#     md.update('sign this', 'utf8')
    
#     signature = privateKey.sign(md)
    
#     verified = publicKey.verify(md.digest().bytes(), signature)
#     console.log verified  
  
    # signer = crypto.createSign('sha1')
     # signer.update('hola');
    # signer.update(req.body)    
   #  sign = signer.sign(privateKey,'base64')  
  
#     console.log data
#     pki = forge.pki

    
#     sign = crypto.createSign('RSA-SHA1')
#     sign.update(data64)    
#     sig = sign.sign(privateKey, 'base64')
    
#     verify = crypto.createVerify('RSA-SHA1')
#     verify.update(sig)
#     verified = verify.verify(publicKey, data64, 'base64')
#     console.log "verified : "

   # data = JSON.stringify req.body
#    data = "abcedef"
#    data64 = new Buffer(data).toString('base64')    
   # dataBuff = new Buffer(req.body, 'utf8')
   # dataUri = encodeURIComponent data
  #  console.log "data : "    
    
    
#    console.log crypto.getHashes()
    
    
  #  publicKey = pki.publicKeyFromPem(pemPublic)
 #   privateKey = pki.privateKeyFromPem(pemPrivate)
#     md = forge.md.sha1.create();
#  #   md.update(data, 'utf8')
#     md.update(data, 'utf8')
 
#     signature = forge.util.decode64(req.headers['payplug-signature'] )

#     #verify data with a public key
#    # console.log publicKey.verify(md.digest().bytes(), signature) 
#     verified = publicKey.verify(md.digest().bytes(), signature)is true
#     if (verified)
#       console.log "signature is valid!"
#       console.log typeof verified
#       return true
#     else
#       console.log "signature is invalid"
#       console.log typeof verified
#       return false
        
    #signature = req.headers['payplug-signature']  
#    signature = forge.util.decode64(req.headers['payplug-signature'] )
 
#    verifier = crypto.createVerify("SHA1")
#    verifier.update(encoded_json)
#    console.log "verified : "
#    console.log verifier.verify(publicKey, signature, "base64")    
 #     pki = forge.pki
#      console.log "req.body : "
#      console.log req.body

#      publicKey = @getPayplugPublicKey().toString()
#      verifier = crypto.createVerify('sha1')
#      console.log typeof req.body
#      console.log req.body.order
#      data = JSON.stringify req.body
#      dataSixtyFour=  new Buffer(data).toString('base64') 
#      signature64 = new Buffer(req.headers['payplug-signature']).toString('base64')
#      console.log "type of req.headers  : " + typeof req.headers['payplug-signature']
#      console.log "type of signature64 : "
#      console.log typeof signature64
#      console.log signature64
#      console.log "dataSixtyFour" + dataSixtyFour
#      console.log typeof dataSixtyFour
#      verifier.update(dataSixtyFour)
#      ver = verifier.verify(publicKey, signature64, 'base64')
#      #ver = verifier.verify(publicKey, req.headers['payplug-signature'], 'base64')
#      console.log(ver) 
  
  