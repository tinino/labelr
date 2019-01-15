# borrowed from yihui/knitr
# change restore such that all (default, if empty) or just listed items will be restored.
new_defaults = function(value = list()) {
  defaults = value

  get = function(name, default = FALSE, drop = TRUE) {
    if (default) defaults = value  # this is only a local version
    if (missing(name)) defaults else {
      if (drop && length(name) == 1) defaults[[name]] else {
        setNames(defaults[name], name)
      }
    }
  }
  resolve = function(...) {
    dots = list(...)
    if (length(dots) == 0) return()
    if (is.null(names(dots)) && length(dots) == 1 && is.list(dots[[1]]))
      if (length(dots <- dots[[1]]) == 0) return()
    dots
  }
  set = function(...) {
    dots = resolve(...)
    if (length(dots)) defaults <<- merge(dots)
    invisible(NULL)
  }
  merge = function(values) knitr:::merge_list(defaults, values)
  restore = function(target = value) defaults <<- target
  append = function(...) {
    dots = resolve(...)
    for (i in names(dots)) dots[[i]] <- c(defaults[[i]], dots[[i]])
    if (length(dots)) defaults <<- merge(dots)
    invisible(NULL)
  }

  list(get = get, set = set, append = append, merge = merge, restore = restore)
}