command: "sys-mon-set.widget/netstat.widget/scripts/netst"

refreshFrequency: 1000

style: """
  bottom: 10px
  right: 860px
  color: #fff
  font-family: Helvetica Neue
  background: rgba(0, 0, 0, 0.5)
  padding: 13px
  border-radius: 5px

  div
    display: block
    text-shadow: 0 0 1px rgba(#000, 0.5)
    font-size: 18px
    font-weight: 100

  p
    margin: 0

  p > span
    font-weight: normal


"""


render: -> """
  <div class='netstat'>
  	<p>In: <span id="in"></span></p>
  	<p>Out: <span id="out"></span></p>
  </div>
"""


update: (output, domEl) ->
  bytesToSize = (bytes) ->
    return "0 Byte"  if parseInt(bytes) is 0
    k = 1024
    sizes = [
      "b/s"
      "kb/s"
      "mb/s"
      "gb/s"
      "gb/s"
      "pb/s"
      "eb/s"
      "zb/s"
      "yb/s"
    ]
    i = Math.floor(Math.log(bytes) / Math.log(k))
    (bytes / Math.pow(k, i)).toPrecision(3) + " " + sizes[i]
  values = output.split(' ')
  $(domEl).find('#in').text(bytesToSize(values[0]))
  $(domEl).find('#out').text(bytesToSize(values[1]))
