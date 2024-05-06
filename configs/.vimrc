call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plug 'jparise/vim-graphql'        " GraphQL syntax
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc.nvim', {'branch': 'v0.0.78'}
call plug#end()

" CoC extensions
let g:coc_global_extensions = ['coc-tsserver']

let mapleader=' '

" settings

set number
set relativenumber
set linebreak
set scrolloff=999

set breakindent
set undofile
set colorcolumn=80
set updatetime=250
set timeoutlen=250
set splitright
set splitbelow

set list
set listchars=tab:»\ ,trail:·,nbsp:␣

" navigation remap

nmap <Leader>pv :Ex<CR>

nmap <leader>j <PageDown>
nmap <leader>k <PageUp>

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

