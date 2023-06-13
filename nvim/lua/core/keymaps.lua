vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Page down' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Jump left' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Jump down' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Jump up' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Jump right' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Page up' })
vim.keymap.set('n', '<S-TAB>', ':bp<CR>', { desc = 'Goto previous buffer' })
vim.keymap.set('n', '<TAB>', ':bn<CR>', { desc = 'Goto next buffer' })
vim.keymap.set('n', '<leader><leader>', '<cmd>Telescope find_files<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>@', 'q', { desc = 'Record macro' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Action' })
vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { desc = 'Format' })
vim.keymap.set('n', '<leader>dF', '<cmd>call delete(expand("%")) | bdelete!<CR>', { desc = 'Delete current file' })
vim.keymap.set('n', '<leader>db', '<cmd>b#<CR><cmd>bd#<CR>', { desc = 'Delete current buffer' })
vim.keymap.set('n', '<leader>f.', '<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>', { desc = 'Directory listing' })
vim.keymap.set('n', '<leader>fa', '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>', { desc = 'Find all files' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = 'Find help tags' })
vim.keymap.set('n', '<leader>fo', '<cmd>Telescope oldfiles<CR>', { desc = 'Find old files' })
vim.keymap.set('n', '<leader>fp', '<cmd>Telescope project<CR>', { desc = 'Find project' })
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope live_grep<CR>', { desc = 'Find with live search' })
vim.keymap.set('n', '<leader>gB', '<cmd>G blame<CR>', { desc = 'Git blame buffer' })
vim.keymap.set('n', '<leader>gb', function() package.loaded.gitsigns.blame_line { full = true } end, { desc = 'Git blame line' })
vim.keymap.set('n', '<leader>gg', '<cmd>Git<CR>', { desc = 'Git status' })
vim.keymap.set('n', '<leader>ot', '<cmd>belowright split | resize 15 | terminal<CR>', { desc = 'Open terminal' })
vim.keymap.set('n', '<leader>op', '<cmd>NvimTreeFindFile<CR>', { desc = 'Open file explorer' })
vim.keymap.set('n', '<leader>td', ":lua =(vim.diagnostic.is_disabled() and (vim.diagnostic.enable() or 'enabled')) or vim.diagnostic.disable() or 'disabled'<CR>", { desc = 'Toggle diagnostics' })
vim.keymap.set('n', '<leader>tp', '<cmd>NvimTreeFindFileToggle<CR>', { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<leader>tu', '<cmd>UndotreeToggle<CR>', { desc = 'Toggle undo tree' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev diagnostics' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostics' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Implementation' })
vim.keymap.set('n', 'go', vim.diagnostic.open_float, { desc = 'Open diagnostics' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'References' })
vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, { desc = 'Signature' })
vim.keymap.set('n', 'q', '<Esc>')
vim.keymap.set('n', 'q:', '<nop>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('v', 'J', ':m \'>+1<CR>gv=gv', { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ':m \'<-2<CR>gv=gv', { desc = 'Move selection up' })
vim.keymap.set({ 'i', 'c' }, '<C-a>', '<Home>', { desc = 'Beginning of line' })
vim.keymap.set({ 'i', 'c' }, '<C-e>', '<End>', { desc = 'End of line' })
vim.keymap.set({ 'n', 'v' }, '<leader>fw', '<cmd>Telescope grep_string<CR>', { desc = 'Find word' })
