command: "curl -s checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'"

refreshFrequency: 43200000

style: """
  bottom: 210px
  right: 330px
  color: #fff
  font-family: Helvetica Neue
  background: rgba(0, 0, 0, 0.5)
  padding: 10px
  border-radius: 5px

  div
    display: block
    text-shadow: 0 0 1px rgba(#000, 0.5)
    font-size: 24px
    font-weight: 100

"""


render: -> """
  <div class='ip_address'></div>
"""

update: (output, domEl) ->
  $(domEl).find('.ip_address').html(output)

