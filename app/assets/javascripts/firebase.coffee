uiConfig = ->
  'signInSuccessUrl': '/'
  'callbacks':
    'signInSuccess': (user) ->
      user.getIdToken().then (idToken) ->
        $('#credentials').val idToken
        $('#hidden-verified-label').show()
        $('.phone-verification-form').submit()
      false
  'signInFlow': 'popup'
  'signInOptions': [ {
    provider: firebase.auth.PhoneAuthProvider.PROVIDER_ID
    recaptchaParameters: size: 'invisible'
  } ]
  'tosUrl': 'https://blog.openhub.net/terms/'

initializeFirebase = ->
  firebase.initializeApp(
    apiKey: $('[name=firebase-consumer-key]').attr('content')
    authDomain: $('[name=firebase-app-url]').attr('content')
    projectId: $('[name=firebase-app-id]').attr('content')
  )

displayUI = ->
  ui = new firebaseui.auth.AuthUI(firebase.auth())
  ui.start '#firebaseui-auth-container', uiConfig()

startFirebase = ->
  initializeFirebase()
  displayUI()

$(document).on 'page:change', ->
  if $('#digits-sign-up').length
    $('#digits-sign-up').click ->
      $('#sign-up-options').remove()
      $('#sign-up-fields').show()
      startFirebase()
  else if $('#firebaseui-auth-container').length
    setTimeout(startFirebase, 1000)