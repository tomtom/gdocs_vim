" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @GIT:         http://github.com/tomtom/
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2010-12-10.
" @Last Change: 2010-12-10.
" @Revision:    12
" GetLatestVimScripts: 0 0 :AutoInstall: gdocs.vim
" Edit google documents

if &cp || exists("loaded_gdocs")
    finish
endif
let loaded_gdocs = 1

let s:save_cpo = &cpo
set cpo&vim


" :display: :Gdocsedit [FILENAME]
" Edit a file. If none is given, users can select one from a list of 
" google documents.
command! -nargs=? -complete=customlist,gdocs#Complete Gdocsedit call gdocs#Edit(<q-args>)

" :display: :Gdocssaveas [FILENAME]
" Upload a file to google docs.
" FILENAME defaults to the current buffer.
command! -nargs=? -complete=customlist,gdocs#Complete Gdocssaveas call gdocs#SaveAs(<q-args>)


let &cpo = s:save_cpo
unlet s:save_cpo
