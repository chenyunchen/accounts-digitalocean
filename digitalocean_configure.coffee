Template.configureLoginServiceDialogForDigitalocean.helpers({
  siteUrl: ()->
    Meteor.absoluteUrl()
})

Template.configureLoginServiceDialogForDigitalocean.fields = ()->
  [
    {property: 'clientId', label: 'Client Id'},
    {property: 'secret', label: 'Client Secret'}
  ]
