semver = require 'semver'
path = require 'path'
log = require('lodge').debug('cush')

COFFEE = Symbol 'coffeescript'

module.exports = ->

  @hook 'package', (pack) ->
    return if !deps = pack.devDependencies
    return if !version = deps['coffeescript']

    deps = path.join pack.path, 'node_modules'
    try dep = require.resolve path.join(deps, 'coffeescript')
    catch err
      # TODO: Try again when node_modules/coffeescript is added.
      log.warn "'coffeescript' is not installed in '#{deps}'"
      return

    coffee = require dep
    if semver.satisfies coffee.VERSION, version
      pack[COFFEE] = coffee
      return

    log.warn """
      'coffeescript@#{coffee.VERSION}' is installed, \
      which does *not* satisfy #{version} from \
      '#{path.join pack.path, 'package.json'}'
    """

  exts = @get('coffee.exts')
  @transform exts, (asset, pack) =>

    result = pack[COFFEE].compile asset.content,
      filename: @relative asset.path
      sourceMap: true
      bare: true

    asset.ext = '.js'
    content: result.js
    map: JSON.parse result.v3SourceMap
