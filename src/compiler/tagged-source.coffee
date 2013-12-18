sample_source = """
defmodule MyList do # ::my-mylist::
  # ::len::
  def len([]), do: 0
  def len([_head | tail]), do: 1 + len(tail) # ::len-2::
  # ::len-end::

  # ::square::
  def square([]), do: []
  def square([ head | tail ]), do: [ head*head | square(tail) ] # ::square-2::
  # ::end-square::
end # ::end-mylist::
"""

_ = require "lodash"

# Utility to represent a tagged source file. This is useful for extracting
# lines, or referencing lines by tags for other purposes (like annotation and
# highlighting)
class TaggedSource
  tagNameRE = "[a-zA-Z][a-zA-Z1-9-_]+" # conservative tag pattern

  constructor: (@source, comment, commentEnd=null) ->
    @tagre = new RegExp("# ::(#{tagNameRE})::")
    @tags = {}
    @original_lines = @source.split(/\r?\n/)
    # strip tags
    @lines = @_extractTags()

    # index of selected lines. Initially all.
    @selectedLines = [0...@lines.length]

  select: (addr) ->
    @selectedLines = _.union @selectedLines, @addr(addr)

  deselect: (addr) ->
    @selectedLines = _.difference @selectedLines, @addr(addr)

  selectNone: ->
    @selectedLines = []

  # Extracts tags from lines, and strip them from the source.
  _extractTags: ->
    for line, lineno in @original_lines
      if match = @tagre.exec(line)
        # store the tagged line
        tagData = match[1]
        tags = tagData.split(",")
        for tag in tags
          @tags[tag] = lineno

        # strip out the tag
        line.replace(@tagre,"")
      else
        line

  # Returns line number of a tag. Raises if tag doesn't exist.
  #
  # Can modify a tag's position with ":+n", or ":-n", for n lines after or before the tag.
  at: (tagMod) ->
    [tag, modify] = tagMod.split(":")
    pos = @tags[tag]
    if pos == undefined
      throw "Tag not found: #{tag}"

    if modify
      i = parseInt(modify)
      throw "Tag position modifier is not a number: #{tagMod}" if isNaN(i)
      pos = pos + i

    # throw if position is out of range
    if pos < 0 or pos >= @lines.length
      throw "Tag position is outside the range of source: #{tagMod}"

    pos

  # Returns an array of line numbers for an address.
  #
  # An address can be,
  #
  # 1. A tag. Returns the tagged line.
  # 2. Two tags separated by /~?,~?/. Returns lines between two tags.
  #
  # tag1 - a line
  # tag1,tag2 - lines between two tags
  addr: (addr) ->
    tags = addr.split(",")
    if tags.length == 1
      tag = tags[0]
      [@at(tag)]
    else
      tag1 = tags[0]
      tag2 = tags[1]
      @betweenTags(tag1,tag2)

  # Returns line numbers between two tags.
  betweenTags: (tag1,tag2) ->
    i = @at(tag1)
    j = @at(tag2)
    [i..j]

class TaggedSource.PositionError extends Error

module.exports = TaggedSource