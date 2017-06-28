" Neoformat - Prettier
autocmd BufWritePre *.js Neoformat
autocmd FileType javascript setlocal formatprg=prettier\ --stdin\ --single-quote\ --no-semi
let g:neoformat_try_formatprg = 1
