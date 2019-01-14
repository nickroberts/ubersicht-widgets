format = '%d %a %l:%M %p'

command: "date +\"#{format}\""

# the refresh frequency in milliseconds
refreshFrequency: 30000

render: (output) -> """
  <h1>#{output}</h1>
"""

style: """
  color: #FFFFFF
  font-family: Helvetica Neue
  right: 10px
  bottom: 90px
  background: rgba(0, 0, 0, 0.5)
  padding: 10px
  border-radius: 5px

  h1
    font-size: 5em
    font-weight: 100
    margin: 0
    padding: 0
  """
