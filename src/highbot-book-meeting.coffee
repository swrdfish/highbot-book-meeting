# Description
#   a hubot script to book meeting rooms
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot hello - <what the respond trigger does>
#   orly - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Binayak Ghosh <ghoshbinayak@gmail.com>

Axios = require 'axios'


module.exports = (robot) ->
  regex = /(\bbook.*meeting)|(\bsetup.*meeting)|(start.*meeting)/i

  robot.hear regex, (res) ->
    if res.message.token == undefined
      res.send 'thy shall not pass!'
    else
      Axios({
        url: '/me/findRooms',
        method: 'get',
        baseURL: 'https://graph.microsoft.com/beta/',
        headers: {'Authorization': 'Bearer ' + res.message.token},
        responseType: 'json', 
      }).then((response)=>
        list = ""
        for x in response.data.value
          list += "<li>" + x.name + "</li>"
        reply = "Here are a list of available rooms: <ol>" + list + "</ol></br> <i>unfortunately your boss won't let me book one :(</i>" 
        res.send reply
      ).catch((error) =>
        console.log(error)
        res.send 'oops, something went wrong.'
      )
