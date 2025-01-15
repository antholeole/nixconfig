const vscode = require('vscode');

const channel = vscode.window.createOutputChannel('oleina', 'extension');

const getDoc = async () => {
	if (!vscode.window.activeTextEditor) {
		console.log("doc is already closed, could not get!");
		return undefined;
	}

	const doc = vscode.window.activeTextEditor.document;
	console.log(`current doc is ${doc.uri}`);
	return doc;
}


/**
 * @param {vscode.ExtensionContext} context
*/
function activate(context) {
	context.subscriptions.push(vscode.commands.registerCommand('w', () => {
		channel.appendLine("invoked w");
		getDoc().then(doc => {
			if (doc === undefined) {
				return;
			}

			doc.save().then(() => {
				channel.appendLine("saved doc, bye!");
			});
		})
	}));
	
	context.subscriptions.push(vscode.commands.registerCommand('wq', () => {
		channel.appendLine("invoked wq");
		getDoc().then(doc => {
			if (doc === undefined) {
				return;
			}

			doc.save().then(() => {
				channel.appendLine("saved doc");
			});

			const tabs = vscode.window.tabGroups.activeTabGroup.tabs;
			const currentIdx = tabs.findIndex(tab => tab.input instanceof vscode.TabInputText && tab.input.uri.path === doc.uri.path);

			if (currentIdx === -1) {
				channel.appendLine("cannot close, nothing is open");	
				return;
			}
			 
			vscode.window.tabGroups.close(tabs[currentIdx]).then(() => {
				channel.appendLine("closed tab!");
			});
		})
	}));
}

// eslint-disable-next-line no-undef
module.exports = {
	activate,
}
