Accounts.oauth.registerService('digitalocean')

if Meteor.isClient
  Meteor.loginWithDigitalocean = (options, callback)->
    if !callback and typeof options is 'function'
      callback = options
      options = null

    credentialRequestCompleteCallback = Accounts.oauth.credentialRequestCompleteHandler(callback)
    Digitalocean.requestCredential(options, credentialRequestCompleteCallback)
else
  Accounts.addAutopublishFields({
    forLoggedInUser: ['services.digitalocean']
    forOtherUsers: ['services.digitalocean.username']
  })
