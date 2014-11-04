set nocompatible

syntax on
set background=dark
colorscheme desert

" Desactiver les touches directionnelles
" map <up> <nop>
" map <down> <nop>
" map <left> <nop>
" map <right> <nop>
" imap <up> <nop>
" imap <down> <nop>
" imap <left> <nop>
" imap <right> <nop>

" Sortir du mode insertion avec ,,
imap ;; <Esc>
map ;; <Esc>

let mapleader = ','

set title
set number " Numéro de ligne
set ruler  " Position du curseur
set wrap

set hidden      " pour lusty xplorer

" Recherche
set ignorecase
set smartcase   " Active la sensibilité a la casse si une majuscule est présente dans la recherche
set incsearch   " Surlignage pendant la saisie
set hlsearch
set cursorline


" Pathogen
call pathogen#infect()
call pathogen#helptags()

" set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)

set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2

" Parametres par defaut pour ack
let g:ackprg="ack -H --nocolor --nogroup --column"
" Place un marqueur et cherche
nmap <leader>j mA:Ack<space>
" Place un marqueur et cherche le mot sous le curseur
nmap <leader>ja mA:Ack "<C-r>=expand("<cword>")<cr>"
nmap <leader>jA mA:Ack "<C-r>=expand("<cWORD>")<cr>"

let g:ctrlp_map='<leader>c'

let g:airline#extensions#tabline#enabled = 1
set laststatus=2



