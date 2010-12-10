" gdocs.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2010-12-10.
" @Last Change: 2010-12-10.
" @Revision:    72


if !exists('g:gdocs#google')
    " The filename of the google command-line client.
    let g:gdocs#google = 'google'   "{{{2
endif
if !executable(g:gdocs#google)
    echoerr 'GDocs: Cannot find the google command-line client: Please set g:gdocs#google: '. g:gdocs#google
endif


if !exists('g:gdocs#editor')
    " The editor comand
    let g:gdocs#editor = v:progname   "{{{2
    if has('clientserver')
        let g:gdocs#editor .= ' --remote-wait-silent'
    endif
endif
" if !executable(g:gdocs#editor)
"     echoerr 'GDocs: Cannot execute the editor: Please set g:gdocs#editor: '. g:gdocs#editor
" endif


if !exists('g:gdocs#user')
    " The user name.
    " If empty, assume you're already authenticated.
    let g:gdocs#user = ''   "{{{2
endif


function! gdocs#Edit(doc_name) "{{{3
    if empty(a:doc_name)
        let doc_name = s:SelectDoc()
    else
        let doc_name = a:doc_name
    endif
    if empty(doc_name)
        echom 'GDocs: No document'
    else
        let args = ['--skip-auth', '--editor='. string(g:gdocs#editor)]
        " if !empty(g:gdocs#user)
        "     call add(args, '--user='. string(g:gdocs#user))
        " endif
        exec 'silent !' g:gdocs#google 'docs edit' shellescape(doc_name) join(args, ' ') '&'
    endif
endf


function! gdocs#SaveAs(doc_name) "{{{3
    if exists('b:gdocs')
        echohl WarningMsg
        echom 'GDocs: You have already uploaded this document to google docs.'
        echom 'GDocs: You will this end up with two files of the same name.'
        echohl NONE
    endif
    if empty(a:doc_name)
        let doc_name = expand('%:p')
    else
        let doc_name = a:doc_name
    endif
    let args = ['--skip-auth', '--format=txt', '--title='. string(fnamemodify(doc_name, ':t'))]
    " if !empty(g:gdocs#user)
    "     call add(args, '--user='. string(g:gdocs#user))
    " endif
    exec '!' g:gdocs#google 'docs upload' shellescape(doc_name) join(args, ' ')
    let b:gdocs = 1
endf


let s:docs = []

function! gdocs#Complete(ArgLead, CmdLine, CursorPos) "{{{3
    if empty(a:ArgLead)
        let s:docs = split(system(g:gdocs#google .' docs list'), '\n')
    endif
    let docs = copy(s:docs)
    call map(docs, 'matchstr(v:val, ''^[^,]\+'')')
    if !empty(a:ArgLead)
        call filter(docs, 'strpart(v:val, 0, len(a:ArgLead) == a:ArgLead)')
    endif
    return docs
endf


function! s:SelectDoc() "{{{3
    let docs = gdocs#Complete('', '', 0)
    if exists('g:loaded_tlib')
        let doc = tlib#input#List('s', 'Select a document', docs)
    else
        let doclist = ['Select a document:']
        let i = 1
        for doc in docs
            call add(doclist, i .'. '. doc)
            let i += 1
        endfor
        let doci = inputlist(doclist)
        if doci > 0
            let doc = docs[doci - 1]
        else
            let doc = ''
        endif
    endif
    " TLogVAR doc
    return doc
endf


