exts = ['.coffee', '.litcoffee', '.coffee.md']

module.exports = ->
  @merge 'exts', exts
  @merge 'coffee.exts', exts
  @worker 'worker.js'
