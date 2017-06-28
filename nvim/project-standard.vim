let g:neomake_javascript_standard_exe = nrun#Which('standard')
let g:neomake_javascript_enabled_makers = ['standard']

let g:neomake_jsx_standard_exe = nrun#Which('standard')
let g:neomake_jsx_enabled_makers = ['standard']

let g:neomake_scss_stylelint_exe = nrun#Which('stylelint')
let g:neomake_scss_enabled_makers = ['stylelint']

let g:neomake_scss_enabled_makers = ['stylelint']
let g:neomake_scss_stylelint_maker = {
\ 'exe': nrun#Which('stylelint'),
\ 'args': ['--syntax', 'scss'],
\ 'errorformat': 
  \ '%+P%f,' . 
      \ '%*\s%l:%c  %t  %m,' .
  \ '%-Q'
\ }
