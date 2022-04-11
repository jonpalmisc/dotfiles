local fennel = require 'fennel'

table.insert(package.loaders or package.searchers, fennel.searcher)
fennel.dofile('init.fnl', { allowedGlobals = false })
