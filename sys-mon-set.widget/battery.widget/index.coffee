command: "pmset -g batt | grep -o '[0-9]*%'"

refreshFrequency: 60000

style: """
  bottom: 210px
  right: 240px
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
  <div class='battery'></div>
"""

update: (output, domEl) ->
  $(domEl).find('.battery').html(output)

