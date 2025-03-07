require "jp.options"
require "jp.packages"

-- Since we use package lazy-loading based on command names, we register
-- mappings separately from package initialization so that triggering these
-- mappings can load packages on demand.
require "jp.mappings"

-- Own plugin for Git rebase bindings.
require "jp.plugin.rebase"
