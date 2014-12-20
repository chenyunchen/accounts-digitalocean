@Digitalocean = {}

Digitalocean.requestCredential = (options, credentialRequestCompleteCallback)->
  if !credentialRequestCompleteCallback and typeof options is 'function'
    credentialRequestCompleteCallback = options
    options = {}

  config = ServiceConfiguration.configurations.findOne({service: 'digitalocean'})

  if !config
    credentialRequestCompleteCallback and credentialRequestCompleteCallback(new ServiceConfiguration.ConfigError())
    return
  credentialToken = Random.secret()

  scope = options and options.requestPermissions or []
  flatScope = _.map(scope, encodeURIComponent).join('+')

  loginStyle = OAuth._loginStyle('digitalocean', config, options)

  loginUrl =
    'https://cloud.digitalocean.com/v1/oauth/authorize' +
    '?client_id=' + config.clientId +
    '&scope=read write' +
    '&redirect_uri=http%3A%2F%2F127.0.0.1%3A3000%2F_oauth%2Fdigitalocean' +
    '&state=' + OAuth._stateParam(loginStyle, credentialToken) +
    '&response_type=code'

  OAuth.launchLogin({
    loginService: 'digitalocean'
    loginStyle: loginStyle
    loginUrl: loginUrl
    credentialRequestCompleteCallback: credentialRequestCompleteCallback
    credentialToken: credentialToken
    popupOptions: {width: 900, height: 450}
  })
