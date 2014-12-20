@Digitalocean = {}
OAuth.registerService('digitalocean', 2, null, (query)->
  accessToken = getAccessToken(query)
  identity = getIdentity(accessToken)
  return {
    serviceData:
      id: identity.id
      accessToken: OAuth.sealSecret(accessToken)
      email:identity.email
      username: identity.login
    options:
      profile:
        name: identity.name
  }
)

userAgent = 'Meteor'
if Meteor.release
  userAgent += '/' + Meteor.release

getAccessToken = (query)->
  config = ServiceConfiguration.configurations.findOne({service:'digitalocean'})
  if !config
    throw new ServiceConfiguration.ConfigError()
  response = ''
  try
    response = HTTP.post(
      'https://cloud.digitalocean.com/v1/oauth/token',
        headers:
          Accept: 'application/json'
          'User-Agent': userAgent
        params:
          code: query.code
          client_id: config.clientId
          client_secret: OAuth.openSecret(config.secret)
          redirect_uri: OAuth._redirectUri('digitalocean', config)
          state: query.state
          grant_type: 'authorization_code'
    )

  catch err
    throw new Error('Failed to complete OAuth handshake with DigitalOcean. ' + response.data.error)

  if response.data.error
    throw new Error('Failed to complete OAuth handshake with DigitalOcean. ' + response.data.error)
  else
    return response.data.access_token

Digitalocean.retrieveCredential = (credentialToken, credentialSecret)->
  return Oauth.retrieveCredential(credentialToken, credentialSecret)
