" when reading patches directly from a patch queue (.hg/patches/), they aren't
" recognized as diffs, but they should be

autocmd BufRead * call <SID>hgpatch_check()

function s:hgpatch_check()
  if getline(1) =~ "# HG changeset.*"
    set filetype=diff
  endif
endfunction

