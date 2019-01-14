command: "ps axo \"rss,pid,ucomm\" | sort -nr | head -n3 | awk '{printf \"%8.0f,%s,%s\\n\", $1/1024, $3, $2}'"

refreshFrequency: 5000

style: """
  bottom: 10px
  right: 10px
  color: #fff
  font-family: Helvetica Neue
  background: rgba(0, 0, 0, 0.5)
  padding: 11px 10px
  border-radius: 5px

  table
    border-collapse: collapse
    width: 160px

  td
    font-size: 12px
    font-weight: normal
    overflow: ellipsis
    text-shadow: 0 0 1px rgba(#000, 0.5)
    text-align: right
    &:last-of-type
      padding-left: 10px


"""


render: ->
  """
  <table>
    <tr id="row-1"></tr>
    <tr id="row-2"></tr>
    <tr id="row-3"></tr>
  </table>
"""

update: (output, domEl) ->
  processes = output.split('\n')
  table     = $(domEl).find('table')

  renderProcess = (mem, name) ->
    "<td>#{name}</td><td>#{mem}</td>"

  for process, i in processes
    args = process.split(',')
    table.find("#row-#{i+1}").html renderProcess(args...)

