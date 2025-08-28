#! /usr/bin/tcsh
# scr_fast.csh
# Fast Part1 traversal for AoC 2023 Day 10 using tcsh.
# Usage: ./scr_fast.csh input.txt [debug]
if ($#argv < 1) then
  echo "Usage: $0 input.txt [debug]"
  exit 1
endif

set file = "$1"
set debug = 0
if ($#argv >= 2) set debug = $2

# ----- Read grid into a flat array of symbols (one awk call) -----
# awk prints each character on its own line -> capture to symbols array
set symbols = ( `awk '{ for (i=1;i<=length($0);i++) print substr($0,i,1) }' $file` )

# ----- determine grid dimensions -----
# height = number of lines in file
set ht = `wc -l < $file`
# width = length of first line (use awk)
set wd = `awk 'NR==1{print length($0); exit}' $file`

if ($debug) then
  echo "Grid: rows=$ht cols=$wd  (total symbols = $#symbols)"
endif

# ----- convenience: compute flat index -----
# index(r,c) = (r-1)*wd + c   (r and c are 1-based)
# We will use @ for arithmetic to avoid subshells.

# ----- find S index -----
set sidx = 0
@ total = $#symbols
@ r = 1
@ c = 1
@ idx = 1
while ($idx <= $total)
  if ("$symbols[$idx]" == "S") then
    set sidx = $idx
    break
  endif
  @ idx++
end

if ($sidx == 0) then
  echo "Start 'S' not found"
  exit 2
endif

# helper: compute neighbor indices
# north = idx - wd ; south = idx + wd ; west = idx - 1 ; east = idx + 1

# helper: determine connection directions for a symbol
# We represent directions by letters N E S W
# Returns two directions in variables dirA dirB (space-separated strings)
# Because tcsh has no functions easily, use an inline case block when needed.

# ----- infer S's real piece by testing neighbor mutual connections -----
# For each direction, check if neighbor exists and neighbor's char connects back.
set dirs_found = ()        # collect connected directions for S

# check N
@ nidx = $sidx - $wd
if ($nidx >= 1) then
  set nchar = $symbols[$nidx]
  switch ($nchar)
    case "|": 
    case "7": 
    case "F": 
              set dirs_found = ( $dirs_found N ); breaksw
    case "L": 
    case "J": 
    case "-": 
              breaksw
    default:  
              breaksw
  endsw
endif

# check S
@ s2idx = $sidx + $wd
@ maxidx = $#symbols
if ($s2idx <= $maxidx) then
  set schar = $symbols[$s2idx]
  switch ($schar)
    case "|": 
    case "L": 
    case "J": 
              set dirs_found = ( $dirs_found "S" ); breaksw
    case "-": 
    case "F": 
    case "7": 
              breaksw
    default: 
              breaksw
  endsw
endif

# check W
@ widx = $sidx - 1
if ($widx >= 1) then
  set wchar = $symbols[$widx]
  switch ($wchar)
    case "-": 
    case "J": 
    case "7": 
              set dirs_found = ( $dirs_found "W" ); breaksw
    case "|": 
    case "L": 
    case "F": 
              breaksw
    default: 
              breaksw
  endsw
endif

# check E
@ eidx = $sidx + 1
if ($eidx <= $maxidx) then
  set echar = $symbols[$eidx]
  switch ($echar)
    case "-": 
    case "L": 
    case "F": 
              set dirs_found = ( $dirs_found "E" ); breaksw
    case "|": 
    case "J": 
    case "7": 
              breaksw
    default: 
              breaksw
  endsw
endif

if ($#dirs_found != 2) then
  if ($debug) then
    echo "Warning: inferred S connections count != 2 : $#dirs_found"
    echo "dirs_found: $dirs_found"
  endif
endif

# map direction pair to piece char
set s_piece = "?"
set pair = "$dirs_found[1]$dirs_found[2]"
# normalize order so mapping works (two possible orders)
if ("$pair" == "NS" || "$pair" == "SN") set s_piece = "|"
if ("$pair" == "EW" || "$pair" == "WE") set s_piece = "-"
if ("$pair" == "NE" || "$pair" == "EN") set s_piece = "L"
if ("$pair" == "NW" || "$pair" == "WN") set s_piece = "J"
if ("$pair" == "SW" || "$pair" == "WS") set s_piece = "7"
if ("$pair" == "SE" || "$pair" == "ES") set s_piece = "F"

if ($s_piece == "?") then
  echo "Could not infer S piece; dirs: $dirs_found"
  exit 3
endif

# replace S in symbols with inferred piece to simplify traversal
set symbols[$sidx] = $s_piece

if ($debug) then
  echo "S at idx=$sidx inferred piece='$s_piece'"
endif

# ----- helper inline subroutines implemented by repeated case logic -----
# Because tcsh lacks real functions, we'll use repeated case blocks where needed.

# ----- traversal: follow loop starting from S -----
# pick one of S's directions to start: choose dirs_found[1]
set start_dir = $dirs_found[1]
# compute first neighbor index based on start_dir
if ("$start_dir" == "N") then
  @ curr = $sidx - $wd
else if ("$start_dir" == "S") then
  @ curr = $sidx + $wd
else if ("$start_dir" == "W") then
  @ curr = $sidx - 1
else
  @ curr = $sidx + 1
endif

if ($debug) then
  echo "Starting traversal: start_dir=$start_dir start neighbor idx=$curr"
endif

set prev = $sidx
set visited = ( $sidx )   # collect visited indices in order
@ steps = 0

# loop until we arrive back at sidx
while (1)
  @ steps++
  # guard
  if ($curr < 1 || $curr > $maxidx) then
    echo "Error: out-of-bounds at idx=$curr"
    exit 4
  endif

  # push current to visited
  set visited = ( $visited $curr )

  # if we reached S, break
  if ($curr == $sidx) then
    if ($debug) then
      echo "Returned to S after $steps steps"
    endif
    break
  endif

  # determine symbol at curr and its two connection directions
  set sym = $symbols[$curr]
  set dA = ""
  set dB = ""
  switch ($sym)
    case "|": 
              set dA = "N"; set dB = "S"; breaksw
    case "-": 
              set dA = "E"; set dB = "W"; breaksw
    case "L":  
              set dA = "N"; set dB = "E"; breaksw
    case "J": 
              set dA = "N"; set dB = "W"; breaksw
    case "7": 
              set dA = "S"; set dB = "W"; breaksw
    case "F": 
              set dA = "S"; set dB = "E"; breaksw
    default:
      # unexpected symbol (e.g., .) - abort
      echo "Error: unexpected symbol '$sym' at idx=$curr"
      exit 5
  endsw

  # compute neighbor indices for both directions
  if ("$dA" == "N") then 
     @ nA = $curr - $wd
  else if ("$dA" == "S") then 
     @ nA = $curr + $wd
  else if ("$dA" == "W") then 
     @ nA = $curr - 1
  else if ("$dA" == "E") then 
     @ nA = $curr + 1
  endif

  if ("$dB" == "N") then 
     @ nB = $curr - $wd
  else if ("$dB" == "S") then 
     @ nB = $curr + $wd
  else if ("$dB" == "W") then 
     @ nB = $curr - 1
  else if ("$dB" == "E") then 
     @ nB = $curr + 1
  endif

  # pick the neighbor that's not prev and that connects back to curr
  set next = 0

  # helper check for mutual connection: check neighbor char includes back-direction
  # implement inline: for neighbor nX, get char and see if it includes opposite direction
  foreach pair ( "${nA}:${dA}" "${nB}:${dB}" )
    set nidx = `echo $pair | cut -d: -f1`
    set fromdir = `echo $pair | cut -d: -f2`
    if ($nidx == $prev || $nidx < 1 || $nidx > $maxidx) then
       continue
    endif
    set nch = $symbols[$nidx]
    # determine what back-direction would be
    if ("$fromdir" == "N") then 
       set back = "S"
    else if ("$fromdir" == "S") then 
       set back = "N"
    else if ("$fromdir" == "E") then 
       set back = "W"
    else if ("$fromdir" == "W") then 
       set back = "E"
    endif

    # check if neighbor symbol includes back
    set ok = 0
    switch ($nch)
      case "|":
        if ("$back" == "N" || "$back" == "S") set ok = 1
        breaksw
      case "-":
        if ("$back" == "E" || "$back" == "W") set ok = 1
        breaksw
      case "L":
        if ("$back" == "N" || "$back" == "E") set ok = 1
        breaksw
      case "J":
        if ("$back" == "N" || "$back" == "W") set ok = 1
        breaksw
      case "7":
        if ("$back" == "S" || "$back" == "W") set ok = 1
        breaksw
      case "F":
        if ("$back" == "S" || "$back" == "E") set ok = 1
        breaksw
      default:
        set ok = 0
    endsw

    if ($ok == 1) then
      @ next = $nidx
      break
    endif
  end

  if ($next == 0) then
    echo "Traversal stuck at idx=$curr (no valid next)"
    exit 6
  endif

  # advance
  set prev = $curr
  set curr = $next

  if ($debug) then
    echo "step $steps -> curr=$curr prev=$prev (sym=$sym)"
  endif

end # end while

# steps currently counts transitions until return to S (includes final step)
# visited holds sequence of indices starting with S and ending with S
@ visited_count = $#visited

echo "LOOP_VISITED_COUNT = $visited_count"
# If you want the Part1 answer as half the cycle (as some approaches), print:
@ part1_ans = $visited_count / 2
echo "PART1 (len/2) = $part1_ans"

# Optionally write visited indices to a file for Part 2
echo $visited > loop_indices.txt
if ($debug) then
  echo "visited indices saved to loop_indices.txt"
endif

exit 0

