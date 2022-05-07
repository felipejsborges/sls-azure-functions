import { AzureFunction, Context } from '@azure/functions';

export const handler: AzureFunction = (context: Context, item): void => {
	try {
		context.log(`An Event Hubs message has triggered this function. Item: ${JSON.stringify(item)}`);
		context.done()
	} catch (err) {
		context.done(`An error occurred: ${JSON.stringify(err)}`)
	}
};
