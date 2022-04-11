set nocompatible

colorscheme elflord " Select a common color scheme

syntax on " Enable syntax higlighting

set wildmenu " Improved command line completion
set title  " Vim update terminal title
set number " Show line number
set wrap   " Enable line wrap
set textwidth=119 " Wrap on col 120
set showmatch " Show matching brackets when text indicator is over them

" Search 
set ignorecase " Ignore case
set smartcase  " Ignore case unless a cap letter exists in the pattern
set incsearch  " Move to matched string  
set hlsearch   " Highlight found strings

" Indentation style
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2

set encoding=utf8 " Set utf8 as standard encoding 
set ffs=unix " Use Unix as the standard file type

set laststatus=2 " Always(2) have a status line
set noshowmode " Don't duplicate mode information (lastatus=2)

filetype plugin on " Load plugins based on detected filetype
filetype indent on " Load indent configuration based on detected filetype
