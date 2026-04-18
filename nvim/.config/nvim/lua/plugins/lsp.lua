vim.lsp.enable({
	"bashls",
	"gopls",
	"lua_ls",
	"systemd_lsp",
})

local lsp_attach_aug = vim.api.nvim_create_augroup("LspAttachAug", { clear = true })

-- Emit a progress-message on LSP progress events:
vim.api.nvim_create_autocmd("LspProgress", {
	group = lsp_attach_aug,
	callback = function(args)
		local value = args.data.params.value
		vim.api.nvim_echo({ { value.message or "done" } }, false, {
			id = "lsp." .. args.data.params.token,
			kind = "progress",
			source = "vim.lsp",
			title = value.title,
			status = value.kind ~= "end" and "running" or "success",
			percent = value.percentage,
		})
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_attach_aug,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local highlight_aug = vim.api.nvim_create_augroup("LspHighlightAug", { clear = false })

			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				group = highlight_aug,
				buffer = args.buf,
				callback = vim.lsp.buf.document_highlight,
				desc = "Highlight references under cursor",
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				group = highlight_aug,
				buffer = args.buf,
				callback = vim.lsp.buf.clear_references,
				desc = "Clear reference highlights on move",
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("LspDetachAug", { clear = false }),
				buffer = args.buf,
				callback = function(ar)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "LspHighlightAug", buffer = ar.buf })
				end,
				desc = "Cleanup LSP highlights on detach",
			})
		end

		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end

		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
			vim.lsp.codelens.enable(true, { client = client.id, buf = args.buf })
		end
	end,
	desc = "LSP on attach",
})
