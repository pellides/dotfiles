let mapleader = ","
let maplocalleader = ","

" --- Auto-install vim-plug on Windows ---
let s:data_dir = stdpath('data') . '\site'
if empty(glob(s:data_dir . '\autoload\plug.vim'))
  echo "Downloading junegunn/vim-plug to manage plugins..."
  silent execute '!powershell -NoProfile -Command "New-Item -ItemType Directory -Force -Path ''' . s:data_dir . '\autoload''; Invoke-WebRequest -Uri ''https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'' -OutFile ''' . s:data_dir . '\autoload\plug.vim''"'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

silent! call plug#begin(stdpath('data') . '\plugged')
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'lervag/vimtex'
call plug#end()

" --- General & UI Settings ---
set title
colorscheme vim
set fileformat=unix
set nohlsearch
set clipboard+=unnamedplus
set noshowmode
set noruler
set laststatus=0
set noshowcmd
set linebreak
set ts=4 sw=4
set encoding=utf-8
set number relativenumber
set wildmode=longest,list,full
set splitbelow splitright

filetype plugin indent on
syntax enable

" --- VimTeX Settings (Windows) ---
" Change to 'sumatrapdf' if you install SumatraPDF on Windows
let g:vimtex_view_method = 'general'
let g:vimtex_compiler_method = 'latexmk'

" Compile with XeLaTeX and open PDF with Windows default viewer
function! CompileWithXeLaTeX()
  write
  let l:texfile = expand('%')
  let l:pdffile = expand('%:r') . '.pdf'
  execute '!xelatex -interaction=nonstopmode ' . shellescape(l:texfile)
  if filereadable(l:pdffile)
    silent execute '!start "" ' . shellescape(l:pdffile)
  endif
endfunction
nnoremap <leader>gg :call CompileWithXeLaTeX()<CR>

" --- Global Mathematical Symbols (Works in default/unnamed buffers) ---
lua << EOF
local math_symbols = {
  ["\\land"] = "∧",
  ["\\lor"] = "∨",
  ["\\lnot"] = "¬",
  ["\\neg"] = "¬",
  ["\\implies"] = "⇒",
  ["\\iff"] = "⇔",
  ["\\to"] = "→",
  ["\\mapsto"] = "↦",
  ["\\forall"] = "∀",
  ["\\exists"] = "∃",
  ["\\nexists"] = "∄",
  ["\\in "] = "∈ ",
  ["\\notin"] = "∉",
  ["\\subset "] = "⊂ ",
  ["\\subseteq"] = "⊆",
  ["\\cup"] = "∪",
  ["\\cap"] = "∩",
  ["\\emptyset"] = "∅",
  ["\\neq"] = "≠",
  ["\\leq"] = "≤",
  ["\\geq"] = "≥",
  ["\\approx"] = "≈",
  ["\\equiv"] = "≡",
  ["\\pm"] = "±",
  ["\\times"] = "×",
  ["\\cdot"] = "·",
  ["\\infty"] = "∞",
  ["\\partial"] = "∂",
  ["\\nabla"] = "∇",
  ["\\sum"] = "∑",
  ["\\prod"] = "∏",
  ["\\int"] = "∫",
  ["\\sqrt"] = "√",
  ["\\alpha"] = "α",
  ["\\beta"] = "β",
  ["\\gamma"] = "γ",
  ["\\delta"] = "δ",
  ["\\epsilon"] = "ε",
  ["\\theta"] = "θ",
  ["\\lambda"] = "λ",
  ["\\mu"] = "μ",
  ["\\pi"] = "π",
  ["\\sigma"] = "σ",
  ["\\phi"] = "φ",
  ["\\omega"] = "ω",
  ["\\Delta"] = "Δ",
  ["\\Sigma"] = "Σ",
  ["\\Omega"] = "Ω",
}

for lhs, rhs in pairs(math_symbols) do
  vim.keymap.set("i", lhs, rhs, { noremap = true, silent = true })
end
EOF

" Type the command followed by Space or Enter to expand
" --- Tabs, Splits & Navigation ---
nnoremap <leader>e :new<CR>
nnoremap <leader>t :tabedit<CR>
nnoremap <leader>f :find<Space>
nnoremap <leader>q :q!<CR>
nnoremap <leader>w :w!<CR>
inoremap <leader>w <ESC>:w!<CR>
nnoremap <leader>n :next<CR>
nnoremap <leader>p :prev<CR>

nnoremap <leader>v :vsplit<CR>
nnoremap <leader>s :split<CR>

" Split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" --- Editing & Quality of Life ---
nnoremap c "_c
vnoremap . :normal .<CR>
nnoremap S :%s//g<Left><Left>
map Q gq
map <leader>o :setlocal spell! spelllang=en_us<CR>

" Disable automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Filetype associations
let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex

" Strip trailing whitespace and blank lines at EOF on save
autocmd BufWritePre * let currPos = getpos(".")
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e
autocmd BufWritePre *.[ch] %s/\%$/\r/e
autocmd BufWritePre * call cursor(currPos[1], currPos[2])

" --- Greek Keyboard Layout Mappings ---
nmap υυ yy
nmap π p
nmap ι i
nmap ε e
nmap σ s
nmap Σ S
nmap β b
nmap δδ dd
nmap ς w
nmap ο o
nmap Ο O
nmap <leader>ς :w!<CR>
nmap <leader>; :q!<CR>

nmap κ k
nmap ξ j
nmap η h
nmap λ l
nmap Η H
nmap Λ L

" --- vim-airline ---
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.colnr = ' C:'
let g:airline_symbols.linenr = ' L:'
let g:airline_symbols.maxlinenr = '☰ '

" --- Diff Highlighting ---
if &diff
    highlight! link DiffText MatchParen
endif

" --- Toggle Bottom Statusbar ---
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <leader>h :call ToggleHiddenAll()<CR>
