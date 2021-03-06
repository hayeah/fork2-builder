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
#
# @property tags {String:Integer} mapping of tags to line numbers
# @property lineOfTag {Integer:String} inverse of @tags
# @property lines {[String]} Lines with source tags stripped
# @property selectedLines {[Integer]} line numbers of selected lines. Initially, all lines
class TaggedSource
  tagNameRE = "[a-zA-Z][a-zA-Z1-9-_]+" # conservative tag pattern

  constructor: (@source, comment, commentEnd=null) ->
    @tagre = new RegExp("# ::(#{tagNameRE})::")
    @tags = {}
    @original_lines = @source.split(/\r?\n/)

    [@lines,@tags] = @extractTags(@original_lines)
    @lineOfTag = []
    for tag, lineno of @tags
      @lineOfTag[lineno] = tag

    @selectAll()

  # Returns source lines meant for input. It also remove a line if all it has no content except the source tag.
  # @return {[Integer]} Line numbers of output lines.
  getOutputLines: ->
    numAsc = ((a,b) -> a - b)
    sortedLines = @selectedLines.sort numAsc
    output = []
    for i in sortedLines
      line = @lines[i]
      if @isEmptyTagLine(i)
        continue
      else
        output.push i

    return output

  isEmptyTagLine: (lineno) ->
    line = @lines[lineno]
    # console.log "isEmptyTagLine", [line.trim() == "",@lineOfTag,@lineOfTag[lineno]]
    line.trim() == "" && @lineOfTag[lineno] != undefined

  # Combines the selected lines.
  # @return {String}
  # getOutput: ->
  #   @getOutputLines().join "\n"

  selectAll: ->
    @selectedLines = [0...@lines.length]

  select: (addr) ->
    @selectedLines = _.union @selectedLines, @addr(addr)

  deselect: (addr) ->
    @selectedLines = _.difference @selectedLines, @addr(addr)

  selectNone: ->
    @selectedLines = []

  # Extracts tags from lines, and remove source tags from the source lines.
  # Return the extracted tags and cleaned up lines.
  #
  # @param {[Lines]} Lines of source code to extract tags from.
  # @return {[Lines,Tags]}
  extractTags: (sourceLines) ->
    tags = {}
    lines = for line, lineno in sourceLines
      if match = @tagre.exec(line)
        # This line is tagged
        tagData = match[1]
        newTags = tagData.split(",")

        # Add new tags
        for tag in newTags
          tags[tag] = lineno

        # Remove the tag
        line.replace(@tagre,"").trimRight()
      else
        # Untagged line. Return as is.
        line

    return [lines, tags]

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